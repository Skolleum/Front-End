import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:smartwallet/helper/crypto_api_helper.dart';

import '../../helper/crypto_cubit.dart';
import '../../model/crypto_model.dart';

class PricePage extends StatefulWidget {
  @override
  PricePageState createState() => PricePageState();
}

class PricePageState extends State<PricePage> {
  // ignore: deprecated_member_use
  List<CryptoCubit> _cryptoList = <CryptoCubit>[];
  final _service = CryptoAPI();

  @override
  void initState() {
    super.initState();
    getCrypto();
  }

  void getCrypto() async {
    _cryptoList = (await _service.fetchPost()).cast<CryptoCubit>();
  }

//build method
  @override
  Widget build(BuildContext context) {
    //Implements the basic Material Design visual layout structure.
    //This class provides APIs for showing drawers, snack bars, and bottom sheets.
    return BlocProvider<CryptoCubit>(
        create: (context) => CryptoCubit()..getCrypto(),
        child: SafeArea(
          child: buildColumn(),
        ));
  }

  Column buildColumn() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Prices",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Respond to button press
                    print("Sort");
                  },
                  icon: Icon(
                    Icons.sort,
                    size: 18,
                    color: Colors.black,
                  ),
                  label: Text(
                    "Sort/Filter",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            //BlocBuilder to retrieve the data from the BlocProvider at the top of the widget tree
            child: BlocBuilder<CryptoCubit, List<Crypto>>(
              // function where you call your api
              builder: (context, snapshot) {
                // Snapshot now returns List<Crypto>
                if (snapshot.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: ListTile(
                              subtitle: Text(snapshot
                                  .elementAt(index)
                                  .lastUpdated
                                  .toString()),
                              leading: Container(
                                height: 100,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Image(
                                    alignment: Alignment.center,
                                    height: 13,
                                    width: 20,
                                    image: NetworkImage(
                                        snapshot.elementAt(index).image),
                                  ),
                                ),
                              ),
                              trailing: Text(
                                "${snapshot.elementAt(index).currentPrice}",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 16, 37, 111),
                                    fontSize: 15),
                              ),
                              title: Text(
                                "${snapshot.elementAt(index).name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              )),
                        );
                      });
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      );
}
