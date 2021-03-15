import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Message.dart';
import 'package:mymenu/Shared/Constants.dart';
import 'package:mymenu/Shared/Database.dart';
import 'package:mymenu/Shared/Loading.dart';
import 'package:mymenu/States/messageDriverState.dart';

class messageDriver extends StatefulWidget {
  @override
  _messageDriverState createState() => _messageDriverState();
}

class _messageDriverState extends State<messageDriver> {
  TextEditingController message = TextEditingController();
  dynamic uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Auth().inputData().then((value){
      setState(() {
        uid = value;
      });

    });

  }
  @override
  Widget build(BuildContext context) {

    return uid == null ? Loading():
    StreamBuilder(

      stream:messageDriverState().Messages(uid),
    builder:( BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot);

      if (!snapshot.hasData) {

        return Scaffold(
            appBar: AppBar(
              title:Text("Messages"),
              centerTitle: true,
              backgroundColor: Colors.black,
            ),
            body:Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Text(
                    "No messages :)",
                    style: TextStyle(
                        fontSize: 30
                    ),
                  ),
                ),
//                  Container(
//                    height:500
//                  ),
                TextFormField(
                  controller: message,
                  decoration: textInputDecoration,

                ),
                Center(
                  child: Center(
                    child: Center(
                      child: FlatButton(
                        child: Text(
                          "Send",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        color: Colors.black,
                        onPressed: () async {

                          await messageDriverState().sendDriverMessage(message.text);
                          setState(() {
                            message.text = "";
                          });


                        },
                      ),
                    ),
                  ),
                ),
              ],
            )
        );
      }
      return Scaffold(
        resizeToAvoidBottomInset : false, // avoids overflowing at the bottom when keyboard shows
        appBar: AppBar(
          title:Text("Messages"),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height:400,
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,


                    itemBuilder: (context, index) {
                      return Card(
                          child:snapshot.data[index].from=="Customer"? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    snapshot.data[index].message,
                                    style:TextStyle(
                                      fontSize: 18
                                      //color:Colors.green
                                    )
                                ),
                                Text(
                                  snapshot.data[index].time.toDate().toString().substring(10,16),
                                  style: TextStyle(
                                      color:Colors.grey[300]
                                  ),
                                ),

                              ],


                            ),
                          ):Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Text(
                                  snapshot.data[index].message,
                                  style: TextStyle(
                                      color:Colors.red,
                                    fontSize: 20

                                  ),
                                ),
                                Text(
                                  snapshot.data[index].time.toDate().toString().substring(10,16),
                                  style: TextStyle(
                                      color:Colors.grey
                                  ),
                                ),

                              ],
                            ),
                          ),



                      );
                    }
                ),
              ),
            ),

              Container(
                width:200,
                child: TextFormField(
                  controller: message,
                  decoration: textInputDecoration,

                ),
              ),

            FlatButton(
              child: Text(
                "Send",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
              color: Colors.black,
              onPressed: () async {

                await messageDriverState().sendDriverMessage(message.text);
                message.text = "";


              },
            )
          ],
        ),
      );

    }
    );
  }
}
