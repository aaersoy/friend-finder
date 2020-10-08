import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friend_finder/constant.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({

    Key key,
    @required this.child,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Container(
      color:kPrimaryColor.withOpacity(0.5),
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
//          Positioned(
//            top: 0,
//            left: 0,
//            child: Image.asset(
//              "assets/car_icon.png",
//              width: size.width * 0.3,
//            ),
//          ),
//          Positioned(
//            bottom: 0,
//            left: 0,
//            child: Image.asset(
//              "assets/car_icon.png",
//              width: size.width * 0.2,
//            ),
//          ),
          child,
        ],
      ),
    );
  }
}