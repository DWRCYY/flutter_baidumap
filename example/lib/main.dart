import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_baidumap/flutter_baidumap.dart' as BaidumapPlugin; // deferred

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _deviceInfo = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // await BaidumapPlugin.loadLibrary();

    String platformVersion;
    dynamic deviceInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await BaidumapPlugin.FlutterBaidumap.platformVersion;
      deviceInfo = await BaidumapPlugin.FlutterBaidumap.deviceInfo;

    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _deviceInfo = jsonEncode(deviceInfo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              Text('Running on: $_deviceInfo\n'),
              FlatButton(
                child: Text('open'),
                onPressed: () { this.openMapView(); },
              ),
              FlatButton(
                child: Text('GetLocation'),
                onPressed: () { this.getCurrentLocation(); },
              )
            ],
          ),
        ),
      ),
    );
  }

  void openMapView() async{
    try {
      Map<String, dynamic> args = {
        'defaultLocation': { 'longitude': 120.179, 'latitude': 30.256 },
        'showDefaultLocation': true
      };
      var result = await BaidumapPlugin.FlutterBaidumap.chooseLocation(args);
      print(result);
    } catch (e) {
      print('$e');
    }
  }

  void getCurrentLocation() async {
    var result = await BaidumapPlugin.FlutterBaidumap.getCurrentPosition();
    print(result);
    if (result['status'] == 0) {
      var data = result["data"];
      var coord = {
        'longitude': data['longitude'],
        'latitude': data['latitude']
      };
      result = await BaidumapPlugin.FlutterBaidumap.getAddress(coord);
    }
  }

}
