import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/apis/users_api.dart';
import 'package:friend_finder/controllers/welcome/welcome_controller.dart';
import 'package:friend_finder/screen/settings/components/settings_body.dart';
import 'file:///C:/src/flutter_project/friend_finder/lib/components/buttons/rounded_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constant.dart';
import 'dart:ui' as ui;

import '../../../components/user.dart';
import 'package:http/http.dart';

import 'nearbyed_user.dart';


class Body extends StatefulWidget {
  Body({Key key, this.title}):super(key: key);
  final String title;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;
  List<User> users;
  Map data={};
  User actualUser;




  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

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

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    print("Ayberk");
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);

    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          //rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: kPrimaryColor.withOpacity(0.4),
          center: latlng,
          fillColor: kPrimaryColor.withAlpha(50));
    });
  }



  void getCurrentLocation() async {
    try {

      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }
      _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(newLocalData.latitude, newLocalData.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });




    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  Future<void> getUsers() async{
    UserAPI userApi=new UserAPI(localJsonPath: "datas/users.json");
    users=(await userApi.getNearbyUser(1)).cast<User>();
  }

  Future<List>


  _makeGetRequest() async {
    // make GET request
    String url = 'https://jsonplaceholder.typicode.com/posts';
    Response response = await get(url);
    // sample info available in response
    int statusCode = response.statusCode;
    Map<String, String> headers = response.headers;
    String contentType = headers['content-type'];
    String json = response.body;
    // TODO convert json to object...
  }


  //server tarafını test etmek için
  Future<void> createAlbum() async {

    final Response response = await post(
      'http://34.78.218.216:443',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': "ayberk",
        'title 2':"ceyda"
      }),
    );

  }


    @override
  Widget build(BuildContext context) {
    //createAlbum();
    Size size=MediaQuery.of(context).size;
    getUsers();

    //print(users);
    Map passedData=ModalRoute.of(context).settings.arguments;
    //actualUser=passedData.isEmpty ? passedData['userData']:actualUser;
    print("Ayberk");
    users=passedData.isEmpty ?  users:passedData['users'];
//    print(data);
//    print(actualUser);
    //print("Ayberkaaaaa");



    //print(users.length);
    return Scaffold(
      appBar: AppBar(
        title:Text("title"),
        backgroundColor: kPrimaryColor,
        actions: [
          RaisedButton(
              child: Icon(Icons.settings),
              onPressed: (){
                Navigator.push(context,
                    MaterialPageRoute(
                          builder: (context) {
                            return SettingsBody();
                          }
                        )
                );
              },
              color: kPrimaryColor,
          ),

        ],
      ),

      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height*0.40,
              child: Stack(
                  children: [
                    GoogleMap(

                      mapType: MapType.normal,
                      initialCameraPosition: initialLocation,
                      markers: Set.of((marker != null) ? [marker] : []),
                      circles: Set.of((circle != null) ? [circle] : []),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;

                      },
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,

                      child: SizedBox(

                        //height: size.height*0.08,
                        //width: size.width*0.30,

                        child: RoundedButton(
                          text: "Etrafa Bakın",
                          press: (){
                            getCurrentLocation();
                          },
                          color: kBackGroundColor,

                        ),
                      ),
                    )
                  ]
              ),
            ),

            NearbyedUsers(users: users),



          ],
        ),
      ),

////      floatingActionButton: FloatingActionButton(
////          child: Icon(Icons.location_searching),
////          backgroundColor: kPrimaryColor,
////          onPressed: () {
////            getCurrentLocation();
////          }),
    );
  }
}

