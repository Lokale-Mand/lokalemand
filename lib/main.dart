import 'package:flutter/material.dart';
import 'pages/loginscreen.dart';

void main() {
  runApp(const LokaleMand());
}

class LokaleMand extends StatelessWidget {
  const LokaleMand({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lokalemand',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}