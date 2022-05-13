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
  List<dynamic> _cryptos = [];
  final ScrollController _scrollController = ScrollController();
  RefreshController controller = RefreshController(initialRefresh: true);

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

  void getCryptos() async {
    final response =
        await http.get(Uri.parse("https://api.coingecko.com/api/v3/coins"));
    setState(() {
      _cryptos = json.decode(response.body);
    });
  }

  String holder = 'usd';

  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  int fav = 0;

  @override
  void initState() {
    getCryptos();
    super.initState();
    fav = -1;
  }

  Widget _buildCryptos() {
    CollectionReference favorites =
        FirebaseFirestore.instance.collection('favorites');
    String docID = '';
    String currency = holder.toUpperCase();
    var notFavIcon = const Icon(Icons.favorite_border);
    var favIcon = const Icon(Icons.favorite);
    return Scaffold(
      /// Go back to top Button
      floatingActionButton: FloatingActionButton.extended(
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
                          icon: Icon(((fav == index))
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            if (user != null) {
                              if (fav == index) {
                                favorites.doc(docID).delete();
                              } else {
                                favorites.add({
                                  'id': cryptos['id'],
                                  'isFavorite': true,
                                  'userID': user?.uid
                                }).then((value) => docID = value.id);
                              }
                              setState(() {
                                fav = index;
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const Dialog(
                                      child: Card(
                                        child: Text(
                                            'You are not logged in. Please login in order to add a Crypto to favorites'),
                                      ),
                                    );
                                  });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }

  String selectedValue = 'usd';

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
