import 'package:flutter/material.dart';

class SignUpButton extends StatelessWidget {
  final String title;
  final VoidCallback callback;

  const SignUpButton({super.key, required this.title, required this.callback});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        callback;
      },
      child: Text(title),
    );
  }
}