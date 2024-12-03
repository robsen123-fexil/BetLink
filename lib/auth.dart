// ignore_for_file: prefer_const_constructors, avoid_print, unused_element, non_constant_identifier_names, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Authpage extends StatefulWidget {
  const Authpage({
    super.key,
  });

  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  final TextEditingController emailcontroller = TextEditingController();

  final TextEditingController passwordcontroller = TextEditingController();

  final TextEditingController usernamecontroller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  late String useremail;
  late String res;
  late String password;
  late String username;
  late String phone;
  late String error;
  bool showspinner = false;

  bool checkbox = false;

  Future<void> _launchurl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print("invalid url");
    }
  }

  Future<void> registeruser(String email, String password) async {
    try {
      UserCredential usercredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = usercredential.user;
      await user?.sendEmailVerification();
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
      _showDialog(context, "Veridication sent to Your email");
    } catch (e) {
      print(e);
      _showDialog(context, e.toString());
    }
  }

  _showDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Notice'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Ok!"))
              ],
            ));
  }

  // Future<bool> isemailverified() async {
  //   User? user = _auth.currentUser;
  //   await user?.reload();
  //   return user?.emailVerified ?? false;
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showspinner,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Flexible(
                child: Container(
                  height: 500,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 251, 251),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Registration",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Email",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller: emailcontroller,
                                    onChanged: (value) {
                                      useremail = value;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'username',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                      filled: true, // Fill the background color
                                      fillColor:
                                          Colors.grey[200], // Background color
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              20.0), // Padding inside the TextField
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    onChanged: (value) {
                                      password = value;
                                    },
                                    controller: passwordcontroller,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'password',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),
                                      filled: true, // Fill the background color
                                      fillColor:
                                          Colors.grey[200], // Background color
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              20.0), // Padding inside the TextField
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "username",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: TextField(
                                    controller: usernamecontroller,
                                    onChanged: (value) {
                                      username = value;
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'username',
                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic),

                                      filled: true, // Fill the background color
                                      fillColor:
                                          Colors.grey[200], // Background color
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal:
                                              20.0), // Padding inside the TextField
                                    ),
                                  ),
                                ),
                              ],
                            )),
                            // Expanded(
                            //     child: OutlinedButton(
                            //   onPressed: () {
                            //     _launchurl('www.google.com');
                            //   },
                            //   style: OutlinedButton.styleFrom(
                            //     foregroundColor: Colors.black,
                            //     side: BorderSide.none, // Remove the border
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(
                            //           30), // Rounded corners
                            //     ),
                            //   ),

                            // ))
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blueAccent),
                                onPressed: () async {
                                  showspinner = true;
                                  registeruser(emailcontroller.text,
                                      passwordcontroller.text);

                                  try {
                                    registeruser(useremail, password);
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Error'),
                                          content: Text(e.toString()),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  // } FirebaseAuthException catch (e) {
                                  //   print(e);
                                  // }
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
