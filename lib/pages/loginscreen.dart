import 'package:flutter/material.dart';
import 'package:lokalemand/objects/buttons/buttons.dart';
import 'package:lokalemand/pages/signupscreen_buyer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
        child: Column(
          children: [
            const Text(
              "De beste producten liggen in je locale mand"
            ),

            const Text(
              "Ik ben een"
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.lightGreen),
                child : Center(
                  child: SignUpButton(
                    title: "Food producer",
                    callback: () {
                      //OnClick callback
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupScreenBuyer()),
                    );
                    },
                  ),
                )
              )
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.lightGreen),
                child : const Center(
                  //child: SignUpButton(title: "Koper"),
                )
              )
            )
          ],)
        )
      );
  }
}