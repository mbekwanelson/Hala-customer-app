import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Models/FoodItem.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mymenu/States/DescriptionState.dart';
import 'package:provider/provider.dart';

class Description extends StatefulWidget {
  final FoodItem food;
  String category;

  Description({this.food, this.category});

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  bool orderSameShop = true;

  @override
  void initState() {
    // TODO: implement initState
    DescriptionState().checkIfSameShop(widget.food.shop).then((value) {
      setState(() {
        orderSameShop = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final descriptionState = Provider.of<DescriptionState>(context);
    widget.food.quantity = descriptionState.count;
    if (orderSameShop != true) {
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("You cannot order from more than 1 shop at a time",
              style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2)),
          Text("Please check out your previous orders",
              style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: 20))
        ],
      ));
    } else if (!widget.food.inStock) {
      //if out of stock
      return Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("This item is out of stock",
              style: TextStyle(
                  color: Colors.red[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: 2)),
        ],
      ));
    }
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            widget.food.title,
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: Image.network(
              widget.food.image,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 30),
          Text(
            "R ${widget.food.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                backgroundColor: Colors.red, //Colors.grey,
                onPressed: () {
                  setState(() {
                    widget.food.quantity = descriptionState.decreaseQuantity();
                  });
                },
                child: Icon(
                  Icons.remove,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                child: Center(
                    child: Text(
                  "${widget.food.quantity}",
                  style: TextStyle(
                    letterSpacing: 2,
                  ),
                )),
              ),
              FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  setState(() {
                    widget.food.quantity = descriptionState.addQuantity();
                  });
                },
                child: Icon(
                  Icons.add,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton.icon(
            onPressed: () async {
              setState(() {
                //descriptionState.count = 0;
                descriptionState.logOrderToCart(
                    title: widget.food.title,
                    shop: widget.food.shop,
                    quantity: widget.food.quantity,
                    price: widget.food.price);
              });
              await descriptionState.updateUserData(
                  widget.food, widget.food.id); //uploads order to database
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            label: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Add to Cart",
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
