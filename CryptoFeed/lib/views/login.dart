import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.google),
                onPressed: () async {
                  await service.signInWithGoogle();
                  users.add({'uid': user!.uid});
                  setState(() {});
                },
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.github),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const Dialog(
                          child: Text("Not implemented yet"),
                        );
                      });
                },
              )
            ],
          ),
        )
    );
  }
}
