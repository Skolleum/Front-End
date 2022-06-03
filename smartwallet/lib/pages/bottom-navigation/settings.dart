import 'package:flutter/material.dart';
import 'package:smartwallet/pages/auth/login.dart';

import '../../auth_singleton.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () {
            AuthCheck.instance.isLoggedIn == false;
            Navigator.popAndPushNamed(
              context,
              LoginScreen.routeName,
            );
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          textColor: Colors.white,
          padding: const EdgeInsets.all(0),
          child: Container(
            alignment: Alignment.center,
            height: 50.0,
            width: size.width * 0.5,
            decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(80.0),
                gradient: new LinearGradient(colors: [
                  Color.fromARGB(255, 255, 136, 34),
                  Color.fromARGB(255, 255, 177, 41)
                ])),
            padding: const EdgeInsets.all(0),
            child: Text(
              "LOG OUT",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
