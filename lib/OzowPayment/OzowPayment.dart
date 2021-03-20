import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:core';

class OzowPayment extends StatefulWidget {
  @override
  _OzowPaymentState createState() => _OzowPaymentState();
}

class _OzowPaymentState extends State<OzowPayment> {

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class RedirectToOzow extends StatefulWidget {

  String siteCode = 'HAL-HAL-001';
  String countryCode = 'ZA';
  String currencyCode = 'ZAR';
  String amount = '5.00';
  String transactionReference = 'Hala Kala Purchase 01';
  String bankReference = 'Sales22';
  String isTest = 'false';
  String hashCheck;
  String privateKey = 'pi4ZwRMzMvqVZ0dpNylAaYdmIWTKDrfl';

  RedirectToOzow({this.amount});

  @override
  _RedirectToOzowState createState() => _RedirectToOzowState();
}

class _RedirectToOzowState extends State<RedirectToOzow> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const kAndroidUserAgent = "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
  InAppWebViewController _controller;

  String getHashCheck(siteCode, countryCode, currencyCode, amount, transactionReference, bankReference, /*customerName,*/ isTest, privateKey){
    //String cash = amount.toString();
    String hash = siteCode+countryCode+currencyCode+amount+transactionReference+bankReference+"http://demo.ozow.com/cancel.aspx"/*+customerName*/+"http://demo.ozow.com/error.aspx"+"http://demo.ozow.com/success.aspx"+"http://demo.ozow.com/notify.aspx"+widget.isTest+privateKey;
    print(hash);
    hash = hash.toLowerCase();
    print(hash);
    hash = sha512.convert(utf8.encode(hash.toLowerCase())).toString();
    print("SHASHA: "+hash);
    return hash;
  }

  Future createRequest() async{
    widget.hashCheck = getHashCheck(widget.siteCode, widget.countryCode, widget.currencyCode, widget.amount, widget.transactionReference, widget.bankReference, /*widget.customerName, */widget.isTest, widget.privateKey);
    Map<String, dynamic> body = {
      "SiteCode": widget.siteCode,
      "CountryCode": widget.countryCode,
      "CurrencyCode": widget.currencyCode,
      "Amount": double.parse(widget.amount),
      "TransactionReference": widget.transactionReference,
      "BankReference": widget.bankReference,
      //"Customer": widget.customerName,
      "CancelUrl": "http://demo.ozow.com/cancel.aspx",
      "ErrorUrl": "http://demo.ozow.com/error.aspx",
      "SuccessUrl": "http://demo.ozow.com/success.aspx",
      "NotifyUrl": "http://demo.ozow.com/notify.aspx",
      "IsTest": /*widget.isTest.toLowerCase() ==*/ false ,
      "HashCheck": getHashCheck(widget.siteCode, widget.countryCode, widget.currencyCode, widget.amount, widget.transactionReference, widget.bankReference,/* widget.customerName,*/ widget.isTest, widget.privateKey),
    } ;
   var posta='';
    var resp =  await http.post(
      Uri.encodeFull('https://pay.ozow.com/'),
      headers: {
        "ApiKey": ' ZUXVOvt39xaavip2M1BZygU4CjDpD930',
        "Content-Type": 'application/x-www-form-urlencoded',
        "Accept": 'application/json'
      },
      body: json.encode(body)
    );

    print('--------------------------------------------------------------------------------------------------------------|');
   // print(resp);
    debugPrint(json.decode(json.encode(resp))["url"].toString());
    debugPrint(resp.reasonPhrase);
    debugPrint(resp.toString());
    print("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    debugPrint(resp.statusCode.toString());
    debugPrint(resp.body);
    print('--------------------------------------------------------------------------------------------------------------');
    _controller.loadUrl(url: json.decode(json.encode(resp))["url"].toString()!=null?json.decode(json.encode(resp))["url"].toString():"http://demo.ozow.com/error.aspx");

    _controller.loadUrl(url: Uri.dataFromString(
        resp.body,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
    print(resp.toString());

   if(json.decode(resp.body)['success'] == true){
      String selectedUrl = json.decode(resp.body)["payment_request"]['longurl'].toString() + "?embed=form";
      FlutterWebviewPlugin().close();
      FlutterWebviewPlugin().launch(selectedUrl,
        rect: new Rect.fromLTRB(5.0, MediaQuery.of(context).size.height/7, MediaQuery.of(context).size.width - 5.0 , MediaQuery.of(context).size.height/7),
        userAgent: kAndroidUserAgent
      );
    }
    else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Text(json.decode(resp.body)['message'].toString())));
    }
  }

  @override
  void initState() {
    //createRequest();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Confirm Payment',
          style: TextStyle(
            letterSpacing: 2
          ),
        ),
        backgroundColor: Colors.red[900],

      ),
      body: InAppWebView(
        onWebViewCreated: (InAppWebViewController w) async{
          widget.hashCheck = getHashCheck(widget.siteCode, widget.countryCode, widget.currencyCode, widget.amount, widget.transactionReference, widget.bankReference, /*widget.customerName,*/ widget.isTest, widget.privateKey);
          Map<String, dynamic> body = {
            "SiteCode": widget.siteCode,
            "CountryCode": widget.countryCode,
            "CurrencyCode": widget.currencyCode,
            "Amount": /*double.parse(*"500"*)*/widget.amount,
            "TransactionReference": widget.transactionReference,
            "BankReference": widget.bankReference,
            //"CustomerName": widget.customerName,
            "CancelUrl":"http://demo.ozow.com/cancel.aspx",
            "ErrorUrl": "http://demo.ozow.com/error.aspx",
            "SuccessUrl": "http://demo.ozow.com/success.aspx",
            "NotifyUrl": "http://demo.ozow.com/notify.aspx",
            "IsTest": /*widget.isTest.toLowerCase() ==*/ false ,
            /*"GenerateShortUrl":true,*/
            "HashCheck": widget.hashCheck,
          } ;
          var posta='';
          var resp =  await http.post(
              Uri.encodeFull('https://api.ozow.com/PostPaymentRequest'),
              headers: {
                "ApiKey": 'ZUXVOvt39xaavip2M1BZygU4CjDpD930',
                "Content-Type": 'application/json',
                "Accept": 'application/json'
              },
              body: utf8.encode(json.encode(body))
          );
          print("----------------------------------------------------------------------------------");
          print(resp.body);
          print(json.decode(resp.body)["url"]);
          print(resp.request.url.toString());
          print("----------------------------------------------------------------------------------");
          _controller=w;
          _controller.loadUrl(
              url: json.decode(resp.body)["url"] != null ? json.decode(resp.body)["url"] : "http://demo.ozow.com/error.aspx"
          );
          // await _controller.postUrl(url: 'https://api.ozow.com/PostPaymentRequest',postData: utf8.encode(body.toString()));
          // print(await _controller.getTRexRunnerHtml());
          // print(await _controller.getUrl());
          //  print(await _controller.getHtml());
          //createRequest();
        },
      ),
    );
  }
}