import 'dart:convert';
import 'dart:core';

// import 'package:commons/commons.dart'; //! TODO sya : find alternative to commons plugin
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart'; //! TODO sya : find alternative to flutter_webview_plugin plugin
// import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mymenu/Authenticate/Auth.dart';
// import 'package:mymenu/Home/AfterCheckOut.dart';
// import 'package:mymenu/Home/CheckOut.dart';
import 'package:mymenu/Models/PaymentRequest.dart';
import 'package:mymenu/Models/Transaction.dart';
import 'package:mymenu/Models/cardPaymentDetail.dart';
// import 'package:mymenu/Shared/Database.dart';
// import 'package:mymenu/States/AfterCheckOutState.dart';
// import 'package:provider/provider.dart';

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
  String transactionReference = '';
  String bankReference = 'Sales442';
  String isTest = 'false';
  String hashCheck;
  String privateKey = 'pi4ZwRMzMvqVZ0dpNylAaYdmIWTKDrfl';
  Transaction transaction;
  CardPaymentDetail customerOrderDetail;
  String uid;
  double deliveryFee;
  String category;

  RedirectToOzow(
      {this.amount, this.customerOrderDetail, this.deliveryFee, this.category});

  @override
  _RedirectToOzowState createState() => _RedirectToOzowState();
}

