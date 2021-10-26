import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

//role take image and create an upload task
//advantage of having its own class --can create multiple upload tasks

class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      // FirebaseStorage(storageBucket: 'gs://mymenu-6131e.appspot.com');//your bucket uri
      FirebaseStorage.instance; //your bucket uri

  UploadTask _uploadTask; //NB! provides current state of upload--progress

  /// Starts an upload task
  void _startUpload() {
    //Unique file name for the file
    //one file can exists at a certain path at a time
    String filePath =
        'Vouchers/${DateTime.now()}.png'; //here you would use userID for voucher holder
    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      /// Manage the task state and event subscription with a StreamBuilder
      return StreamBuilder<TaskSnapshot>(
          //Storage task event contains useful info --number of bits in file. total amount transfered
          stream: _uploadTask.snapshotEvents,
          builder: (context, snapshot) {
            var event = snapshot?.data;
            double progressPercent =
                event != null ? event.bytesTransferred / event.totalBytes : 0;

            return Column(
              //! TODO sya : figure out whats going on here
              children: [
                // if (_uploadTask.isComplete)
                //   Text('Upload completed succesfully'),
                // if (_uploadTask.isPaused)
                //   TextButton(
                //     child: Icon(Icons.play_arrow),
                //     onPressed: _uploadTask.resume,
                //   ),

                // if (_uploadTask.isInProgress)
                //   TextButton(
                //     child: Icon(Icons.pause),
                //     onPressed: _uploadTask.pause,
                //   ),

                // Progress bar
                LinearProgressIndicator(value: progressPercent),
                Text('${(progressPercent * 100).toStringAsFixed(2)} % '),
                CircularProgressIndicator(
                  value: progressPercent,
                )
              ],
            );
          });
    } else {
      // Allows user to decide when to start the upload
      return TextButton.icon(
        label: Text('Upload to Firebase'),
        icon: Icon(Icons.cloud_upload),
        onPressed: _startUpload,
      );
    }
  }
}
