import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Image.asset('images/pic1.jpg')),
            Expanded(flex: 2, child: Image.asset('images/pic2.jpg')),
            Expanded(child: Image.asset('images/pic3.jpg')),
          ],
        ),
      ),
    );
  }
}