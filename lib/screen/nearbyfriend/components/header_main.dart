import 'package:flutter/material.dart';
import 'package:friend_finder/constant.dart';

class HeaderMain extends StatelessWidget  implements PreferredSizeWidget {
  const HeaderMain({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text("widget.title"),
      backgroundColor: kPrimaryColor,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => appBarSize;
}