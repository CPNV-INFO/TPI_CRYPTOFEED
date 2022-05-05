import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/config/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    String dn = '';
    if(user != null){
      dn = user!.displayName.toString();
    } else {
      dn = 'not logged in';
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FloatingActionButton(
              onPressed: () async {
                await service.signInWithGoogle();
            setState(() {});
          }),
          Text('You are '+(dn))
        ],
      )
    );
  }
}