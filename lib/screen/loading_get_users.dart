

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:friend_finder/apis/users_api.dart';
import 'package:friend_finder/components/user.dart';




class LoadingGetUser extends StatefulWidget {

  @override
  _LoadingGetUserState createState() => _LoadingGetUserState();
}

class _LoadingGetUserState extends State<LoadingGetUser>{


  @override
  void getData() async{

    List<User> users=List<User>();
    UserAPI instance = UserAPI(localJsonPath:"datas/users.json");
    users= await instance.getNearbyUser(1);
    await instance.getNearbyUser(1);//şimdlik statik ama daha sonradan kullanıcıya özel olarak specify edilmeli.
    print(users.length);
    Navigator.pushReplacementNamed(context, '/home', arguments: {'users' : users});

  }



  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body:Center(
        child: SpinKitDualRing(
          color: Colors.white,
          size: 50.0,
        ),
      ),

    );
  }
}
