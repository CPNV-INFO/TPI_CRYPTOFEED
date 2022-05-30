import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:CryptoFeed/config/firebase_auth.dart';
import 'package:CryptoFeed/views/all.dart';
import 'package:CryptoFeed/widget/all.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        drawer: const MyDrawer(),
        body: Column(
          children: [
            Image.asset(
              isDarkMode
                  ? 'lib/widget/assets/Logo.png'
                  : 'lib/widget/assets/Logo_invert.png',
              height: 250,
            ),
            const Icon(
              Icons.person,
              size: 150,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'btnLoginGoogle',
                    icon: const Icon(FontAwesomeIcons.google),
                    onPressed: () async {
                      await service.signInWithGoogle();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const TrendingPage()));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "You are logged in ! Hello ${user?.displayName} !",
                          style: const TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.green,
                        duration: const Duration(milliseconds: 4000),
                      ));
                    },
                    label: const Text('Google Login'),
                  ),
                  const Text(' or '),
                  FloatingActionButton.extended(
                    heroTag: 'btnLoginGithub',
                    icon: const Icon(FontAwesomeIcons.github),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "Login with Github is not yet implemented.",
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                      ));
                    },
                    label: const Text('Github Login'),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
