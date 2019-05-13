//
//  MapManager.swift
//  flutter_baidumap
//
//  Created by GXHC on 2019/5/9.
//

import Foundation

public protocol MapManagerDelegate: NSObject {
	func onLocateCompleted(location: CLLocation?, networkState: Int, error: Error?)
}

public class MapManager: NSObject {
	
	public var delegate: MapManagerDelegate?
	static var locationManager: BMKLocationManager?
	
	public static func checkPermission(key: String) {
		BMKLocationAuth.sharedInstance()?.checkPermision(withKey: key, authDelegate: nil)
	}
	
	func initLocationManager() {
		if (MapManager.locationManager != nil) {
			return
		}
		MapManager.locationManager = BMKLocationManager()
		// self.locationManager?.delegate = self as? BMKLocationManagerDelegate
		MapManager.locationManager?.coordinateType = BMKLocationCoordinateType.BMK09LL
		MapManager.locationManager?.isNeedNewVersionReGeocode = true
		MapManager.locationManager?.distanceFilter = kCLDistanceFilterNone
		MapManager.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
		MapManager.locationManager?.activityType = CLActivityType.automotiveNavigation
		MapManager.locationManager?.pausesLocationUpdatesAutomatically = false
		// MapManager.locationManager?.allowsBackgroundLocationUpdates = true
		MapManager.locationManager?.locationTimeout = 10
		MapManager.locationManager?.reGeocodeTimeout = 10
	}
	
	public func getCurrentPosition() {
		if (MapManager.locationManager == nil) {
			self.initLocationManager()
		}
		MapManager.locationManager?.requestLocation(
			withReGeocode: true, withNetworkState: true,
			completionBlock: self.locatingCompleted)
	}
	
	func locatingCompleted(location: BMKLocation?, state: BMKLocationNetworkState, error: Error?) {
		if (error == nil) {
			self.getAddress(location: (location?.location?.coordinate)!)
		}
		
		// print(location as Any)
		self.delegate?.onLocateCompleted(location: location?.location, networkState: Int(state.rawValue), error: error)
	}
	
	func getAddress(location: CLLocationCoordinate2D) {
		let geoSearch = GeoSearch()
		geoSearch.getAddress(location: location)
		
//		let geocoder = CLGeocoder()
//		if #available(iOS 11.0, *) {
//			geocoder.reverseGeocodeLocation(coord, preferredLocale: nil, completionHandler: geocodeCompleted)
//		} else {
//			geocoder.reverseGeocodeLocation(coord, completionHandler: geocodeCompleted)
//		}
	}
	
	func geocodeCompleted(returnedItems: [CLPlacemark]?, activityError: Error?) {
		print(activityError as Any)
		print(returnedItems as Any)
		if (returnedItems != nil) {
			let placemark = returnedItems![0]
			let address = placemark.addressDictionary!["FormattedAddressLines"]
			print(address)
		}
	}

}

class GeoSearch: NSObject, BMKGeoCodeSearchDelegate {
	
	func getAddress(location: CLLocationCoordinate2D) {
		let geoCodeSearch = BMKGeoCodeSearch.init()
		geoCodeSearch.delegate = self
		
		let option =  BMKReverseGeoCodeSearchOption()
		option.isLatestAdmin = true
		option.location = location
		
		print("GetAddress")
		print(option.location)
		let result = geoCodeSearch.reverseGeoCode(option)
		print(result)
	}
	
	public func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch, result: BMKReverseGeoCodeSearchResult, errorCode: BMKSearchErrorCode)  {
		print("onGetReverseGeoCodeResult")
		print(errorCode)
		print(result)
	}
	
//	func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch, result: BMKReverseGeoCodeSearchResult, errorCode: BMKSearchErrorCode) {
//		print("onGetReverseGeoCodeResult")
//		print(errorCode)
//		print(result)
//	}
	
	func onGetGeoCodeResult(searcher: BMKGeoCodeSearch, result: BMKReverseGeoCodeSearchResult, errorCode: BMKSearchErrorCode) {
		print("onGetGeoCodeResult")
		print(errorCode)
		print(result)
	}
}
