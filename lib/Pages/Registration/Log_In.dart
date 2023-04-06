import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../globle.dart';
import '../../progress_dialogs.dart';
import '../Forgot Password/Enter_Email.dart';
import '../ui/bus_search.dart';
import 'Sigh_UP.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool securetxt = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  validateForm() {
    if (!emailController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid");
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is Required");
    } else {
      loginUser();
    }
  }

  loginUser() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: msg.toString(),
      );
    }))
        .user;

    if (firebaseUser != null) {
      currentFirebaseUser = firebaseUser;

      print(currentFirebaseUser?.displayName);
      print(currentFirebaseUser?.photoURL);
      print(currentFirebaseUser?.email);
      Fluttertoast.showToast(msg: "Login Successful...");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => bus_search(),
        ),
      );
    } else {
      Fluttertoast.showToast(msg: "Error Occured during Login.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            // color: Colors.white60,
            ),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90),
                ),
              ),
              child: Center(
                child: Container(
                  height: 220,
                  width: 250,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      "images/bbu.png",
                    ),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Montserrat"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      hintText: "email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Password",
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            if (securetxt == true) {
                              securetxt = false;
                            } else {
                              securetxt = true;
                            }
                          });
                        },
                        child: securetxt
                            ? const Icon(
                                Icons.visibility_off,
                                color: Colors.black,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Colors.black,
                              ),
                      ),
                      labelStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    obscureText: securetxt,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EnterEmail(),
                        ),
                      );
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(
                        right: 10,
                      ),
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.6),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Montserrat"),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      top: 18,
                    ),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.lightBlue,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.white,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            validateForm();
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Don't have an Account?  ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "SignUp",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
