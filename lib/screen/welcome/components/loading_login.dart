

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friend_finder/apis/users_api.dart';
import 'package:friend_finder/components/user.dart';
import 'package:friend_finder/components/user_profile.dart';
import 'package:friend_finder/constant.dart';
import 'package:friend_finder/controllers/welcome/login/services/login_with_fb.dart';
import 'package:friend_finder/controllers/welcome/welcome_controller.dart';






class LoadingLogin extends StatefulWidget {

  LoadingLogin();
  @override
  _LoadingLogin createState() => _LoadingLogin();
}


class _LoadingLogin extends State<LoadingLogin> {

  WelcomeController welcomeController;

  @override
  Future<void> getUserData() async{
    List<User> users=List<User>();
    UserAPI instance = UserAPI(localJsonPath:"datas/users.json");
    users= await instance.getNearbyUser(1);
    await instance.getNearbyUser(1);
    welcomeController= new WelcomeController();
    var userData = await welcomeController.loginWith(LoginWithFB());

    while(!welcomeController.isLogined()){
      await new Future.delayed(const Duration(seconds: 1));
    }
    //print(userData['name']);


    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'users': users,
    });
    //Navigator.pushReplacementNamed(context, '/home',arguments: welcomeController);

  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body:Center(
        child: SpinKitDualRing(
          color: Colors.white,
          size: 50.0,
        ),
      ),

    );
  }
}
