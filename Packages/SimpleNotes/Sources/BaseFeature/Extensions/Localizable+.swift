//
//  File.swift
//  
//
//  Created by lambert on 2024/7/6.
//

import Foundation

public func LocalString(_ key: String, bundle: Bundle, comment: String = "") -> String {
  return NSLocalizedString(key, bundle: bundle, comment: comment)
}
