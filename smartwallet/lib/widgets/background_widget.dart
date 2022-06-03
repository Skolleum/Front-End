import 'package:flutter/material.dart';
import 'package:smartwallet/constants/asset_constants.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            AssetConstants.LOGIN_BACKGROUND,
          ),
          fit: BoxFit.contain,
          invertColors: true,
          opacity: 0.1,
          repeat: ImageRepeat.repeat,
        ),
        color: Color.fromARGB(255, 73, 120, 111), //dark
      ),
    );
  }
}

class required {}
