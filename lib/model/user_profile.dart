import 'user.dart';

class UserProfile extends User{



   //Resim saklayacak bir hale getirilmeli, daha sonradan.

  UserProfile({anonimityLevel,interestRegion,userID,userName,avatar}){
    this.anonimityLevel=anonimityLevel;
    this.interestRegion=interestRegion;
    this.userID=userID;
    this.userName=userName;
    this.avatar=avatar;
  }

}



