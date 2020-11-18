import 'package:friend_finder/controllers/welcome/login/login_way.dart';

class CommandLoginInfo{

  LoginWay _loginWay;


  LoginWay getLoginWay(){
    return _loginWay;
  }
  void setLoginWay(LoginWay loginWay){
    this._loginWay=loginWay;
  }
  Future<Map>  getData() async{
    return _loginWay.getData();
  }


}