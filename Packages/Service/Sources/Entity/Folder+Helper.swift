//
//  File.swift
//  
//
//  Created by lambert on 2024/7/16.
//

import Foundation
import CoreData

public extension Folder {
	var id: UUID {
		get { id_ ?? UUID() }
		set { id_ = newValue }
	}
  var title: String {
    get { title_ ?? "" }
    set { title_ = newValue }
  }
  
  var hexColor: String {
		get { hexColor_ ?? "#000000" }
    set { hexColor_ = newValue }
  }
  
	convenience init(id: UUID, title: String, hexColor: String, context: NSManagedObjectContext) {
		self.init(context: context)
		self.id_ = id
		self.title = title
		self.hexColor = hexColor
	}
	
  override func awakeFromInsert() {
    
  }
}
