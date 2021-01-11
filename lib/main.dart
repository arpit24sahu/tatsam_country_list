import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:io';
import 'dart:async';

void main(){
  runApp(MyApp()); //Entry point of App
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: HomePage(),
    );
  }
}

List<String> favorites = [];

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int status = 0; //initializes status of connection to "searching..."
  // status: 0 = searching, 1 = connected, 2 = not available
  void _getConnectivity()async{ // getting connectivity status
    setState(() {
      status=0;
    });
    try {
      final result = await InternetAddress.lookup('google.com').timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('Network Available');
        setState(() {
          status = 1; //Network Available
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  Countries(), //Routing to the country list page
            )
        );
      }
    } on SocketException catch (_) {
      print('Network Unavailable');
      setState(() {
        status=2; // Network Unavailable
      });
      Timer(Duration(seconds: 3), () {
        _getConnectivity(); // Checking Internet connectivity again after 3 seconds.
      });
    }
  }
  @override
  void initState() {
    _getConnectivity(); // Initially checking connection
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: (){ //to exit app when back button pressed.
          exit(0);
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Displaying Network status
              Center(),
              (status==0)?Icon(Icons.wifi_rounded):(status==1)?Icon(Icons.check_circle, color: Colors.green,):Icon(Icons.wifi_off_sharp, color: Colors.red,),
              Text(" "),
              (status==0)?Text("Checking..."):(status==1)?Text("Network Available!"):Text("Please Check your Network Connectivity"),
            ],
          ),
        )
    );
  }
}

