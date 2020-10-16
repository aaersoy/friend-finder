import 'package:flutter/material.dart';
import 'file:///C:/src/flutter_project/friend_finder/lib/components/cards/specified_user_card.dart';
import 'package:friend_finder/components/user.dart';

import '../../../constant.dart';

class NearbyedUsers extends StatelessWidget {
  const NearbyedUsers({
    Key key,
    @required this.users,
  }) : super(key: key);

  final List<User> users;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(

        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context,index){
            return SpecifiedUserCard(
              user:users[index],
              sizedboxwidth: MediaQuery.of(context).size.width*0.3,

            );
          },

        ),
      ),
    );
  }
}