import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/loading_get_users.dart';
import 'package:friend_finder/screen/home/components/home_body.dart';
import 'package:friend_finder/screen/nearbyfriend/components/body.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/':(context) =>HomeBody(),
        '/home':(context) => Body(),
        '/getuser': (context) => LoadingGetUser(),
      },
      initialRoute: '/',

      debugShowCheckedModeBanner: false,
      title: 'Flutter Maps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),




    );
  }
}