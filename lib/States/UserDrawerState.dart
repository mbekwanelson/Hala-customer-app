import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Models/Customer.dart';
import 'package:mymenu/Models/Promotion.dart';

class UserDrawerState with ChangeNotifier{
TextEditingController promoCode = TextEditingController();


  String validPromo = "";
  String name;
  String email;

  List<String> promos = ["promo1","promo2","promo3"];
  UserDrawerState(){
    customerInfo();
    //validPromo = "";
  }
  Future _findPromos() async{

    // ignore: missing_return
    Promotion promotion = await Firestore.instance.collection("Promotions").getDocuments().then((document){
        for(int elementIndex =0;elementIndex<document.documents.length;elementIndex++){
         // print("${document.documents[elementIndex].data["promoCode"]} VS ${promoCode.text}");
          if(promoCode.text==document.documents[elementIndex].data["promoCode"]){

          Promotion promo= Promotion(
            promoCode: document.documents[elementIndex].data["promoCode"],
            promoValue: document.documents[elementIndex].data["promoValue"],
            shop: document.documents[elementIndex].documentID,
          );

          return promo;
      }
        }


    });
    return promotion;
  }

  Future checkIfPromoUsed()async{
    DocumentSnapshot user;
    String uid = await Auth().inputData();
    user = await Firestore.instance.collection("Users").document(uid).get();
    await Future.delayed(const Duration(seconds: 1), () => "1");
    Map<String,dynamic> promos = user["promotions"];


    if(promos==null){
      return false;
    }
    List<String> promotions = promos.keys.toList();


    for(int i=0;i<promotions.length;i++){

      if(promoCode.text == promos[promotions[i]]["promoCode"]){
        print("Promo Used");
        return true;
        //promo used
      }
    }
    return false;
  }

  void verifyPromo()async{
    dynamic uid = await Auth().inputData();
    Promotion validPromoCheck = await _findPromos();
    bool promoUsed = await checkIfPromoUsed();
    await Future.delayed(const Duration(seconds: 1), () => "1");

    if (validPromoCheck !=null && promoUsed==false){

      DocumentSnapshot user =await Firestore.instance.collection("Users").document(uid).get();
      dynamic promos = user['promotions'];
      
      if(promos==null){
        Map<String,dynamic> data = {
          'promotions':{
            "${DateTime.now()}".split('.').join(','):{
              "promoCode":promoCode.text,
              "used":"No"
            }
          }

        };
        await Firestore.instance.collection("Users").document(uid).setData(data,merge:true);
      }
      else{

        Map<String,dynamic> data = {
          "promotions":{
            "${DateTime.now()}".split('.').join(','):{
              "promoCode":promoCode.text,
              "used":"No"
            }
          }

        };
        await Firestore.instance.collection("Users").document(uid).setData(data,merge:true);

      }


      validPromo = "Successfully added Promo!";


    promoCode.clear();
     notifyListeners();


    }
    else if (promoUsed==true){

      validPromo = "Promo already used!";
      promoCode.clear();
      notifyListeners();
    }
    else{
      validPromo = "Incorrect promo!";
      promoCode.clear();
      notifyListeners();
    }
  }

  bool _isPromoValid(){
    for(int p=0;p<promos.length;p++){
      if(promoCode.text ==promos[p]){
        return true;
      }
    }
    return false;
  }



  Future<Customer> customerInfo()async{
    String uid = await Auth().inputData();
    return await Firestore.instance.collection("Users").document(uid).snapshots().forEach((element) {
      //print(element.data["email"]);
      Customer customer = Customer(
        name:element.data["name"],
        email: element.data["email"]
      );
      name = element.data["name"];
      email=element.data["email"];
      return customer;
    });


  }

bool  _hasOrdered(DocumentSnapshot snapshot){
  List<String> all =[];
  bool placedOrder= false;


  snapshot.data.keys.forEach((element) {

    try {

      if(snapshot[element]["active"]==1){
        placedOrder = true;

        print('shopSeen: snapshot[element]["shopSeen"]');
        print(snapshot[element]["active"]);
        print(snapshot[element]["shop"]);

      }
    }
    catch(e){
      print(e);
    }
  });

  return placedOrder;

}







Stream<bool> hasCustomerOrdered(){
    dynamic uid = Auth().inputData();
  return Firestore.instance.collection('OrdersRefined').document(uid).snapshots().map(_hasOrdered);
}




  logUser(){
   FirebaseAnalytics().setCurrentScreen(screenName: "UserDrawerScreen");
   // FirebaseAnalytics().logEvent(name: "userDrawerOpened",parameters: {
   //   "name":name,
   //   "email":email
   // });


  }
  setOccupation(String occupation){
    FirebaseAnalytics().setUserProperty(
        name: "Ocupation", value: occupation);
  }

}