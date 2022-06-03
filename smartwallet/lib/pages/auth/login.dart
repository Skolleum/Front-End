import 'package:flutter/material.dart';
import 'package:smartwallet/constants/string_constants.dart';
import 'package:smartwallet/pages/home.dart';

import '../../auth_singleton.dart';
import '../../helper/shared_preferences.dart';
import '../../widgets/background_widget.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SmartWalletSharedPref walletSharedPref = SmartWalletSharedPref();
    TextEditingController controller = TextEditingController();
    bool _validate = false;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "LOGIN",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2661FA),
                  fontSize: 36),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: StringConstants.LOGIN_PRIVATE_KEY,
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          // Container(
          //   alignment: Alignment.center,
          //   margin: EdgeInsets.symmetric(horizontal: 40),
          //   child: TextField(
          //     decoration: InputDecoration(labelText: "Password"),
          //     obscureText: true,
          //   ),
          // ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: Text(
              "How we use your data?",
              style: TextStyle(fontSize: 12, color: Color(0XFF2661FA)),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: RaisedButton(
              onPressed: () {
                AuthCheck.instance.isLoggedIn == true;
                walletSharedPref.saveStringValue(controller.text);
                Navigator.pushReplacementNamed(context, MyHomePage.routeName);
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
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
                  "LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: GestureDetector(
              onTap: () => {
                Navigator.pushReplacementNamed(context, MyHomePage.routeName),
              },
              child: Text(
                StringConstants.DONT_HAVE_ACCOUNT,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2661FA)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
