import 'package:toast/toast.dart';

import 'result_page.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter/foundation.dart';


class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  File pickedImage;
  bool isImageLoaded = false;
  List _result;
  String _confidence ="";
  String _name= "";
  String numbers = '';

  getImageFromGallery() async{
    var tempStore = await ImagePicker().getImage(source: ImageSource.gallery);
      Toast.show("IMAGE UPLOADED !", context,
          duration: Toast.LENGTH_LONG,
          textColor: Colors.black,
          backgroundColor: Colors.white12,
          backgroundRadius: 15,
          gravity: Toast.BOTTOM);
    setState(() {
      pickedImage = File(tempStore.path);
      isImageLoaded = true;
    });
   applyModelOnImage(pickedImage);
  }

  loadModel() async{
    await Tflite.loadModel(
        labels: "assets/labels.txt",
        model: "assets/model.tflite",
    );
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 40,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5
    );

    setState(() {
      _result = res;

      String str = _result[0]['label'];
     _name = str;
      _name = str.substring(0);
      _confidence = _result != null ?
      (_result[0]['confidence']*100.0).toString().substring(0,2)  : "";
      print(_result[0]['confidence'].runtimeType);
      print(_result.runtimeType);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((val){
      setState(() {
      });
    });
  }



  // Future getImage(bool isCamera) async {
  //   if (isCamera) {
  //     var image = await ImagePicker().getImage(source: ImageSource.camera);
  //   } else {
  //     var image = await ImagePicker().getImage(source: ImageSource.gallery);
  //   }
  //   uploadImage(image, uploadUrl);
  //   Toast.show("IMAGE UPLOADED !", context,
  //       duration: Toast.LENGTH_LONG,
  //       textColor: Colors.black,
  //       backgroundColor: Colors.white12,
  //       backgroundRadius: 15,
  //       gravity: Toast.BOTTOM);
  //   setState(() {
  //     _image = image;
  //   });
  // }

  // loadDataModelFiles() async{
  //   await Tflite.loadModel(
  //       labels: "assets/Flickr8k.lemma.token.txt",
  //       model: "assets/model.tflite" ,
  //   );
  //   print(result);
  // }0.+6W--+

  //  loadDataModelFiles() async{
  //
  //   String output=await Tflite.loadModel(
  //   model:'assets/model_9.tflite',
  //   labels:'assets/labels.txt',
  //       numThreads:1,
  //     isAsset: true,
  //     useGpuDelegate: false,
  //   );
  // print(output);
  // }
  //
  // doImageCaption() async{
  //   var recognitions= await Tflite.runModelOnImage(
  //       path: pickedImage.path,
  //   imageMean: 0.0,
  //     imageStd: 255.0,
  //     numResults: 1,
  //     threshold: 0.1,
  //     asynch: true,
  //   );
  //   print(recognitions.length.toString());
  //   setState(() {
  //     result='';
  //   });
  //   recognitions.forEach((element) {
  //     setState(() {
  //      print(element.toString());
  //      result += element['label']+'\n\n';
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //  // TODO: implement initState
  //   super.initState();
  //  imagePicker= ImagePicker();
  //   loadDataModelFiles();
  // }
   @override
   Widget build(BuildContext context) {
     return Container(
       decoration: BoxDecoration(
         gradient: LinearGradient(
           begin: Alignment.topRight,
           end: Alignment.bottomLeft,
           stops: [0.1, 0.5, 0.7, 0.9],
           colors: [
             Colors.lightBlue[800],
             Colors.lightBlue[700],
             Colors.lightBlue[600],
             Colors.lightBlue[400],
           ],
         ),
       ),
       child: Scaffold(
         backgroundColor: Colors.transparent,
         appBar: AppBar(
           backgroundColor: Colors.transparent,
           centerTitle: true,
           elevation: 0,
          title: Text(
             'ImageX',
             style: TextStyle(
                 fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black),
           ),
         ),
         body: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               IconButton(
                 icon: Icon(Icons.insert_drive_file),
                 color: Colors.white,
                 iconSize: 70,
                 onPressed: () {
                  getImageFromGallery();
                 },
               ),
               SizedBox(
                 height: 70.0,
               ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  color: Colors.white,
                  iconSize: 70,
                  onPressed: () {
                    //getImage(true);
                  },
                ),
               SizedBox(
                 height: 70.0,
               ),
             ],
           ),
         ),
         floatingActionButton: FloatingActionButton.extended(
           onPressed: () {
             Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => ResultPage(
                            image: pickedImage,
                            result:_name,
                         )));
           },
           icon: Icon(
             Icons.arrow_forward,
             color: Colors.black,
             size: 30,
           ),
           label: Text(
             "Next",
             style: TextStyle(color: Colors.black, fontSize: 20),
           ),
           backgroundColor: Colors.white,
         ),
       ),
     );
   }
 }

