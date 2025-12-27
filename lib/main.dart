import 'package:flutter/material.dart';
import 'screens/auth/login_signup_page.dart';

void main() {
  runApp(CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Connect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginSignupPage(),
    );
  }
}