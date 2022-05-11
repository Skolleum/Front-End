import 'package:flutter/material.dart';

import '../pages/auth/login.dart';
import '../pages/home.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case MyHomePage.routeName:
        return MaterialPageRoute(builder: (_) => MyHomePage());
    }
  }
}
