import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'New_Password.dart';

class Pin_Page extends StatefulWidget {
  final String Email;

  const Pin_Page(
    this.Email,
  );

  @override
  State<Pin_Page> createState() => _Pin_PageState();
}

class _Pin_PageState extends State<Pin_Page> {
  final pin_controller = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    pin_controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.black;

    final defaultPinTheme = const PinTheme(
      width: 40,
      height: 40,
      textStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      ),
      decoration: BoxDecoration(),
    );

    final cursor = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    final preFilledWidget = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 56,
          height: 3,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 15,
          right: MediaQuery.of(context).size.width / 15,
          top: MediaQuery.of(context).size.height / 50,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 70),
              Container(
                alignment: Alignment.center,
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: Colors.black,
                  size: 60,
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 40,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "OTP Verification",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Enter the OTP sent to ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "${widget.Email!}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                pinAnimationType: PinAnimationType.slide,
                controller: pin_controller,
                focusNode: focusNode,
                defaultPinTheme: defaultPinTheme,
                showCursor: true,
                cursor: cursor,
                preFilledWidget: preFilledWidget,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text(
                      "Didn’t  receive the OTP?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    child: const Text(
                      "RESEND OTP?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewPassword(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: const Center(
                        child: Text(
                          "Verify",
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
      ),
    );
  }
}
