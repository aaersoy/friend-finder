import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:friend_finder/controllers/welcome/login/login_way.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginWithFB implements LoginWay{

  bool _isLoggedIn = false;
  var _facebookLogin;
  Map _userProfile;
  bool queryCompleted=false;

  LoginWithFB(){
    this._facebookLogin=FacebookLogin();

  }

  Future<Map> getData(){
    _loginWithFB();
  }

  Future<Map> _loginWithFB() async{
    var result = await _facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        var token = result.accessToken.token;

        var graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}').
        timeout(const Duration(seconds: 120));
        var profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        _isLoggedIn = true;
        _userProfile = profile;

        break;

      case FacebookLoginStatus.cancelledByUser:
        _isLoggedIn = false;
        break;

      case FacebookLoginStatus.error:
        _isLoggedIn = false;
        break;

    }
    return _userProfile;

  }

  _logout(){
    _facebookLogin.logOut();
      _isLoggedIn = false;
  }

  bool getLogStatus(){
    return _isLoggedIn;
  }


}