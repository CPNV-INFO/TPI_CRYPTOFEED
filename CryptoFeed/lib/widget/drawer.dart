import 'package:flutter/material.dart';
import 'package:untitled2/config/config.dart';
import 'package:untitled2/views/all.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()));
            },
            leading: const Icon(Icons.login),
          ),
          ListTile(
            title: const Text('News Feed'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewsPage()),
              );
            },
            leading: const Icon(Icons.new_releases_sharp),
          ),
          ListTile(
            title: const Text('Cryptocurrencies'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CryptoPage()),
              );
            },
            leading: const Icon(Icons.monetization_on),
          ),
          ListTile(
            title: const Text('My Transactions'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const TransactionsPage()),
              );
            },
            leading: const Icon(Icons.compare_arrows_outlined),
          ),
          ListTile(
            title: const Text('Trending Searches'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TrendingPage()));
            },
            leading: const Icon(Icons.house),
          ),
          Align(
            child: FloatingActionButton.extended(
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
