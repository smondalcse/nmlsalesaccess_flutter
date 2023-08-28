import 'package:flutter/material.dart';
import 'package:nmlsalesaccess/pages/login_screen.dart';

void main() {
  runApp(const MyApp());
 // DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const Login(),
    );
  }
}

