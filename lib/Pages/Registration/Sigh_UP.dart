import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../globle.dart';
import '../../progress_dialogs.dart';
import 'Log_In.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool securetxt = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController fathernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController rollnoController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController universityController = TextEditingController();

  validateForm() {
    if (nameController.text.length < 4) {
      Fluttertoast.showToast(msg: "Name must be atleast 4 characters");
    } else if (fathernameController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Father Name is Required.");
    } else if (!emailController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email is not valid");
    } else if (cnicController.text.length < 13) {
      Fluttertoast.showToast(msg: "Cnic must be atleast 13 Numbers");
    } else if (numberController.text.length < 11) {
      Fluttertoast.showToast(msg: "Number must be atleast 11 Numbers");
    } else if (rollnoController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Roll number is Required");
    } else if (departmentController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Department is Required");
    } else if (universityController.text.isEmpty) {
      Fluttertoast.showToast(msg: "University is Required");
    } else {
      saveUserInfo();
    }
  }

  saveUserInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });
    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error:$msg");
    }))
        .user;
    if (firebaseUser != null) {
      Map usersMap = {
        "id": firebaseUser.uid,
        "name": nameController.text.trim(),
        "father name": fathernameController.text.trim(),
        "email": emailController.text.trim(),
        "cnic": cnicController.text.trim(),
        "number": numberController.text.trim(),
        "rollno": rollnoController.text.trim(),
        "department": departmentController.text.trim(),
        "university": universityController.text.trim(),
        "profile":
            "https://firebasestorage.googleapis.com/v0/b/busbyu-926c1.appspot.com/o/bbu.png?alt=media&token=33b9340e-b109-4bd4-a6cc-791b58913243",
      };
      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).set(usersMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LogIn(),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white12,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
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
                const SizedBox(
                  height: 10,
                ),
                const Text("Registration",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name",
                      hintText: "Name",
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
                      suffixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.black,
                      )),
                  textCapitalization: TextCapitalization.sentences,
                ),
                //AppFormField(),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: fathernameController,
                  decoration: const InputDecoration(
                      labelText: "Father Name",
                      hintText: "Father Name",
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
                      suffixIcon: Icon(
                        Icons.verified_user,
                        color: Colors.black,
                      )),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
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
                    suffixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
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
                const SizedBox(
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
                  height: 10,
                ),
                TextField(
                  controller: cnicController,
                  decoration: const InputDecoration(
                    labelText: "CNIC",
                    hintText: "36******",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.perm_identity,
                      color: Colors.black,
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: numberController,
                  decoration: const InputDecoration(
                    labelText: "Number",
                    hintText: "Number",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.call,
                      color: Colors.black,
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
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: rollnoController,
                  decoration: const InputDecoration(
                    labelText: "Roll No",
                    hintText: "6542",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.numbers,
                      color: Colors.black,
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
                  keyboardType: TextInputType.text,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",
                    hintText: "Department",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.local_mall,
                      color: Colors.black,
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
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: universityController,
                  decoration: const InputDecoration(
                    labelText: "University",
                    hintText: "University",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    suffixIcon: Icon(
                      Icons.place,
                      color: Colors.black,
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
                const SizedBox(
                  height: 10,
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
                            "Register",
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
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                      text: "Already have an Account?  ",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: "LogIn",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const LogIn(),
                                    ),
                                  )),
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
