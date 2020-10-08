
import 'package:flutter/material.dart';
import 'file:///C:/src/flutter_project/friend_finder/lib/components/loading_get_users.dart';

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(),
          RaisedButton(
            child: Text("Sonraki sayfaya geç"),
            onPressed: (){
              Navigator.pushNamed(context, '/getuser');
            },
          )
        ],
      ),
    );
  }
}
