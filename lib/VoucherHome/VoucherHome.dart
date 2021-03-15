import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mymenu/VoucherHome/Uploader.dart';



//will allow us to capture an image from camera and allow user to crop and resize it
class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;//the file/photo

  //allows user to select image from camera or gallery
  // source = camera/gallery
  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source:source);//allows user to either select image from gallery or capture a new one with a camera

    setState(() {
      _imageFile = selected;
    });
  }

  //allows user to crop an image
  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
//      toolbarColor: Colors.purple,
//      toolbarWidgetColor:Colors.white,
//      toolbarTitle:"Crop it "
    );
    setState(() {
      _imageFile  = cropped ?? _imageFile; // if user cancels modifications return the origional image file (uncropped)
    });
  }
  // Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: BottomAppBar(
        child:Row(
          children: <Widget>[
            IconButton(
              onPressed: (){
                return _pickImage(ImageSource.camera);
              },
              icon:Icon(Icons.photo_camera),
            ),
            IconButton(
              onPressed: (){
                return _pickImage(ImageSource.gallery);
              },
              icon:Icon(Icons.photo_library),
            ),
          ],
        )
      ),
      body:Column(
        children: <Widget>[
          ClipPath(
            clipper:MyClipper(),
            child: Container(
              height:320,
              decoration:BoxDecoration(
                color:Colors.red,
              ) ,
              child:Center(
                child:Text(
                  "Voucher",
                  style:TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              child: ListView(
                children: <Widget>[
                  if(_imageFile != null) ...[

                    Image.file(_imageFile),
                    Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: _cropImage,
                        child:Icon(Icons.crop),


                      ), FlatButton(
                        child: Icon(Icons.refresh),
                        onPressed: _clear,
                      ),
                    ],
                    ),

              Uploader(file: _imageFile)//
                ],
              ]),
            ),
          ),
        ],
      )
    );
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, size.height-50);
    var controllPoint = Offset(50,size.height);
    var endPoint = Offset(size.width/2,size.height);
    path.quadraticBezierTo(controllPoint.dx, controllPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}