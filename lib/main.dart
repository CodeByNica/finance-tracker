import 'package:flutter/material.dart';
import 'package:hikari/pages/start_page.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: StartPage(), debugShowCheckedModeBanner: false);
  }
}
