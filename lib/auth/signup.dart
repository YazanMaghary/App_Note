import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app_note_login_page/auth/login.dart';
import 'package:design_app_note_login_page/component/aler.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:design_app_note_login_page/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SignUP extends StatefulWidget {
  @override
  State<SignUP> createState() => _SignUPState();
}

class _SignUPState extends State<SignUP> {
  var press = LogIn(pressed: pressed);
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  late String username, password, email, token;
  SignIN() async {
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context);
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return UserCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Weak password',
            desc: 'The password provided is too weak.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            title: 'Already exist',
            desc: 'The account already exists for that email.',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("object");
    }
  }

  getToken() async {
    FirebaseMessaging.instance
        .getToken()
        .then((value) {
          token = value as String;
          print("Token $token ");
        } );

  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: pressed == 0 ? Colors.white : Colors.black,
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                child: Center(
                  child: Image.asset("images/logo.png"),
                ),
              ),
              //  log in form
              Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: formstate,
                  child: Column(
                    children: [
                      //UserName
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Color(0xffe24658),
                              ),
                        ),
                        child: TextFormField(
                          onSaved: (val) {
                            username = val!;
                          },
                          validator: (val) {
                            String str1 = val!;
                            if (str1.length > 20) {
                              return "User name cant be more than 20 letter";
                            }
                            if (str1.length < 4) {
                              return "User name cant be less than 4 letter";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 1,
                              color: pressed == 0 ? Colors.white : Colors.black,
                            )),
                            hintText: "Username",
                            prefixIcon: Icon(
                              Icons.person,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // PassWord
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Color(0xffe24658),
                              ),
                        ),
                        child: TextFormField(
                          onSaved: (val) {
                            email = val!;
                          },
                          validator: (val) {
                            String str1 = val!;
                            if (str1.length > 30) {
                              return "Email name cant be more than 20 letter";
                            }
                            if (str1.length < 4) {
                              return "Email cant be less than 4 letter";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 1,
                              color: pressed == 0 ? Colors.white : Colors.black,
                            )),
                            hintText: "Email",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ThemeData().colorScheme.copyWith(
                                primary: Color(0xffe24658),
                              ),
                        ),
                        child: TextFormField(
                          onSaved: (val) {
                            password = val!;
                          },
                          validator: (val) {
                            String str1 = val!;
                            if (str1.length > 30) {
                              return "Password name cant be more than 20 letter";
                            }
                            if (str1.length < 4) {
                              return "Password cant be less than 4 letter";
                            }

                            return null;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context).primaryColor)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                              width: 1,
                              color: pressed == 0 ? Colors.white : Colors.black,
                            )),
                            hintText: "Password",
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "If you have account ",
                              style: TextStyle(
                                  color: pressed == 1
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("LogIn");
                              },
                              child: Text(
                                "LogIn",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              splashFactory: NoSplash.splashFactory,
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              shadowColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              var response = await SignIN();
                              if (response != null) {
                                //save account iformation to firestore .
                                await FirebaseFirestore.instance
                                    .collection("user")
                                    .add({
                                  "username": username,
                                  "email": email,
                                  "token": token,
                                }).then((value) => value);
                                Navigator.of(context)
                                    .pushReplacementNamed("HomePage");
                              } else {
                                print("Sign up faild");
                              }
                            },
                            child: Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.labelLarge,
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