class _RedirectToOzowState extends State<RedirectToOzow> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // static const kAndroidUserAgent =
  //     "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
  InAppWebViewController _controller;
  int count = 0;

  String getHashCheck(
      siteCode,
      countryCode,
      currencyCode,
      amount,
      transactionReference,
      bankReference,
      /*customerName,*/ isTest,
      privateKey) {
    String hash = siteCode +
        countryCode +
        currencyCode +
        amount +
        transactionReference +
        bankReference +
        "http://demo.ozow.com/cancel.aspx" /*+customerName*/ +
        "http://demo.ozow.com/error.aspx" +
        "http://demo.ozow.com/success.aspx" +
        "http://demo.ozow.com/notify.aspx" +
        widget.isTest +
        privateKey;
    hash = hash.toLowerCase();
    hash = sha512.convert(utf8.encode(hash.toLowerCase())).toString();
    return hash;
  }

  dynamic getApiTransaction(String transactionReference) async {
    // Map<String, dynamic> transactionQueryParameters = {
    //   "SiteCode": widget.siteCode,
    //   "TransactionReference": widget.transactionReference
    // };
    // String seeFormat =
    //     "https://api.ozow.com/GetTransactionByReference?siteCode=${widget.siteCode}&transactionReference=${widget.transactionReference}";

    dynamic uri = Uri.encodeFull(
        'https://api.ozow.com/GetTransactionByReference?siteCode=${widget.siteCode}&transactionReference=${widget.transactionReference}');

    var transactionStatusResponse = await http.get(
      uri,
      headers: {
        "ApiKey": 'ZUXVOvt39xaavip2M1BZygU4CjDpD930',
        "Content-Type": 'application/x-www-form-urlencoded',
        "Accept": 'application/json'
      },
    );
    if (transactionStatusResponse.statusCode == 200) {
      // List<Transaction> transactionslist;
      // transactionslist = (json.decode(transactionStatusResponse.body) as List)
      //     .map((i) => Transaction.fromJson(i))
      //     .toList();
      return json.decode(transactionStatusResponse.body)[0];
    } else {
      throw (transactionStatusResponse.statusCode);
    }
  }

  Future<String> getTransactionStatus(String transactionRefference) async {
    dynamic transaction = await getApiTransaction(transactionRefference);
    return transaction["status"];
  }

  Future createRequest() async {
    widget.hashCheck = getHashCheck(
        widget.siteCode,
        widget.countryCode,
        widget.currencyCode,
        widget.amount,
        widget.transactionReference,
        widget.bankReference,
        /*widget.customerName, */ widget.isTest,
        widget.privateKey);
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
      "IsTest": /*widget.isTest.toLowerCase() ==*/ false,
      "HashCheck": getHashCheck(
          widget.siteCode,
          widget.countryCode,
          widget.currencyCode,
          widget.amount,
          widget.transactionReference,
          widget.bankReference,
          /* widget.customerName,*/ widget.isTest,
          widget.privateKey),
    };
    // var posta = '';
    var resp = await http.post(Uri.parse('https://pay.ozow.com/'),
        headers: {
          "ApiKey": 'ZUXVOvt39xaavip2M1BZygU4CjDpD930',
          "Content-Type": 'application/x-www-form-urlencoded',
          "Accept": 'application/json'
        },
        body: json.encode(body));

    //! TODO sya : needs testing
    var url1 = json.decode(json.encode(resp))["url"].toString() != null
        ? json.decode(json.encode(resp))["url"].toString()
        : "http://demo.ozow.com/error.aspx";
    _controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url1)));
    // _controller.loadUrl(
    //     url: json.decode(json.encode(resp))["url"].toString() != null
    //         ? json.decode(json.encode(resp))["url"].toString()
    //         : "http://demo.ozow.com/error.aspx");

    //! TODO sya : needs testing
    var url2 = resp.body;
    _controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url2)));
    // _controller.loadUrl(
    //     url: Uri.dataFromString(resp.body,
    //             mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
    //         .toString());

    if (json.decode(resp.body)['success'] == true) {
      // String selectedUrl =
      //     json.decode(resp.body)["payment_request"]['longurl'].toString() +
      //         "?embed=form";
      //! TODO sya :  flutter webview plugin code
      // FlutterWebviewPlugin().close();
      // FlutterWebviewPlugin().launch(selectedUrl,
      //     rect: new Rect.fromLTRB(
      //         5.0,
      //         MediaQuery.of(context).size.height / 7,
      //         MediaQuery.of(context).size.width - 5.0,
      //         MediaQuery.of(context).size.height / 7),
      //     userAgent: kAndroidUserAgent);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            json.decode(resp.body)['message'].toString(),
          ),
        ),
      );
      // _scaffoldKey.currentState.showSnackBar(new SnackBar(
      //     content: Text(json.decode(resp.body)['message'].toString())));
    }
  }

  @override
  void initState() {
    //createRequest();
    Auth().inputData().then((value) {
      setState(() {
        widget.transactionReference =
            value.toString().substring(15) + DateTime.now().toString();
        widget.uid = value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Confirm Payment',
          style: TextStyle(letterSpacing: 2),
        ),
        backgroundColor: Colors.red[900],
      ),
      body: InAppWebView(
        onWebViewCreated: (InAppWebViewController w) async {
          widget.hashCheck = getHashCheck(
              widget.siteCode,
              widget.countryCode,
              widget.currencyCode,
              widget.amount,
              widget.transactionReference,
              widget.bankReference,
              /*widget.customerName,*/ widget.isTest,
              widget.privateKey);
          Map<String, dynamic> body = {
            "SiteCode": widget.siteCode,
            "CountryCode": widget.countryCode,
            "CurrencyCode": widget.currencyCode,
            "Amount": /*double.parse(*"500"*)*/ widget.amount,
            "TransactionReference": widget.transactionReference,
            "BankReference": widget.bankReference,
            //"CustomerName": widget.customerName,
            "CancelUrl": "http://demo.ozow.com/cancel.aspx",
            "ErrorUrl": "http://demo.ozow.com/error.aspx",
            "SuccessUrl": "http://demo.ozow.com/success.aspx",
            "NotifyUrl": "http://demo.ozow.com/notify.aspx",
            "IsTest": /*widget.isTest.toLowerCase() ==*/ false,
            /*"GenerateShortUrl":true,*/
            "HashCheck": widget.hashCheck,
          };
          // var posta = '';
          // var resp = await http
          await http
              .post(Uri.parse('https://api.ozow.com/PostPaymentRequest'),
                  headers: {
                    "ApiKey": 'ZUXVOvt39xaavip2M1BZygU4CjDpD930',
                    "Content-Type": 'application/json',
                    "Accept": 'application/json'
                  },
                  body: utf8.encode(json.encode(body)))
              .then((value) async {
            var response = PaymentRequest.fromJson(json.decode(value.body));
            _controller = w;
            //! TODO sya : needs testing
            var url3 = response.url != null
                ? response.url
                : "http://demo.ozow.com/error.aspx";
            _controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url3)));
            // _controller.loadUrl(
            //     url: response.url != null
            //         ? response.url
            //         : "http://demo.ozow.com/error.aspx");
          });
          // await _controller.postUrl(url: 'https://api.ozow.com/PostPaymentRequest',postData: utf8.encode(body.toString()));
          // print(await _controller.getTRexRunnerHtml());
          // print(await _controller.getUrl());
          //  print(await _controller.getHtml());
          //createRequest();
        },
        //! TODO sya : InAppWebView
        // onLoadStop: (InAppWebViewController controller, String url) async {
        //   String transationStatus =
        //       await getTransactionStatus(widget.transactionReference);

        //   if (transationStatus == "Complete" && count == 0) {
        //     //! TODO sya : Commons widget
        //     // successDialog(context, "Your payment has been successfully made!",
        //     //     positiveAction: () {},
        //     //     positiveText: "Confirm",
        //     //     negativeAction: () {},
        //     //     negativeText: "Cancel");
        //     // sends user coordinates to database
        //     Position position = await Geolocator.getCurrentPosition(
        //         desiredAccuracy: LocationAccuracy.high);
        //     await Database()
        //         .loadLocation(position.latitude, position.longitude);
        //     for (int j = 0; j < widget.customerOrderDetail.orders.length; j++) {
        //       // updates customer order
        //       String isOperational = await Auth().checkOutApprovedCard(
        //           widget.customerOrderDetail.orders[j],
        //           widget.customerOrderDetail.promoValue,
        //           widget.customerOrderDetail.promoIndex,
        //           widget.customerOrderDetail.promoApplied,
        //           widget.deliveryFee,
        //           widget.category);
        //     }
        //     ;
        //     count++;
        //     widget.customerOrderDetail.orders.forEach((element) {});

        //     controller.goBack();
        //     Navigator.pop(context);
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => StreamProvider.value(
        //                 value: AfterCheckOutState()
        //                     .getShopProgress(uid: widget.uid),
        //                 child: AfterCheckOut())));
        //   } else if (transationStatus == "Cancelled" ||
        //       transationStatus == "Abandoned") {
        //     //! TODO Commons widget
        //     // errorDialog(context, "Transaction failed!",
        //     //     positiveAction: () {},
        //     //     positiveText: "Confirm",
        //     //     negativeAction: () {},
        //     //     negativeText: "Cancel");
        //     Navigator.pop(context);

        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => CheckOut()));
        //   }
        // }, //was here
      ),
    );
  }
}
