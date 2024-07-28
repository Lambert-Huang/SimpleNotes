//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/28.
//

import UIKit

public extension UIDevice {
	
	var isPhone: Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
	
	var isPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	
	var isMac: Bool {
		return UIDevice.current.userInterfaceIdiom == .mac
	}
	
}
