//
//  GxError.swift
//  flutter_baidumap
//
//  Created by GXHC on 2019/5/10.
//

import Foundation

public struct GxError: Error {
	var errorCode: Int = -1
	var _desc: String = ""
	
	var description: String {
		return _desc
	}
	
	init(_ errorCode: Int, desc: String) {
		self.errorCode = errorCode
		self._desc = desc
	}
}
