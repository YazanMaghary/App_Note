import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:design_app_note_login_page/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({super.key});
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List user = [];
  var noteRef = FirebaseFirestore.instance.collection("notes");
  File? file;
  // Replace with server token from firebase console settings.
  final String serverToken =
      'AAAArgtqW_8:APA91bERWCssVGFCT786ko771-p3lKEhg7aHW3wOx3WVOpAFgroMkhDLhgG-O8RFuoEfzVm12c3xIcVNAH4OQAebGIl6PUtlT4g3ywJdBQ5_cxksh8bk1SwmJ27da2_ayJkG6TBAIbcq';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  sendNotfiy(String title, String body, String id) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'this is a body',
            'title': 'this is a title'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': "/topics/yazan",
        },
      ),
    );
  }

// حتى نتاكد انو الرسالة بتصل
  getMessage() {
    FirebaseMessaging.onMessage.listen((event) {
      print("=" * 100);
      print(event.notification!.title);
      print("=" * 100);
      print(event.notification!.body);
      print("=" * 100);
      print(event.data);
      print("=" * 100);
    });
  }

  var image_pickker = ImagePicker();
  uploadImages() async {
    var picker = await image_pickker.pickImage(source: ImageSource.gallery);
    if (picker != null) {
      file = File(picker.path);
      var imagnaame = basename(picker.path);
      var random = Random().nextInt(10000000);
      imagnaame = "$imagnaame" + "$random";
      // Create a storage reference from our app
      final storageRef = FirebaseStorage.instance.ref();
// Create a reference to "mountains.jpg"
      final mountainsRef = storageRef.child("$imagnaame");

// Create a reference to 'images/mountains.jpg'
      final mountainImagesRef = storageRef.child("images/$imagnaame");

// While the file names are the same, the references point to different files
      assert(mountainsRef.name == mountainImagesRef.name);
      assert(mountainsRef.fullPath != mountainImagesRef.fullPath);

      try {
        await mountainsRef.putFile(file!);
      } on FirebaseException catch (e) {
        // ...
        print("error $e");
      }
    } else {
      print("Please choose Image~");
    }
  }

  listname() async {
    final storageRef = FirebaseStorage.instance.ref();
    String? pageToken;
    final listResult = await storageRef.listAll();
    for (var prefix in listResult.prefixes) {
      // The prefixes under storageRef.
      // You can call listAll() recursively on them.
    }
    for (var item in listResult.items) {}
  }

  @override
  void initState() {
    getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                await sendNotfiy("title", "body", "1");
              },
              child: Text(
                "Send notify",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () async {
                await FirebaseMessaging.instance.subscribeToTopic("yazan");
              },
              child: Text(
                "Subscribe Tobic",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () async { 
                await FirebaseMessaging.instance.unsubscribeFromTopic("yazan");
              },
              child: Text(
                "unSubscribe To Tobic",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ));
  }
}
