//
//  File.swift
//  
//
//  Created by lambert on 2024/7/16.
//

import Foundation
import CoreData

public extension Folder {
  var title: String {
    get { title_ ?? "" }
    set { title_ = newValue }
  }
  
  var hexColor: String {
    get { hexColor_ ?? "#000000" }
    set { hexColor_ = newValue }
  }
  
  public override func awakeFromInsert() {
    
  }
}
