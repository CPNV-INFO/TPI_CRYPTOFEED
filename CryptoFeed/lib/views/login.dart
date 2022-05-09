import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled2/config/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String _userName = '';
    if(user != null){
      _userName = user!.displayName.toString();
    } else {
      _userName = 'not logged in';
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
                users.add({
                  'uid':user!.uid
                });
            setState(() {});
          }),
          Text('You are '+(_userName))
        ],
      )
    );
  }
}