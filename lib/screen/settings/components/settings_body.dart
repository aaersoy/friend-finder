import 'dart:async';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/screen/settings/components/settings_app_bar.dart';
import 'package:friend_finder/screen/settings/components/settings_body.dart';
import 'package:friend_finder/screen/settings/components/settings_search.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constant.dart';

class SettingsBody extends StatefulWidget {
  @override
  SettingsBodyState createState() => SettingsBodyState();

}

class SettingsBodyState extends State<SettingsBody> {
  Widget subWidget;
  bool visible=false;
  bool isSearchSettingsMapEnabled=false;


  double userInterestRadius = 0;
  double userAnonimityLevel = 0;
  double serverAnonimityLevel = 0;
  double serverInterestRadius = 0;
  bool isTrustedServer = false;
  bool isMapZoom=false;
  double zoomValue;

  GoogleMapController _googleMapController;
  Marker marker;
  Circle circle;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  var initialCameraPosition;
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<LatLng> getLocationm() async {
    LocationData location = await _locationTracker.getLocation();
    initialCameraPosition = LatLng(location.latitude, location.longitude);
    print(initialCameraPosition.runtimeType);
    return LatLng(location.latitude, location.longitude);
  }

  //Decrease the size and convert to Uint8List for the map
  Future<Uint8List> resizeImage(String path, int width) async {
    print("aradaki");
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Future<Uint8List> getMarker() async {
    print("Marker icon");
    final Uint8List markerIcon =
    await resizeImage('assets/simple_ring.png', 100);
    print("Marker icon" + markerIcon.length.toString());
    return markerIcon;
  }

  void updateMarkerAndCircle(LocationData location, Uint8List imageData) {
    print("2" + location.runtimeType.toString());
    LatLng latlng = LatLng(location.latitude, location.longitude);
    this.setState(() {
      marker = Marker(
        icon: BitmapDescriptor.fromBytes(imageData),
        markerId: MarkerId("home"),
        position: latlng,
        //rotation: newLocalData.heading,
        draggable: false,
        zIndex: 2,
        flat: true,
        anchor: Offset(0.5, 0.5),
      );

      circle = Circle(
          circleId: CircleId("car"),
          radius: location.accuracy,
          zIndex: 1,
          strokeColor: kPrimaryColor.withOpacity(0.4),
          center: latlng,
          fillColor: kPrimaryColor.withAlpha(50));
    });
  }

  getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      print("deneme");
      LocationData location1 = await _locationTracker.getLocation();
      print("1" + location1.runtimeType.toString());
      print("123123123123asdasdas");
      updateMarkerAndCircle(location1, imageData);
      print("3" + location1.runtimeType.toString());
      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_googleMapController != null) {
          _googleMapController.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: zoomValue)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on Exception catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    print(zoomValue);
    subWidget=subWidget!=null? subWidget:Container();
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: appBarSize,
        child: SettingsAppBar(),
      ),

      body: Stack(
        children: [


          Container(
            color:kPrimaryColor.withAlpha(128),
          ),
          Column(
            children: [
              SizedBox(
                height: screenHeight*0.3,
                width: screenWidth,
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.zero,topRight: Radius.zero ,
                        bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    color:kPrimaryColor,
                  ),
                  child:Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: CircleAvatar(
                              child: FloatingActionButton(
                                child: Icon(Icons.account_circle),
                                onPressed: (){
                                  setState(() {
                                    visible=true;
                                  });
                                },
                              ),
                              radius: screenHeight*0.15*0.55,
                            ),
                          ),

                          //USER GELECEK BURAYA, ONA GÖRE İŞLEM YAPILACAK
                          Container(

                            child: Text(
                                "Ayberk Ersoy",
                              style: TextStyle(
                                  color: kTextColor,
                                fontSize: screenHeight*0.3*0.1,
                              ),
                            ),
                          ),

                          ButtonBar(
                            alignment: MainAxisAlignment.spaceEvenly,
                            buttonHeight: screenHeight*0.3*0.2,
                            children: [
                              RaisedButton(
                                color: kPrimaryColor,
                                child: Text(
                                    "Search Ayarları",
                                  style: TextStyle(
                                    color: kTextColor,
                                  ),

                                ),
                                onPressed: (){
                                  setState(() {
                                    subWidget=SettingsSearch();
                                  });

                                },
                              )
                            ],
                          ),


                        ],
                      ),

                    ],
                  )



                ),
              ),
              subWidget,

            ],
          ),


          Container(
            height: MediaQuery.of(context).size.height*0.2,
            width: MediaQuery.of(context).size.width,

            child: Center(
              child: AnimatedOpacity(
                opacity: isSearchSettingsMapEnabled ? 1.0 : 0.0,
                duration: Duration(milliseconds: 500),

                //PRIVACY REQUIREMENTS FOR SERVER
                child: GoogleMap(

                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(37.42796133580664, -122.085749655962),
                    zoom: 0,
                  ),
                  //myLocationEnabled: false,
                  zoomControlsEnabled: false,
                  //zoomGesturesEnabled: false,
                  markers: Set.of((marker != null) ? [marker] : []),
                  circles: Set.of((circle != null) ? [circle] : []),
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController = controller;

                  },
                ),
              ),
            ),

          ),
        ],
      ),
    );
  }
}
