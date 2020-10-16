
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friend_finder/components/user.dart';
import 'package:friend_finder/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:slide_button/slide_button.dart';

class SpecifiedUserCard extends StatelessWidget{
  final Widget child;
  final double height;
  final User user;
  final Color backgroundcolor;
  final Color color;
  final Color textcolor;
  final Function onPressed;
  final double initialSliderPercent;
  final double sizedboxwidth;

  const SpecifiedUserCard({
    Key key,
    this.height=60,
    this.user,
    this.child,
    this.backgroundcolor=kBackGroundColor,
    this.onPressed=null,
    this.color=kPrimaryColor,
    this.textcolor=kTextColor,
    this.initialSliderPercent=0.2,
    this.sizedboxwidth=50,

  }):super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child:SizedBox(
        height: height,
        child: SlideButton(
          isDraggable: true,
          backgroundColor: color.withOpacity(0.9),
          backgroundChild: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(sizedboxwidth, 0, 0, 0),
              child: CupertinoButton(
                onPressed: (){},
                child: Row(
                  children: [
                    CircleAvatar(
                      //usere bağlanmalı daha sonradan
                      child: Image.asset("assets/world_2.png"),

                    ),
                    SizedBox(width:10),
                    Text(user.getUserName(),
                      style: TextStyle(
                          color: textcolor,
                          fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          slidingBarColor: backgroundcolor.withOpacity(0.4),
          //initialSliderPercentage: initialSliderPercent,
          
          slidingChild: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Row(

                      children: [
                        Opacity(
                            child: Icon(Icons.arrow_forward_ios),
                            opacity: 1
                        ),
                        Opacity(
                          child: Icon(Icons.message),
                            opacity: 1
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          slideDirection: SlideDirection.RIGHT,

        ),
      ),
    );


  }
}
