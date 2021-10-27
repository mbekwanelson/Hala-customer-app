import 'package:flutter/material.dart';
import 'package:mymenu/Models/DropDown.dart';
import 'package:mymenu/Models/Meal.dart';
import 'package:mymenu/Models/MealOption.dart';
import 'package:mymenu/States/PersonalizeMealState.dart';

class PersonalizeMeal extends StatefulWidget {
  final Meal meal;

  PersonalizeMeal({this.meal});
  @override
  _PersonalizeMealState createState() => _PersonalizeMealState();
}

class _PersonalizeMealState extends State<PersonalizeMeal> {
  List<DropDown> dropDown;
  List<DropdownMenuItem<MealOption>> _dropdownMenuItems;
  bool orderSameShop = true;

  loadDropDownItems() {
    dropDown = [];
    //creates drop down items for each list of options
    for (int i = 0; i < widget.meal.availableOptions(); i++) {
      _dropdownMenuItems =
          buildDropDownMenuItems(widget.meal.differentOptions[i]);
      dropDown.add(DropDown(
          dropDownItem: _dropdownMenuItems,
          selected: _dropdownMenuItems[0].value));
    }
  }

  // Layout of drop Items
  List<DropdownMenuItem<MealOption>> buildDropDownMenuItems(
      List<MealOption> options) {
    List<DropdownMenuItem<MealOption>> items = [];
    for (MealOption option in options) {
      items.add(
        DropdownMenuItem(
          child: Row(
            children: [
              Text(
                option.title,
              ),
              SizedBox(width: 10),
              Text(
                'R ${option.price.toStringAsFixed(2)}',
              )
            ],
          ),
          value: option,
        ),
      );
    }
    return items;
  }

  // calculates price taking added options into consideration
  calculatePrice() {
    double price = widget.meal.initialPrice;
    for (int i = 0; i < dropDown.length; i++) {
      price += dropDown[i].selected.price;
    }
    widget.meal.finalPrice = price;
  }

  selectedOption() {
    List<MealOption> optionSelected = [];
    for (int option = 0; option < dropDown.length; option++) {
      optionSelected.add(dropDown[option].selected);
    }
    widget.meal.selected = optionSelected;
  }

  @override
  void initState() {
    // TODO: implement initState
    loadDropDownItems();
    calculatePrice();
    selectedOption();

    PersonalizeMealState().checkIfSameShop(widget.meal.shop).then((value) {
      setState(() {
        orderSameShop = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return orderSameShop != true
        ? Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("You cannot order from more than 1 shop at a time",
                  style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 20)),
              Text("Please continue checkOut your previous order first",
                  style: TextStyle(
                      color: Colors.red[900],
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontSize: 20))
            ],
          ))
        : Container(
            padding: EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.meal.title,
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 30),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Image.network(
                        widget.meal.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Price: R ${widget.meal.finalPrice.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: dropDown.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(12),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey,
                                  border: Border.all()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<MealOption>(
                                    value: dropDown[index].selected,
                                    items: dropDown[index].dropDownItem,
                                    onChanged: (value) {
                                      setState(() {
                                        dropDown[index].selected = value;
                                        calculatePrice();
                                        selectedOption();
                                      });
                                    }),
                              ),
                            ),
                          );
                        }),
                    TextButton.icon(
                      onPressed: () async {
                        await PersonalizeMealState()
                            .updateUserData(widget.meal);

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
                      // color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
