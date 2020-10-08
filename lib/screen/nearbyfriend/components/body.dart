import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:friend_finder/apis/users_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constant.dart';
import 'dart:ui' as ui;

import '../../../components/user.dart';
import 'package:http/http.dart';


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



  @override
  Widget build(BuildContext context) {

    Size size=MediaQuery.of(context).size;
    getUsers();
    print("Ayberk2");
    print(users);
    data=data.isEmpty ? ModalRoute.of(context).settings.arguments : data;
    users=data['users'];
    print(users.length);
    return Scaffold(
      appBar: AppBar(
        title: Text("widget.title"),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              height: size.height*0.55,
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
                      height: size.height*0.08,
                      width: size.width*0.30,
                      child: RaisedButton(

                        child: Text("Etrafa Bakın"),
                        onPressed: (){
                          getCurrentLocation();
                        },
                        color: kPrimaryColor.withOpacity(1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                ]
              ),
            ),

            Container(
              margin: EdgeInsets.only(top:kDefaultPadding),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //One element from read json
                      Card(
                        child: Text(users.elementAt(0).userName),
                      ),
                      Card(
                        child: Text("asdsadas"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton(
//          child: Icon(Icons.location_searching),
//          backgroundColor: kPrimaryColor,
//          onPressed: () {
//            getCurrentLocation();
//          }),
    );
  }
}
