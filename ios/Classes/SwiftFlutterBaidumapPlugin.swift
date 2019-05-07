import Flutter
import UIKit

public class SwiftFlutterBaidumapPlugin: NSObject, FlutterPlugin, NavParamsDelegate {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_baidumap", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBaidumapPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
	switch call.method {
	case "getPlatformVersion":
		result("iOS " + UIDevice.current.systemVersion)
		return
	case "open":
		openMapView()
		result(nil)
		return
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
	
	public func result(data: Any) {
		print("Result .....")
		print(data)
	}
}
