import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_baidumap/flutter_baidumap.dart' deferred as BaidumapPlugin;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await BaidumapPlugin.loadLibrary();

    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await BaidumapPlugin.FlutterBaidumap.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
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

  void openMapView() {
    BaidumapPlugin.FlutterBaidumap.open();
  }

  void getCurrentLocation() async {
    var result = await BaidumapPlugin.FlutterBaidumap.getCurrentPosition();
    print(result);
  }

}
