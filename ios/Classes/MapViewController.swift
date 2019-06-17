//
//  ViewController.swift
//  BMap
//
//  Created by GXHC on 2019/5/6.
//  Copyright © 2019 GXHC. All rights reserved.
//

import UIKit

public class MapViewController: UIViewController {

	var _mapView: BMKMapView?
	
	public var navParamsDelegate: NavParamsDelegate?

	override public func viewDidLoad() {
		super.viewDidLoad()

		self.navigationItem.title = "Map"
		
		let leftButtonItem = UIBarButtonItem.init(
			title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(onCancel)
		)
		self.navigationItem.leftBarButtonItem = leftButtonItem
		
		let rightButtonItem = UIBarButtonItem.init(title: "确定", style: UIBarButtonItem.Style.done, target: self, action: #selector(onComplete))
		self.navigationItem.rightBarButtonItem = rightButtonItem
		
		// Do any additional setup after loading the view.
		_mapView = BMKMapView(frame: CGRect(x: 0, y: 0,
											width: self.view.frame.width,
											height: self.view.frame.height))
		_mapView?.mapType = BMKMapType.standard
		// _mapView?.overlooking = 0
		_mapView?.isOverlookEnabled = false;
		_mapView?.isRotateEnabled = false
		self.view.addSubview(_mapView!)

		self.addZoomControl()
		
		let btnCancel = UIButton(frame: CGRect(x: 10, y: 40, width: 60, height: 32))
		btnCancel.setTitle("Cancel", for: UIControl.State.normal)
		btnCancel.backgroundColor = UIColor.lightGray
		btnCancel.addTarget(self, action: #selector(onCancel), for: UIControl.Event.touchDown)
		self.view.addSubview(btnCancel)

	}

	override public func viewDidAppear(_ animated: Bool) {

		//地图中心点坐标
		let center = CLLocationCoordinate2D(latitude: 31.245087, longitude: 121.506656)
		//设置地图的显示范围（越小越精确）
		let span = BMKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
		//设置地图最终显示区域
		let region = BMKCoordinateRegion(center: center, span: span)
		_mapView?.region = region


		self.addMapMarker(coord: CLLocationCoordinate2D(latitude: 31.254, longitude: 121.5126), title: "这里有只野生皮卡丘")
	}

	@objc func onComplete() {
		let point = _mapView?.getMapStatus()?.targetGeoPt
		print(point as Any)

		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func onCancel() {
		print("MapView dismiss.")
		let point = _mapView?.getMapStatus()?.targetGeoPt
		let data = [
			"longitude": point?.longitude,
			"latitude": point?.latitude
		]
		print(data)
		self.navParamsDelegate?.result(data: data)
		
		self.dismiss(animated: true, completion: nil)
	}

	// 添加一个标记点(PointAnnotation）
	func addMapMarker(coord: CLLocationCoordinate2D, title: String) {
		let annotation =  BMKPointAnnotation()
		annotation.coordinate = coord
		annotation.title = title
		_mapView!.addAnnotation(annotation)
	}

	func addZoomControl() {
		let zoomCtrlWidth = CGFloat(38.0)
		let contrlView = UIView()
		// frame: CGRect(x: 0, y: 200, width: 60, height: 120)
		contrlView.backgroundColor = UIColor.white
		contrlView.layer.cornerRadius = 5
		contrlView.layer.borderColor = UIColor.lightGray.cgColor
		contrlView.layer.borderWidth = 0.5
		self._mapView?.addSubview(contrlView)
		contrlView.translatesAutoresizingMaskIntoConstraints = false

		let widthConstraint = NSLayoutConstraint(item: contrlView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: zoomCtrlWidth)
		let heightConstraint = NSLayoutConstraint(item: contrlView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: zoomCtrlWidth * 2)

		let rightConstraint = NSLayoutConstraint(item: contrlView, attribute: .right
			, relatedBy: .equal, toItem: contrlView.superview, attribute: .right, multiplier: 1.0, constant: -20)
		let bottomConstraint = NSLayoutConstraint(item: contrlView, attribute: .bottom, relatedBy: .equal, toItem: contrlView.superview, attribute: .bottom, multiplier:1.0, constant: -30)

		contrlView.addConstraints([widthConstraint, heightConstraint])
		contrlView.superview?.addConstraints([ rightConstraint, bottomConstraint ])

		let textColor = UIColor.gray // UIColor(red: 33, green: 33, blue: 33, alpha: 1)
		let btnZoomIn = UIButton(frame: CGRect(x: 0, y: 0, width: zoomCtrlWidth, height: zoomCtrlWidth))
		btnZoomIn.setTitle("+", for: UIControl.State.normal)
		btnZoomIn.setTitleColor(textColor, for: UIControl.State.normal)
		btnZoomIn.addTarget(self, action: #selector(zoomIn), for: UIControl.Event.touchUpInside)

		let btnZoomOut = UIButton(frame: CGRect(x: 0, y: zoomCtrlWidth, width: zoomCtrlWidth, height: zoomCtrlWidth))
		btnZoomOut.setTitle("-", for: UIControl.State.normal)
		btnZoomOut.setTitleColor(textColor, for: UIControl.State.normal)
		btnZoomOut.addTarget(self, action: #selector(zoomOut), for: UIControl.Event.touchUpInside)

		contrlView.addSubview(btnZoomIn)
		contrlView.addSubview(btnZoomOut)
	}

	@objc func zoomIn() {
		let level = self._mapView?.zoomLevel
		self._mapView?.zoomLevel = level! + 1
	}

	@objc func zoomOut() {
		let level = self._mapView?.zoomLevel
		self._mapView?.zoomLevel = level! - 1
	}

}

