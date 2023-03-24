import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:design_app_note_login_page/component/aler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as s;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class editnotes extends StatefulWidget {
  final docid;
  final list ;
  const editnotes({super.key, this.docid,this.list});

  @override
  State<editnotes> createState() => _editnotesState();
}

class _editnotesState extends State<editnotes> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  String? noteTitle;
  String? noteDesc;
  var imgurl;
  File? file;
  var Ref;
  var firestoreRef = FirebaseFirestore.instance.collection("Notes");
  editNote() async {
    var formdata = formstate.currentState;
    if (file == null) {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        await firestoreRef.doc(widget.docid).update({
          "Note title ": noteTitle,
          "Note": noteDesc,
          "UID": FirebaseAuth.instance.currentUser?.uid
        // ignore: body_might_complete_normally_catch_error
        }).then((value) => Navigator.of(context).pushNamed("HomePage")).catchError((e){
          print(e);
        });
        
      }
    } else {
      if (formdata!.validate()) {
        showLoading(context);
        formdata.save();
        try {
          await Ref.putFile(file!);
          imgurl = await Ref.getDownloadURL();
        } on FirebaseException catch (e) {
          // ...
          print("error $e");
        }
        await firestoreRef.doc(widget.docid).update({
          "Note title ": noteTitle,
          "Note": noteDesc,
          "Image Url": imgurl,
          "UID": FirebaseAuth.instance.currentUser?.uid
        }).then((value) => Navigator.of(context).pushNamed("HomePage")).catchError((e){
          print(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text("Edit Note"),
      ),
      body: Container(
          child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ThemeData().colorScheme.copyWith(
                primary: Color(0xffe24658),
              ),
        ),
        child: Column(
          children: [
            Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue:widget.list['Note title '],
                      onSaved: (val) {
                        noteTitle = val;
                      },
                      validator: (val) {
                        String str1 = val!;
                        if (str1.length > 30) {
                          return "Title cant be more than 30 letter";
                        }
                        if (str1.length < 5) {
                          return "title cant be less than 5 letter";
                        }
                        return null;
                      },
                      maxLength: 30,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Edit Note Title ",
                          prefixIcon: Icon(Icons.note_alt)),
                    ),
                    TextFormField(initialValue:widget.list['Note'],
                      onSaved: (val) {
                        noteDesc = val;
                      },
                      validator: (val) {
                        String str1 = val!;
                        if (str1.length > 300) {
                          return "Note cant be more than 300 letter";
                        }
                        if (str1.length < 5) {
                          return "Note cant be less than 5 letter";
                        }
                        return null;
                      },
                      minLines: 1,
                      maxLength: 200,
                      maxLines: 3,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Note",
                          prefixIcon: Icon(Icons.note_alt)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showBottomSheet();
                      },
                      child: Text("Edit Image For Note"),
                      style: ElevatedButton.styleFrom(elevation: 0),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await editNote();
                      },
                      child: Text("Edit Note"),
                      style: ElevatedButton.styleFrom(elevation: 0),
                    )
                  ],
                ))
          ],
        ),
      )),
    );
  }

  showBottomSheet() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 170,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Image",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xffe24658)),
                ),
                SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (picked != null) {
                      file = File(picked.path);
                      var imgname = s.basename(picked.path);
                      var random = Random().nextInt(10000000);
                      imgname = "$imgname" + "$random";
                      // Create a storage reference from our app
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child("images")
                          .child("$imgname");
                      Ref = storageRef;
                      Navigator.of(context).pop();
                    } else {
                      print(":eroor");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_outlined,
                          color: Color(0xffe24658),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "From Gallery",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (picked != null) {
                      file = File(picked.path);
                      var imgname = s.basename(picked.path);
                      var random = Random().nextInt(10000000);
                      imgname = "$imgname" + "$random";
                      // Create a storage reference from our app
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child("images")
                          .child("$imgname");
                      Ref = storageRef;
                      Navigator.of(context).pop();
                    } else {
                      print(":eroor");
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Icon(Icons.camera_alt, color: Color(0xffe24658)),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "From Camera",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
