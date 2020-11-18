import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/constant.dart';
import 'package:friend_finder/screen/settings/components/settings_app_bar.dart';
import 'package:friend_finder/constant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:ui' as ui;

class SettingsMap extends StatefulWidget {
  @override
  _SettingsMap createState() => _SettingsMap();
}

class _SettingsMap extends State<SettingsMap> {


  GoogleMapController _googleMapController;
  Marker marker;
  Circle circle;
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();

  var initialCameraPosition;

  Future<LatLng> getLocationm() async{
    LocationData location=await _locationTracker.getLocation();
    initialCameraPosition=LatLng(location.latitude,location.longitude);

    return LatLng(location.latitude, location.longitude);
  }

  //Decrease the size and convert to Uint8List for the map
  Future<Uint8List> resizeImage(String path, int width) async{

    ByteData data=await rootBundle.load(path);
    ui.Codec codec=await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();

    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
  }


  Future<Uint8List> getMarker() async {

    final Uint8List markerIcon = await resizeImage('assets/simple_ring.png', 100);

    return markerIcon;
  }


  void updateMarkerAndCircle(LocationData location,Uint8List imageData) {

    LatLng latlng=LatLng(location.latitude, location.longitude);
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

  getCurrentLocation() async{
    try{
      Uint8List imageData = await getMarker();

      LocationData  location1 =await _locationTracker.getLocation();


      updateMarkerAndCircle(location1,imageData);

    }
    on Exception catch(e){

    }
  }


//  final CameraPosition initialLocation=CameraPosition(
//      target: LatLng(_locationTracker)

  @override
  Widget build(BuildContext context) {

    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;


    return new FutureBuilder(
      future: getLocationm(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            if (snapshot.hasError)
            {
              return new Center(child: Text('Some warning'));
            }
            else {

              return  new Scaffold(
                appBar: PreferredSize(
                    preferredSize : appBarSize,
                    child:SettingsAppBar()
                ),
                body:Container(
                    child: Stack(
                      children: [
                        GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: snapshot.data,
                          zoom:18,
                        ),
                        markers: Set.of((marker != null ) ? [marker]:[]),
                        circles: Set.of((circle != null) ? [circle] : []),


                        onMapCreated: (GoogleMapController controller){
                          _googleMapController=controller;
                        },

                      ),
                        Positioned(
                            top: MediaQuery.of(context).size.height/2,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height/2-10,
                              width: MediaQuery.of(context).size.width,
                              child: Opacity(
                                opacity: 0.8,
                                child: Container(

                                  decoration: BoxDecoration(
                                    boxShadow: [

                                    ],
                                    color: kPrimaryColor
                                  ),
                                  margin: EdgeInsets.fromLTRB(screenWidth*0.1,screenHeight*0.15,screenWidth*0.1,screenHeight*0.15),

                                  child: Text("Ayberk"),


                                ),
                              ),
                            )
                        )
                      ]
                    )
                ),
              );
            }
        }
      },
    );
    return Scaffold(
      appBar: PreferredSize(
          preferredSize : appBarSize,
          child:SettingsAppBar()
      ),
      body:Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
        target: initialCameraPosition,
        zoom:11,
    ),
          markers: Set.of((marker != null ) ? [marker]:[]),

          onMapCreated: (GoogleMapController controller){
            _googleMapController=controller;
          },

        )
      ),
    );
  }





}
