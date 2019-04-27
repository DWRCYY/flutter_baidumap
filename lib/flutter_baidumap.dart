import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBaidumap {
  static const MethodChannel _channel = const MethodChannel('flutter_baidumap');

  static StreamController<dynamic> _locationUpdateStreamController = new StreamController.broadcast();
  /// 定位监听
  static Stream<dynamic> get onLocationUpdate => _locationUpdateStreamController.stream;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> handler(MethodCall call) {
    String method = call.method;

    switch (method) {
      case 'updateLocation': {
          Map args = call.arguments;
          _locationUpdateStreamController.add(args);
      }
      break;
    }
    return new Future.value('');
  }

  static Future<dynamic> open() async {
    return await _channel.invokeMethod('open');
  }

  static Future<dynamic> getCurrentPosition() async {
    return await _channel.invokeMethod('getCurrentPosition');
  }

  static void startLocate() async {
    _channel.invokeMethod('startLocate');
  }

  static void stopLocate() async {
    _channel.invokeMethod('stopLocate');
    shutdown();
  }

  /// 应用程序退出
  static void shutdown(){
    _locationUpdateStreamController.close();
  }

}