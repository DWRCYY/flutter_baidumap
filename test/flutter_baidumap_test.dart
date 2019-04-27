import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_baidumap/flutter_baidumap.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_baidumap');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterBaidumap.platformVersion, '42');
  });
}
