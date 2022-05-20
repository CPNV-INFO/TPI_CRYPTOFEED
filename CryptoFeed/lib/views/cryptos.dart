import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:CryptoFeed/config/all.dart';
import 'package:CryptoFeed/widget/all.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  /// Will store the API values after map
  List<dynamic> _cryptos = [];

  /// Scroll Controller for "go back to top" button
  final ScrollController _scrollController = ScrollController();

  /// Selected currency is the dropdown in AppBar
  String selectedValue = 'usd';

  /// Will be used as a variable in a [setState] for updating Crypto price currency displayed in the list
  String holder = 'usd';

  /// Declares of dropdown items of Crypto price currency
  List<DropdownMenuItem<String>> get listCurrencies {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        child: Text('CHF'),
        value: 'chf',
      ),
      const DropdownMenuItem(
        child: Text('EUR'),
        value: 'eur',
      ),
      const DropdownMenuItem(
        child: Text('USD'),
        value: 'usd',
      ),
    ];
    return menuItems;
  }

  /// Loads the API and calls the model that maps the values
  void getCryptos() async {
    final response =
        await http.get(Uri.parse("https://api.coingecko.com/api/v3/coins"));
    setState(() {
      _cryptos = json.decode(response.body);
    });
  }

  /// Changes the holder to the selected price currency of the dropdown
  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  /// Initializes the state of the page
  @override
  void initState() {
    getCryptos();
    super.initState();
  }

  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('favorites')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));
  }

  final List<bool> boolFavorites = [];

  final String? _user = user?.uid.toString();

  /// Build the Crypto list page
  Widget _buildCryptos() {
    String currency = holder.toUpperCase();
    CollectionReference favorites =
        FirebaseFirestore.instance.collection('favorites');
    var ref = favorites.doc('bitcoin');
    ref.get().then((value) {
      if (value.exists == false) {
        for (int i = 0; i < _cryptos.length; i++) {
          favorites.doc(_cryptos[i]['id']).set({
            'id': _cryptos[i]['id'],
            'name': _cryptos[i]['name'],
          });
          CollectionReference favs =
              favorites.doc(_cryptos[i]['id']).collection('userID');
          favs.doc(_user!).set({'isFavorite': false});
        }
      }
    });
    for (int i = 0; i < _cryptos.length; i++) {
      boolFavorites.add(false);
    }
    return Scaffold(
      /// Go back to top Button
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'btnTopCrypto',
        label: const Text('Go back to top'),
        onPressed: () {
          SchedulerBinding.instance?.addPostFrameCallback((_) {
            _scrollController.animateTo(
                _scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastOutSlowIn);
          });
        },
        icon: const Icon(Icons.arrow_upward),
      ),
      body: (_cryptos.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _cryptos.length,
              itemBuilder: (BuildContext context, int index) {
                final cryptos = _cryptos[index];
                String image = cryptos['image']['large'];
                CollectionReference favs =
                    favorites.doc(cryptos['id']).collection('userID');
                return Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(image),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text(cryptos['name']),
                          subtitle: Text("" +
                              cryptos['market_data']['current_price'][holder]
                                  .toString() +
                              " $currency"),
                          trailing: IconButton(
                            icon: Icon(boolFavorites[index]
                                ? Icons.favorite
                                : Icons.favorite_border),
                            onPressed: () {
                              if (user != null) {
                                if (boolFavorites[index] == false) {
                                  favs.doc(_user!).update({'isFavorite': true});
                                } else {
                                  favs
                                      .doc(_user!)
                                      .update({'isFavorite': false});
                                }
                                boolFavorites[index] = !boolFavorites[index];
                                setState(() {});
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                    "You are not logged in. Please login in order to add a Crypto to favorites.",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                ));
                              }
                            },
                          ))
                    ],
                  ),
                );
              },
            ),
    );
  }

  /// Builds the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        title: const Text('Cryptocurrencies'),
        centerTitle: true,
        actions: <Widget>[
          DropdownButton(
            icon: const Icon(Icons.price_change_sharp),
            items: listCurrencies,
            onChanged: (String? value) {
              setState(() {
                selectedValue = value!;
              });
              getDropDownItem();
            },
            value: selectedValue,
          )
        ],
      ),
      body: _buildCryptos(),
    );
  }
}
