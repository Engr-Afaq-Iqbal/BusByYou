import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Registration/Log_In.dart';
import '../ui/bus_search.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const bus_search(),
          ),
        ),
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const LogIn(),
          ),
        ),
      );
    }
  }
}
