import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:HexColor("#E3E3E3"),
      child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.6,
              child:Image(
                image:AssetImage(
                    "Picture/HalaWhite.png"
                ),
              )
          ),
          Center(
            child: SpinKitWave(
              color: Colors.white,
              size: 50
            ),
          ),
        ],
      ),
    );
  }
}
