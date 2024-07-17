//
//  File.swift
//  
//
//  Created by lambert on 2024/7/16.
//

import Foundation
import CoreData

public extension Todo {
  var todo: String {
    get { todo_ ?? "" }
    set { todo_ = newValue }
  }
  
  var targetDate: Date {
    get { targetDate_ ?? Date() }
  }
  
  @objc
  var day: String {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: targetDate)
    return "\(components.year!)-\(components.month!)-\(components.day!)"
  }
  
  convenience init(todo: String, context: NSManagedObjectContext) {
    self.init(context: context)
    self.todo = todo
  }
  
  override func awakeFromInsert() {
    targetDate_ = Date()
  }
}

public struct TodoProperties {
  static let todo = "todo_"
  static let targetDate = "targetDate_"
  static let folder = "folder"
  static let isComplete = "isComplete"
}
