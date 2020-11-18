import 'package:flutter/services.dart';
import 'package:friend_finder/controllers/welcome/login/command_login_info.dart';
import 'package:friend_finder/controllers/welcome/login/login_way.dart';



class WelcomeController{

    CommandLoginInfo commandLoginInfo;

    Future<Map> loginWith(LoginWay loginWay) async{
      commandLoginInfo=new CommandLoginInfo();
      commandLoginInfo.setLoginWay(loginWay);

      return await commandLoginInfo.getData();
    }





    bool isLogined(){
      return commandLoginInfo.getLoginWay().getLogStatus();
    }
}