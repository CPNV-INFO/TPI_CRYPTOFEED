import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:CryptoFeed/config/config.dart';
import 'package:CryptoFeed/views/all.dart';
import 'package:CryptoFeed/config/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String userName = '';
    if (user != null) {
      userName = user!.displayName.toString();
    }
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
                child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(isDarkMode
                          ? 'lib/widget/assets/Logo.png'
                          : 'lib/widget/assets/Logo_invert.png'),
                      fit: BoxFit.cover)),
            )),
          ),
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.data?.uid == null) {
                return ListTile(
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    leading: const Icon(Icons.login));
              } else {
                return ListTile(
                  title: Text('Hello ' + userName),
                  leading: const Icon(Icons.account_circle),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () async {
                      await service.signOutFromGoogle();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TrendingPage();
                      }));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "You are now logged out !",
                          style: TextStyle(color: Colors.white),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        duration: Duration(milliseconds: 1500),
                      ));
                    },
                  ),
                );
              }
            },
          ),
          ListTile(
            title: const Text('News Feed'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewsPage()),
              );
            },
            leading: const Icon(Icons.new_releases_sharp),
          ),
          ListTile(
            title: const Text('Cryptocurrencies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CryptoPage()),
              );
            },
            leading: const Icon(Icons.monetization_on),
          ),
          ListTile(
            title: const Text('Trending Searches'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TrendingPage()));
            },
            leading: const Icon(Icons.house),
          ),
          Align(
            child: FloatingActionButton.extended(
              heroTag: 'btnSwitchTheme',
              onPressed: () {
                currentTheme.switchTheme();
              },
              label: const Text('Light/Dark Mode'),
              icon: const Icon(Icons.brightness_6_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
