import 'dart:async';
import 'package:flutter/material.dart';
import 'package:harian/presentasion/pages/login_page.dart';

class SplashController {
  void navigateToNextPage(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, LoginPage.routeName);
      },
    );
  }
}
