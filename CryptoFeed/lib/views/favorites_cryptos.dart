import 'package:CryptoFeed/config/all.dart';
import 'package:CryptoFeed/views/all.dart';
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

  getStream() async {
    var querySnapshot =
        await favorites.where('isFavorite', arrayContains: user?.uid).get();
    List allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites Cryptocurrencies"),
        centerTitle: true,
      ),
      drawer: const MyDrawer(),
      body: FutureBuilder(
          future: getStream(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            "${snapshot.data[index]['name']}",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          leading: const Icon(Icons.favorite),
                          trailing: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) => NewsPage(
                                          crypto: 'Crypto AND ' +
                                              snapshot.data[index]['id']),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          const Duration(milliseconds: 200)));
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('You have not added a Crypto to favorites yet.'),
              );
            }
          }),
    );
  }
}
