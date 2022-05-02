import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:untitled2/widget/all.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({Key? key}) : super(key: key);

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  List<dynamic> _cryptos = [];
  //List<dynamic> _foundCryptos = [];
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

  /*void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      results = _cryptos;
    } else {
      results = _cryptos
          .where((element) => element['name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundCryptos = results;
    });
  }*/

  Widget _buildCryptos() {
    String currency = holder.toUpperCase();
    /*_cryptos.sort((b, a) => a['market_data']['current_price'][holder]
        .compareTo(b["market_data"]["current_price"][holder]));*/
    return Scaffold(
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
        /*appBar: AppBar(
        leading: const Text(""),
        actions: <Widget>[
          TextField(
            onChanged: (value) => _runFilter(value),
            decoration: const InputDecoration(
                labelText: 'Search', suffixIcon: Icon(Icons.search)),
          ),
        ],
      ),*/
        body: /*_foundCryptos.isNotEmpty
          ? */
            ListView.builder(
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
                    //trailing: const Icon(Icons.favorite),
                  )
                ],
              ),
            );
          },
        )
        //: Text("No Results found !"),
        );
  }

  @override
  void initState() {
    //_foundCryptos = _cryptos;
    getCryptos();
    super.initState();
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
