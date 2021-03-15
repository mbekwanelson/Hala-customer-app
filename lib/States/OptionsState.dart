
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Models/Option.dart';

class OptionsState with ChangeNotifier{

  OptionsState(){

  }


  logOptionScreen(String category){
    FirebaseAnalytics().logEvent(name: "SelectedCategory",parameters: {
      "Category":category,
    });





  }
  List<Option> _optionsFromDb(QuerySnapshot snapshot){

    List<Option> options = [];

    for(int cat = 0;cat<snapshot.documents.length;cat++){

      options.add(Option(
        category: snapshot.documents[cat].data["name"],
        url:snapshot.documents[cat].data["url"]
      ));
    }
    return options;
  }

  //ALLOW US TO ADD DIFFERENT CATEGORIES
  Stream<List<Option>> getOptions(){

    return Firestore.instance.collection("Options").snapshots().map(_optionsFromDb);
  }














}