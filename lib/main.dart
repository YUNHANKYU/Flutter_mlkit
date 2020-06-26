import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mlkbarcode/camera_page.dart';

/// Firebase 연결 필요!!
/// 바로는 동작 안합니다 :) 

void main() => runApp(MaterialApp(home: MyHomePage()));

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _picker = ImagePicker();
  File pickedFile;

  bool isImageLoaded = false;

  Future openCamera(BuildContext context) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraPage(
          camera: firstCamera,
        ),
      ),
    );
  }

  Future takePicture() async {
    var tempStore = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      pickedFile = File(tempStore.path);
      isImageLoaded = true;
    });
  }

  Future pickImage() async {

    var tempStore = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = File(tempStore.path);
      isImageLoaded = true;
    });
  }

  Future readText() async{
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedFile);
    TextRecognizer recognizerText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizerText.processImage(ourImage);

    for(TextBlock block in readText.blocks){
      for(TextLine line in block.lines){
        for(TextElement word in line.elements){
          print(word.text);
        }
      }
    }
  }

  Future decode() async{
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedFile);
    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    List barcode = await barcodeDetector.detectInImage(ourImage);
    
    for(Barcode readableCode in barcode){
      print(readableCode.displayValue);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(height: 100.0,),
            isImageLoaded ? Center(
              child: Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(pickedFile), fit: BoxFit.cover
                  ),
                ),
              ),
            ) : Container(),
            SizedBox(height: 10.0,),
            RaisedButton(
              onPressed: () => openCamera(context),
              child: Text('Take a picture'),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              onPressed: pickImage,
              child: Text('Pick an image'),
            ),
            SizedBox(height: 10.0,),
            RaisedButton(
              onPressed: (){
                readText();
                print("decode pressed!!!");
              },
              child: Text('decode barcode'),
            ),
          ],
        )
    );
  }
}
