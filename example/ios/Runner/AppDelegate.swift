import UIKit
import Flutter

import flutter_baidumap

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, BMKGeneralDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // return super.application(application, didFinishLaunchingWithOptions: launchOptions)
	
	self.getMapManager(key: "o0PdgT1a7922KZgRO7V35GGY5qAb4t13", delegate: self)
	
	return true;
  }

	func getMapManager(key: String, delegate: BMKGeneralDelegate) -> Bool {
		let mapManager = BMKMapManager()
		let result = mapManager.start(key, generalDelegate: delegate)
		if (result) {
			NSLog("manager start failed!")
		}
		return result
	}

}
