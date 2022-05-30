import 'package:CryptoFeed/config/all.dart';
import 'package:flutter/material.dart';
import 'package:CryptoFeed/widget/all.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites Cryptocurrencies"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: StreamBuilder(
          stream: favorites
              .where('isFavorite', arrayContains: user?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            return Text(snapshot.data.toString());
          }),
    );
  }
}
