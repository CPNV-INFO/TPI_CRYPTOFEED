import 'package:CryptoFeed/data/cryptos_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:CryptoFeed/config/all.dart';
import 'package:CryptoFeed/widget/all.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CryptoPage extends StatefulWidget with ChangeNotifier{
  CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  /// Will store the API values after map
  static List<Cryptos> _cryptos = [];

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

  int currentPage = 1;
  RefreshController controller = RefreshController(initialRefresh: true);

  /// Loads the API and calls the model that maps the values
  Future<bool> getCryptos({bool isRefresh = false}) async {
    final response = await http.get(Uri.parse(
        "https://api.coingecko.com/api/v3/coins?per_page=10&page=$currentPage"));

    if (response.statusCode == 200) {
      final result = CryptosDataFromJson(response.body);

      if (isRefresh == true) {
        _cryptos = result.cryptos;
      } else if (isRefresh == false) {
        _cryptos.addAll(result.cryptos);
      }

      setState(() {});
      return true;
    } else {
      return false;
    }
  }

  /// Changes the holder to the selected price currency of the dropdown
  void getDropDownItem() {
    setState(() {
      holder = selectedValue;
    });
  }

  final List<bool> boolFavorites = [];

  final String? _user = user?.uid.toString();

  /// Build the Crypto list page
  Widget _buildCryptos() {
    String currency = holder.toUpperCase();
    CollectionReference favorites =
        FirebaseFirestore.instance.collection('favorites');
    String page = "$currentPage" + 10.toString();
    var ref = favorites.doc(page);
    ref.get().then((value) {
      if (value.exists == false) {
        for (int i = 0; i < _cryptos.length; i++) {
          favorites.doc(_cryptos[i].id).set({
            'id': _cryptos[i].id,
            'name': _cryptos[i].name,
            'isFavorite': []
          });
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
            SchedulerBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                  _scrollController.position.minScrollExtent,
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastOutSlowIn);
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "You are on top of the page !",
                style: TextStyle(color: Colors.white),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 1500),
            ));
          },
          icon: const Icon(Icons.arrow_upward),
        ),
        body: SmartRefresher(
          controller: controller,
          enablePullUp: true,
          onRefresh: () async {
            currentPage = 1;
            final result = await getCryptos(isRefresh: true);
            if (result) {
              controller.refreshCompleted();
            } else {
              controller.refreshFailed();
            }
          },
          onLoading: () async {
            currentPage++;
            final result = await getCryptos(isRefresh: false);
            if (result) {
              controller.loadComplete();
            } else {
              controller.loadFailed();
            }
            LoadStyle.ShowWhenLoading;
          },
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: _cryptos.length,
            itemBuilder: (context, int index) {
              final cryptos = _cryptos[index];
              String image = cryptos.image.large;
              String price = holder;
              DocumentReference favs = favorites.doc(cryptos.id);
              if (holder == "chf") {
                price = cryptos.current_price.chf;
              } else if (holder == "eur") {
                price = cryptos.current_price.eur;
              } else {
                price = cryptos.current_price.usd;
              }
              return Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(image),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text(cryptos.name),
                        subtitle: Text("" + price + " $currency"),
                        trailing: IconButton(
                          icon: Icon(boolFavorites[index] == true
                              ? Icons.favorite
                              : Icons.favorite_border),
                          onPressed: () {
                            if (user != null) {
                              if (boolFavorites[index] == true) {
                                favs.update({
                                  "isFavorite": FieldValue.arrayRemove([_user])
                                });
                              } else {
                                favs.update({
                                  'isFavorite': FieldValue.arrayUnion([_user])
                                });
                              }
                              boolFavorites[index] = !boolFavorites[index];
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
                        )
                    )
                  ],
                ),
              );
            },
          ),
        ));
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
