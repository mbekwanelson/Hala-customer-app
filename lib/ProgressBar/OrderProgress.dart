import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mymenu/Models/example_page.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class OrderProgress extends StatefulWidget {
  @override
  _OrderProgressState createState() => _OrderProgressState();

  String shopName;
  String updateShop;
  int index;
  OrderProgress({this.updateShop, this.shopName, this.index});
}

class _OrderProgressState extends State<OrderProgress> {
  @override
  Widget build(BuildContext context) {
    var shopsSeen = Provider.of<List<String>>(context);

    /// Example 02
    var customWidth02 = CustomSliderWidths(trackWidth: 1, progressBarWidth: 2);
    var customColors02 = CustomSliderColors(
        trackColor: Colors.white,
        progressBarColor: Colors.orange,
        hideShadow: true);
    // var info02 = InfoProperties(
    //     bottomLabelStyle: TextStyle(
    //         color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.w600),
    //     topLabelText: widget.shopName,
    //     bottomLabelText: widget.updateShop,
    //     mainLabelStyle: TextStyle(
    //         color: Colors.white, fontSize: 30.0, fontWeight: FontWeight.w100),
    //     modifier: (double value) {
    //       final budget = (value * 1000).toInt();
    //       return '\$ $budget';
    //     });
    CircularSliderAppearance appearance02 = CircularSliderAppearance(
        customWidths: customWidth02,
        customColors: customColors02,
        infoProperties: InfoProperties(
            bottomLabelStyle: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 20,
                fontWeight: FontWeight.w600),
            topLabelText: widget.shopName,
            bottomLabelText: widget.updateShop,
            mainLabelStyle: TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.w100),
            modifier: (double value) {
              final budget = (value * 1000).toInt();
              return '\$ $budget';
            }),
        startAngle: 180,
        angleRange: 270,
        size: 400.0,
        animationEnabled: false);
    var viewModel02 = ExampleViewModel(
        appearance: appearance02,
        min: 0,
        max: 10,
        value: 8,
        pageColors: [Colors.black, Colors.black87]);
    // var example02 = ExamplePage(
    //   viewModel: viewModel02,
    // );
    if (shopsSeen == null) {
      return Container(child: Text("Nah"));
    } else {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: viewModel02.pageColors,
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  tileMode: TileMode.clamp)),
          child: SafeArea(
            child: Center(
                child: SleekCircularSlider(
              onChangeStart: (double value) {},
              onChangeEnd: (double value) {},
              innerWidget: viewModel02.innerWidget,
              appearance: CircularSliderAppearance(
                  customWidths: customWidth02,
                  customColors: customColors02,
                  infoProperties: InfoProperties(
                      bottomLabelStyle: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                      topLabelText: widget.shopName,
                      bottomLabelText: widget.updateShop,
                      mainLabelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w100),
                      modifier: (double value) {
                        final budget = (value * 1000).toInt();
                        return '\$ $budget';
                      }),
                  startAngle: 180,
                  angleRange: 270,
                  size: 400.0,
                  animationEnabled: true),
              min: viewModel02.min,
              max: viewModel02.max,
              initialValue: viewModel02.value,
            )),
          ),
        ),
      );
    }
  }
}
