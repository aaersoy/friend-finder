import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_finder/components/buttons/rounded_button.dart';
import 'package:friend_finder/controllers/welcome/login/services/login_with_fb.dart';
import 'package:friend_finder/controllers/welcome/welcome_controller.dart';
import 'package:friend_finder/screen/loading_get_users.dart';
import 'package:friend_finder/screen/login/components/email/login_screen.dart';
import 'package:friend_finder/screen/welcome/components/loading_login.dart';

import '../../../constant.dart';
import 'background.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Body();
  }
}

class _Body extends State<Body> {
  WelcomeController welcomeController=new WelcomeController();



  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              welcomeUserString,
              style: TextStyle(
                  fontSize: kDefaultFontSize,
                  fontWeight: FontWeight.bold,
                  color:kTextColor,
              ),

            ),
            SizedBox(height: size.height * 0.05),

            Stack(
              children: [

                Image.asset(
                    "assets/world.png",
                    height: size.height * 0.4,
                    color:kBackGroundColor
                ),

              ],
            ),

            SizedBox(height: size.height * 0.05),

            RoundedButton(
              text: "LOGIN",

              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },

              color: kPrimaryColor.withOpacity(1),


            ),

            RoundedButton(
              text: "Login with Facebook",
              press: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoadingLogin();
                    },
                  ),
                );
              },


              color: kPrimaryColor.withOpacity(1),

            ),

//            Center(
//                child: _isLoggedIn
//                    ? Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    Image.network(userProfile["picture"]["data"]["url"], height: 50.0, width: 50.0,),
//                    Text(userProfile["name"]),
//                    OutlineButton( child: Text("Logout"), onPressed: (){
//                      _logout();
//                    },)
//                  ],
//                )
//                    : Center(
//                  child: OutlineButton(
//                    child: Text("Login with Facebook"),
//                    onPressed: () {
//                      _loginWithFB();
//                    },
//                  ),
//                )
//            ),


//            RoundedButton(
//              text: "SIGN UP",
//              color: kPrimaryColor,
//              textColor: Colors.black,
//              press: () {
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(
////                    builder: (context) {
////                      return SignUpScreen();
////                    },
////                  ),
////                );
//              },
//            ),
          ],
        ),
      ),
    );
  }
}