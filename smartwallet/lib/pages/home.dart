import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:smartwallet/auth_singleton.dart';
import 'package:smartwallet/pages/auth/login.dart';
import 'package:smartwallet/pages/bottom-navigation/historical.dart';
import 'package:smartwallet/pages/bottom-navigation/settings.dart';
import 'package:smartwallet/pages/bottom-navigation/prices.dart';
import 'package:smartwallet/pages/bottom-navigation/wallet.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
  static const String routeName = '/myhome';
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  List<Widget> _pages = [
    WalletPage(),
    PricePage(),
    HistoricalPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    // return _buildAuthenticatedPages();
    return AuthCheck.instance.isLoggedIn != null
        ? _buildAuthenticatedPages()
        : LoginScreen();
  }

  Scaffold _buildAuthenticatedPages() {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 166, 198, 211),
      body: _pages[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.wallet_travel),
            title: Text("Wallet"),
            selectedColor: Color.fromARGB(255, 67, 137, 124),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.auto_graph),
            title: Text("Prices"),
            selectedColor: Colors.pink,
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.history),
            title: Text("Historical"),
            selectedColor: Color.fromARGB(255, 118, 72, 4),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings"),
            selectedColor: Color.fromARGB(255, 65, 73, 72),
          ),
        ],
      ),
    );
  }
}
