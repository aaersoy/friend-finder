import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/user.dart';
import '../model/user_profile.dart';

class UserAPI{

  String localJsonPath;
  UserAPI({this.localJsonPath});

  Future<List<User>> getNearbyUser(int userID) async {
    return await requestToJson();
  }


  //For Test Purpose
  Future<List<User>> requestToJson() async{
    var data = json.decode(await getJson()) as Map;
    return userProfileExtraction(data);
  }
  Future<String> getJson() {
    return rootBundle.loadString(localJsonPath);
  }

  List<User> userProfileExtraction(Map data){
    List<User> userList=List<User>();

    for(int i=0;i<data.length;i++){
      userList.add(new UserProfile(
          anonimityLevel: int.parse(data["UserList"][i]["anonimityLevel"]),
          interestRegion: double.parse(data["UserList"][i]["interestRegion"]),
          userID: int.parse(data["UserList"][i]["userID"]),
          userName: data["UserList"][i]["userName"],
          avatar: data["UserList"][i]["avatar"]
      )
      );

    }
    return userList;
  }




  //Actual Operation
  Future<List<User>> requestToServer() async{

  }
}