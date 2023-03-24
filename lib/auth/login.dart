import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:design_app_note_login_page/auth/signup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:design_app_note_login_page/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../component/aler.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key, required pressed});
  @override
  State<LogIn> createState() => _LogInState();
}

// global varriable
int pressed = 0;
//loading 

class _LogInState extends State<LogIn> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  late String password, email,token;
  logIN() async {
    GlobalKey<FormState> formdata = formstate;
    if (formdata.currentState!.validate()) {
      formdata.currentState!.save();
      try {
        showLoading(context);
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return UserCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            desc: 'user-not-found',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        } else if (e.code == 'wrong-password') {
          Navigator.of(context).pop();
          AwesomeDialog(
            context: context,
            dialogType: DialogType.info,
            animType: AnimType.rightSlide,
            desc: 'wrong-password',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }
      }
    } else {}
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
                              "If you dont have account ",
                              style: TextStyle(
                                  color: pressed == 1
                                      ? Colors.white
                                      : Colors.black),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed("SignUp");
                              },
                              child: Text(
                                "SignUp",
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
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              primary: Theme.of(context).primaryColor,
                              shadowColor: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              var response = await logIN();
                              if (response != null) {
                                Navigator.of(context)
                                    .pushReplacementNamed("HomePage");
                              } else {
                                print("Sign up faild");
                              }
                            },
                            child: Text(
                              "LogIn",
                              style: Theme.of(context).textTheme.button,
                            )),
                      )
                    ],
                  ),
                ),
              ),
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
          ),
        ));
  }
}

