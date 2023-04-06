import 'dart:async';

import 'package:flutter/material.dart';

import '../Registration/Log_In.dart';
import 'Splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    super.initState();
    splashScreen.isLogin(context);
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
        ),
        child: Center(
          child: Container(
            child: Image.asset("images/bbu.png"),
          ),
        ),
      ),
    );
  }
}
