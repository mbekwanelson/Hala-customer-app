import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:mymenu/Authenticate/Auth.dart';
import 'package:mymenu/Home/AfterCheckOut.dart';
import 'package:mymenu/Home/CheckOut.dart';
import 'package:mymenu/Models/ConfirmCheckOut.dart';
import 'package:mymenu/Models/PaymentRequest.dart';
import 'package:mymenu/Models/Transaction.dart';
import 'package:mymenu/Models/cardPaymentDetail.dart';
import 'package:mymenu/OzowPayment/OzowPaymentState.dart';
import 'package:mymenu/States/AfterCheckOutState.dart';
import 'package:provider/provider.dart';
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
  String transactionReference = '';
  String bankReference = 'Sales22';
  String isTest = 'false';
  String hashCheck;
  String privateKey = 'pi4ZwRMzMvqVZ0dpNylAaYdmIWTKDrfl';
  Transaction transaction;
  cardPaymentDetail customerOrderDetail;
  String uid;

  RedirectToOzow({this.amount, this.customerOrderDetail});

  @override
  _RedirectToOzowState createState() => _RedirectToOzowState();
}

class _RedirectToOzowState extends State<RedirectToOzow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static const kAndroidUserAgent =
      "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
  InAppWebViewController _controller;

  String getHashCheck(
      siteCode,
      countryCode,
      currencyCode,
      amount,
      transactionReference,
      bankReference,
      /*customerName,*/ isTest,
      privateKey) {
    //String cash = amount.toString();
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
    print(hash);
    hash = hash.toLowerCase();
    print(hash);
    hash = sha512.convert(utf8.encode(hash.toLowerCase())).toString();
    print("SHASHA: " + hash);
    return hash;
  }

  dynamic getApiTransaction(String transactionReference) async {
    print(
        "---------------------------------------------------------------------------------------Naledi! ${widget.transactionReference}");

    Map<String, dynamic> transactionQueryParameters = {
      "SiteCode": widget.siteCode,
      "TransactionReference": widget.transactionReference
    };

    //json.encode(transactionQueryParameters as string
    //Uri.https('https://api.ozow.com/GetTransactionByReference?siteCode=${widget.siteCode}&transactionReference=${widget.transactionReference}',params)
    String seeFormat =
        "https://api.ozow.com/GetTransactionByReference?siteCode=${widget.siteCode}&transactionReference=${widget.transactionReference}";
    print("___________________________ ${json.encode(seeFormat)}");
    print(
        "___________________________ ${widget.transactionReference.runtimeType}");

    dynamic uri = Uri.encodeFull(
        'https://api.ozow.com/GetTransactionByReference?siteCode=${widget.siteCode}&transactionReference=${widget.transactionReference}');
    //final newURI = uri.replace(queryParameters: transactionQueryParameters);
    https: //api.ozow.com/GetTransactionByReference?siteCode=HAL-HAL-001&transactionReference=s2aP8c7mUb6K22021-03-20 20:06:30.309320
    var transactionStatusResponse = await http.get(
      uri,
      headers: {
        "ApiKey": '',
        "Content-Type": 'application/x-www-form-urlencoded',
        "Accept": 'application/json'
      },
    );
    print(
        "---------------------------------------------------------------------------------------Naledi! ${transactionStatusResponse.body}");
    print(
        "---------------------------------------------------------------------------------------Sthandwa! ${transactionStatusResponse.body}");
    print(" status code ${transactionStatusResponse.statusCode}");

    if (transactionStatusResponse.statusCode == 200) {
      List<Transaction> transactionslist;
      transactionslist = (json.decode(transactionStatusResponse.body) as List)
          .map((i) => Transaction.fromJson(i))
          .toList();
      print('${transactionslist[0].TransactionId}' +
          '\t' +
          '${transactionslist[0].TransactionRefrences}');
      print(
          "Transaction list element: ${json.decode(transactionStatusResponse.body)[0]}");
      //return transactionslist[0];
      return json.decode(transactionStatusResponse.body)[0];
    } else {
      print(transactionStatusResponse.reasonPhrase);

      throw (transactionStatusResponse.statusCode);
    }
    //return Transaction.fromJson(json.decode(transactionStatusResponse.body));
  }

  Future<String> getTransactionStatus(String transactionRefference) async {
    dynamic transaction = await getApiTransaction(transactionRefference);
    print(
        "This is what I get for transaction status: ${transaction["status"]}");
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
    var posta = '';
    var resp = await http.post(Uri.encodeFull('https://pay.ozow.com/'),
        headers: {
          "ApiKey": '',
          "Content-Type": 'application/x-www-form-urlencoded',
          "Accept": 'application/json'
        },
        body: json.encode(body));

    print(
        '--------------------------------------------------------------------------------------------------------------|');
    // print(resp);
    print(json.decode(json.encode(resp))["url"].toString());
    print(resp.reasonPhrase);
    print(resp.toString());
    print(
        "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
    debugPrint(resp.statusCode.toString());
    debugPrint(resp.body);

    print(
        '--------------------------------------------------------------------------------------------------------------');
    _controller.loadUrl(
        url: json.decode(json.encode(resp))["url"].toString() != null
            ? json.decode(json.encode(resp))["url"].toString()
            : "http://demo.ozow.com/error.aspx");

    _controller.loadUrl(
        url: Uri.dataFromString(resp.body,
                mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
            .toString());
    print(resp.toString());

    if (json.decode(resp.body)['success'] == true) {
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";
      FlutterWebviewPlugin().close();
      FlutterWebviewPlugin().launch(selectedUrl,
          rect: new Rect.fromLTRB(
              5.0,
              MediaQuery.of(context).size.height / 7,
              MediaQuery.of(context).size.width - 5.0,
              MediaQuery.of(context).size.height / 7),
          userAgent: kAndroidUserAgent);
    } else {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          content: Text(json.decode(resp.body)['message'].toString())));
    }
  }

  @override
  void initState() {
    //createRequest();
    Auth().inputData().then((value) {
      setState(() {
        widget.transactionReference = value.toString().substring(15) + DateTime.now().toString();
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
      body: InAppWebView(onWebViewCreated: (InAppWebViewController w) async {
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
        var posta = '';
        var resp = await http
            .post(Uri.encodeFull('https://api.ozow.com/PostPaymentRequest'),
                headers: {
                  "ApiKey": '',
                  "Content-Type": 'application/json',
                  "Accept": 'application/json'
                },
                body: utf8.encode(json.encode(body)))
            .then((value) async {
          var response = PaymentRequest.fromJson(json.decode(value.body));

          print(
              "----------------------------------------------------------------------------------${value.body}");

          print(value.body);
          print(json.decode(value.body)["url"]);
          print(value.request.url.toString());

          _controller = w;
          _controller.loadUrl(
              url: response.url != null
                  ? response.url
                  : "http://demo.ozow.com/error.aspx");

          print(
              "----------------------------------------------------------------------------------${response.url}");
        });
        print(
            "----------------------------------------------------------------------------------");

        // await _controller.postUrl(url: 'https://api.ozow.com/PostPaymentRequest',postData: utf8.encode(body.toString()));
        // print(await _controller.getTRexRunnerHtml());
        // print(await _controller.getUrl());
        //  print(await _controller.getHtml());
        //createRequest();
      }, onProgressChanged: (InAppWebViewController w, int i) async {
        String transationStatus =
            await getTransactionStatus(widget.transactionReference);
        print(
            "____________________transact status: $transationStatus _________________");

        if (transationStatus == "Complete") {
          for (int i = 0; i < widget.customerOrderDetail.orders.length; i++) {
            // updates customer order
            await Auth().checkOutApprovedCard(
                widget.customerOrderDetail.orders[i],
                widget.customerOrderDetail.promoValue,
                widget.customerOrderDetail.promoIndex,
                widget.customerOrderDetail.promoApplied);
          }

          w.goBack();
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamProvider.value(
                      value:
                          AfterCheckOutState().getShopProgress(uid: widget.uid),
                      child: AfterCheckOut())));
        } else if (transationStatus == "Cancelled" ||
            transationStatus == "Abandoned") {
          Navigator.pop(context);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CheckOut()));
        }
      } //was here
        ,onLoadStart: (InAppWebViewController controller, String url) {
            print("555555555555555555555555555555555555555555555555 $url 5555555555555555555555555555555555555555555555555555");
            print("__________________________________________ controllerUrl ${controller.getUrl()}");
            if (url == "SuccessUrl") {
              //
            }
          }

          ),
    );
  }
}
