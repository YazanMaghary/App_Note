import 'package:design_app_note_login_page/auth/login.dart';
import 'package:design_app_note_login_page/auth/signup.dart';
import 'package:design_app_note_login_page/crud/addnotes.dart';
import 'package:design_app_note_login_page/crud/editnotes.dart';
import 'package:design_app_note_login_page/home/homepage.dart';
import 'package:design_app_note_login_page/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Example For App note Login page
// you will find notes inside code that descripe code important
bool? isLogin;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.notification!.title}");
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(myApp());
  var user = FirebaseAuth.instance.currentUser?.email;
  if (user == null) {
    isLogin = false;
  } else {
    isLogin = true;
  }
}

class myApp extends StatefulWidget {
  const myApp({super.key});

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  int pressed = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xffe24658),
          textTheme: TextTheme(
            button: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          "LogIn": (context) => LogIn(
                pressed: pressed,
              ),
          "SignUp": (context) => SignUP(),
          "HomePage": ((context) => HomePage()),
          "AddNotes": (context) => AddNotes(),
          "EditNotes": (context) => editnotes(),
        },
        home:  isLogin == false ? LogIn(pressed: pressed) : HomePage()
        // isLogin == false ? LogIn(pressed: pressed) : HomePage()
        //  Test()
        //isLogin == false ? LogIn(pressed: pressed) : HomePage()
        // LogIn(pressed: pressed,)
        );
  }
}
