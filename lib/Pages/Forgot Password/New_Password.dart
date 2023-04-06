import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Registration/Log_In.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool securetxt = true;
  bool securetxt1 = true;

  TextEditingController NewpassController = TextEditingController();
  TextEditingController conformNewpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            // color: Colors.white60,
            ),
        child: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                height: 200,
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
            const SizedBox(
              height: 20,
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Column(
                children: [
                  const Text(
                    "Set New Password",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Montserrat",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: NewpassController,
                    decoration: InputDecoration(
                      labelText: "New Password",
                      hintText: "New Password",
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
                  TextFormField(
                    controller: conformNewpassController,
                    decoration: InputDecoration(
                      labelText: "Conform Password",
                      hintText: "Conform Password",
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
                            if (securetxt1 == true) {
                              securetxt1 = false;
                            } else {
                              securetxt1 = true;
                            }
                          });
                        },
                        child: securetxt1
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
                            if (NewpassController.text ==
                                conformNewpassController.text) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogIn(),
                                ),
                              );
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Password Does not match");
                            }
                          },
                          borderRadius: BorderRadius.circular(30),
                          child: const Center(
                            child: Text(
                              "set",
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
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
