import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:design_app_note_login_page/component/aler.dart';
import 'package:design_app_note_login_page/crud/editnotes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../auth/login.dart';
import 'package:design_app_note_login_page/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../crud/showNotes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var db = FirebaseFirestore.instance.collection("Notes");
  var fcm = FirebaseMessaging.instance;
  getUser() {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (final providerProfile in user.providerData) {
        // ID of the provider (google.com, apple.com, etc.)
        final provider = providerProfile.providerId;
        // UID specific to the provider
        final uid = providerProfile.uid;
        // Name, email address, and profile photo URL
        final name = providerProfile.displayName;
        final emailAddress = providerProfile.email;
        final profilePhoto = providerProfile.photoURL;
        print(name);
        print(emailAddress);
      }
    }
  }

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      Navigator.of(context).pushNamed("AddNotes");
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      Navigator.of(context).pushNamed("AddNotes");
    });
  }
  RequestPer() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  void initState() {
    fcm
        .getToken()
        .then((token) => print("Token $token"))
        .onError((error, stackTrace) => print(error));
    RequestPer();
    setupInteractedMessage();
    FirebaseMessaging.onMessage.listen((event) {
      print(event.notification!.body);
    }).onError((e) {
      print(e);
    });
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double mobSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  if (pressed == 0) {
                    pressed++;
                  } else {
                    pressed--;
                  }
                });
              },
              icon: Icon(
                Icons.dark_mode,
                color: pressed == 1 ? Colors.white : Colors.black,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.info,
                animType: AnimType.rightSlide,
                desc: "Are you sure to sign out (*_*)",
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, "LogIn");
                },
              )..show();
            },
            icon: Icon(
              Icons.logout_sharp,
              color: pressed == 1 ? Colors.white : Colors.black,
            )),
        title: Text("NotePage"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      backgroundColor: pressed == 0 ? Colors.white : Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("AddNotes");
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
          child: FutureBuilder<QuerySnapshot>(
              future: db
                  .where("UID",
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            background: Container(
                              color: Theme.of(context).primaryColor,
                            ),
                            onDismissed: (DismissDirection direction) async {
                              await db
                                  .doc(snapshot.data?.docs[index].id)
                                  .delete()
                                  .then(
                                    (doc) => print("Document deleted"),
                                    onError: (e) =>
                                        print("Error updating document $e"),
                                  );
                              // Create a reference to the file to delete
                              final storage = FirebaseStorage.instance
                                  .refFromURL(
                                      snapshot.data?.docs[index]["Image Url"]);
// Delete the file
                              await storage.delete();
                            },
                            child: ListNotes(
                              notes: snapshot.data?.docs[index],
                              docid: snapshot.data?.docs[index].id,
                            ));
                      });
                }
                if (snapshot.hasError) {
                  return Text("Eror on Fitching data!");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()));
                }
                return Container(
                    height: 50,
                    child: Center(child: CircularProgressIndicator()));
              })),
    );
  }
}

class ListNotes extends StatelessWidget {
  var press = LogIn(pressed: pressed);
  final notes;
  final mobSize;
  final img;
  final docid;
  ListNotes({this.notes, this.mobSize, this.img, this.docid});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            shadowColor: pressed == 1 ? Colors.white : Colors.black,
            color: pressed == 0 ? Colors.white : Colors.black,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    child: Image.network(
                      notes["Image Url"],
                      fit: BoxFit.cover,
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  flex: 3,
                  child: ListTile(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return showNotes(
                          docid: docid,
                          list: notes,
                        );
                      }));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    title: Text(
                      notes["Note title "],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: pressed == 1 ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      notes["Note"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: pressed == 1 ? Colors.white : Colors.black),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return editnotes(
                              docid: docid,
                              list: notes,
                            );
                          }));
                        },
                        icon: Icon(
                          Icons.edit,
                          color: pressed == 1 ? Colors.white : Colors.black,
                        )),
                  ),
                )
              ],
            )),
      ],
    );
  }
}
