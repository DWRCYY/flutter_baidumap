import Flutter
import UIKit

public class SwiftFlutterBaidumapPlugin: NSObject, FlutterPlugin, NavParamsDelegate, MapManagerDelegate {

	static var channel: FlutterMethodChannel?
	
	var methodResult: FlutterResult?
	
  public static func register(with registrar: FlutterPluginRegistrar) {
	channel = FlutterMethodChannel(name: "flutter_baidumap", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBaidumapPlugin()
	registrar.addMethodCallDelegate(instance, channel: channel!)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
	self.methodResult = result
	
	switch call.method {
	case "getPlatformVersion":
		result("iOS " + UIDevice.current.systemVersion)
		return
	case "open":
		openMapView()
		result(nil)
		return
	case "getCurrentPosition":
		getCurrentPosition()
		return
	case "getAddress":
		let args = call.arguments as! Dictionary<String, Any>
		let lng = args["longitude"] as! Double
		let lat = args["latitude"] as! Double
		self.getAddress(longitude: lng, latitude: lat)
	default:
		result(nil)
	}
  }

  func openMapView() {
    // let mapView = MapViewController()
    // UIApplication.shared.delegate?.window.unsafelyUnwrapped?.rootViewController = mapView
    // mapView.show()

	
    let window = UIApplication.shared.delegate?.window.unsafelyUnwrapped
	print("rootviewctrl: \(window?.rootViewController == nil)")

    let mapView = MapViewController()
	mapView.navParamsDelegate = self
	// let navigationController = UINavigationController(rootViewController: window!.rootViewController!)
    // window?.rootViewController = navigationController
	
	// navigationController.present(mapView, animated: true, completion: nil)
	
	window?.rootViewController?.present(mapView, animated: true, completion: nil)
	
    // window?.makeKeyAndVisible()

  }
	
	func getCurrentPosition() {
		let bm_ak = "B9qAiw8CRSo43dC34gerkiuDbnylOepP"
		MapManager.checkPermission(key: bm_ak)
		print(Bundle.main.bundleIdentifier as Any)
		let _mapManager = MapManager()
		_mapManager.delegate = self
		_mapManager.getCurrentPosition()
	}
	
	public func onLocateCompleted(location: CLLocation?, networkState: Int, error: Error?) {
		if (error != nil) {
			print(error as Any)
			let e = error! as NSError
			let rs = [ "status": -1, "code": e.code as Any, "message": e.localizedDescription ]
			self.methodResult!(rs)
			return;
		}
		print(location as Any)
		let data = [
			"status": 0,
			"data": [
				"longitude": location?.coordinate.longitude,
				"latitude": location?.coordinate.latitude,
				"altitude": location?.altitude,
				"speed": location?.speed,
				"course": location?.course,
				"time": location?.timestamp.timeIntervalSince1970
			]
		] as [ String: Any ]
		// print(data as Any)
		self.methodResult!(data)
	}
	
	public func getAddress(longitude: Double, latitude: Double) {
		// let _mapManager = MapManager()
		let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
		// _mapManager.getAddress(location: location)
		
	}
	
	public func result(data: Any) {
		print("Result .....")
		print(data)
	}
}
