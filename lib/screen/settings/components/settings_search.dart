import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/screen/settings/components/settings_body.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constant.dart';

class SettingsSearch extends StatefulWidget {
  @override
  _SettingsSearchState createState() => _SettingsSearchState();
}

class _SettingsSearchState extends State<SettingsSearch> {
  double userInterestRadius = 0;
  double userAnonimityLevel = 0;
  double serverAnonimityLevel = 0;
  double serverInterestRadius = 0;
  double lastUpdateZoomValue = 0;
  bool isTrustedServer = false;
  bool isMapZoom = false;
  double zoomValue;
  Marker marker;
  Circle circle;

  Widget subWidget;
  SettingsBodyState st;
  double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    st = context.findAncestorStateOfType();




    return Container(
        child: Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                //PRIVACY REQUIREMENTS FOR OTHER USER
                Container(
                  width: screenWidth * 0.95,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withAlpha(200),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Text(
                        "Diğer kullanıcılara karşı : ",
                        style: TextStyle(color: kTextColor),
                      ),
                      Column(
                        children: [
                          //USER INTEREST RADIUS FOR OTHER USERS
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.02, 0, 0, 0),
                                    child: Text(
                                      "İlgi Alanı",
                                      style: TextStyle(color: kTextColor),
                                    )),
                                Slider(
                                  activeColor: kSliderColor,
                                  divisions: 500,
                                  value: userInterestRadius,
                                  label: (userInterestRadius * 50)
                                          .toStringAsFixed(1) +
                                      " km",
                                  autofocus: true,
                                  onChangeStart: (newRating) {
                                    st.setState(() {
                                      userInterestRadius = newRating;
                                      lastUpdateZoomValue = userInterestRadius;
                                      st.isSearchSettingsMapEnabled = true;
                                      st.zoomValue = userInterestRadius * 50;
                                      st.getCurrentLocation();
                                    });
                                  },
                                  onChangeEnd: (newRating) {
                                    setState(() {
                                      userInterestRadius = newRating;
                                      if (lastUpdateZoomValue -
                                                  userInterestRadius >
                                              0.04 ||
                                          lastUpdateZoomValue -
                                                  userInterestRadius <
                                              -0.04) {
                                        lastUpdateZoomValue = newRating;
                                        st.setState(() {
                                          st.zoomValue =
                                              userInterestRadius * 50;
                                          st.getCurrentLocation();
                                        });
                                      }

                                      st.isSearchSettingsMapEnabled = false;
                                    });
                                  },
                                  onChanged: (newRating) {
                                    userInterestRadius = newRating;
                                    setState(() {
                                      st.setState(() {
                                        st.isSearchSettingsMapEnabled = true;
                                        st.zoomValue = userInterestRadius * 50;
                                        st.getCurrentLocation();
                                      });
                                    });
                                  },
                                ),
                                SizedBox(
                                    height: kDefaultFontSize,
                                    child: Text(
                                      "${(userInterestRadius * 50).toStringAsFixed(1)} km",
                                      style: TextStyle(color: kTextColor),
                                    )),
                              ],
                            ),
                          ),
                          //KANONITMY LEVEL FOR USERS
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    padding: EdgeInsets.fromLTRB(
                                        screenWidth * 0.02, 0, 0, 0),
                                    child: Text(
                                      "Gizlilik seviyeniz",
                                      style: TextStyle(color: kTextColor),
                                    )),
                                Slider(
                                  activeColor: kSliderColor,
                                  divisions: 500,
                                  value: userAnonimityLevel,
                                  label:
                                      "${(userAnonimityLevel * 100).toInt()} kullanıcı",
                                  autofocus: true,
                                  onChanged: (newRating) {
                                    setState(() {
                                      userAnonimityLevel = newRating;
                                    });
                                  },
                                ),
                                SizedBox(
                                    height: kDefaultFontSize,
                                    child: Text(
                                      "${(userAnonimityLevel * 100).toInt()} kullanıcı",
                                      style: TextStyle(color: kTextColor),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                //USER SPECIFICATION FOR SERVER
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          "Güvenilmez Server",
                          style: TextStyle(color: kTextColor),
                        ),
                        Checkbox(
                          value: isTrustedServer,
                          onChanged: (value) {
                            setState(() {
                              isTrustedServer = !isTrustedServer;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: isTrustedServer ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),

                    //PRIVACY REQUIREMENTS FOR SERVER
                    child: Container(
                      width: screenWidth * 0.95,
                      decoration: BoxDecoration(
                        color: kPrimaryColor.withAlpha(200),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          Text(
                            "Servere karşı : ",
                            style: TextStyle(color: kTextColor),
                          ),
                          Column(
                            children: [
                              //USER INTEREST RADIUS FOR SERVER
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.fromLTRB(
                                            screenWidth * 0.02, 0, 0, 0),
                                        child: Text(
                                          "İlgi Alanı",
                                          style: TextStyle(color: kTextColor),
                                        )),
                                    Slider(
                                      activeColor: kSliderColor,
                                      divisions: 500,
                                      value: serverInterestRadius,
                                      label: (serverInterestRadius * 50)
                                              .toStringAsFixed(1) +
                                          " km",
                                      autofocus: true,
                                      onChangeEnd: (newRating) {
                                        setState(() {
                                          serverInterestRadius = newRating;
                                          if (lastUpdateZoomValue -
                                                      userInterestRadius >
                                                  0.04 ||
                                              lastUpdateZoomValue -
                                                      userInterestRadius <
                                                  -0.04) {
                                            lastUpdateZoomValue = newRating;
                                            st.setState(() {
                                              st.zoomValue =
                                                  serverInterestRadius * 50;
                                              st.getCurrentLocation();
                                            });
                                          }

                                          st.isSearchSettingsMapEnabled = false;
                                        });
                                      },
                                      onChanged: (newRating) {
                                        serverInterestRadius = newRating;
                                        setState(() {
                                          st.setState(() {
                                            st.isSearchSettingsMapEnabled =
                                                true;
                                            st.zoomValue =
                                                serverInterestRadius * 50;
                                            st.getCurrentLocation();
                                          });
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: kDefaultFontSize,
                                        child: Text(
                                          "${(serverInterestRadius * 50).toStringAsFixed(1)} km",
                                          style: TextStyle(color: kTextColor),
                                        )),
                                  ],
                                ),
                              ),

                              //KANONITMY LEVEL FOR SERVER
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.fromLTRB(
                                            screenWidth * 0.02, 0, 0, 0),
                                        child: Text(
                                          "Gizlilik seviyeniz",
                                          style: TextStyle(color: kTextColor),
                                        )),
                                    Slider(
                                      activeColor: kSliderColor,
                                      divisions: 500,
                                      value: serverAnonimityLevel,
                                      label:
                                          "${(serverAnonimityLevel * 100).toInt()} kullanıcı",
                                      autofocus: true,
                                      onChanged: (newRating) {
                                        setState(() {
                                          serverAnonimityLevel = newRating;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                        height: kDefaultFontSize,
                                        child: Text(
                                          "${(serverAnonimityLevel * 100).toInt()} kullanıcı",
                                          style: TextStyle(color: kTextColor),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
