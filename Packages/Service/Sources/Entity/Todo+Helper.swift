//
//  File.swift
//
//
//  Created by lambert on 2024/7/16.
//

import CoreData
import Foundation

public extension Todo {
	var id: UUID {
		get { id_ ?? UUID() }
		set { id_ = newValue }
	}

	var todo: String {
		get { todo_ ?? "" }
		set { todo_ = newValue }
	}

	var targetDate: Date { targetDate_ ?? Date() }

	@objc
	var day: String {
		let components = Calendar.current.dateComponents([.year, .month, .day], from: targetDate)
		return "\(components.year!)-\(components.month!)-\(components.day!)"
	}

	convenience init(id: UUID, todo: String, context: NSManagedObjectContext) {
		self.init(context: context)
		self.id_ = id
		self.todo = todo
	}

	override func awakeFromInsert() {
		targetDate_ = Date()
	}
}

public enum TodoProperties {
	static let todo = "todo_"
	static let targetDate = "targetDate_"
	static let folder = "folder"
	static let isComplete = "isComplete"
}

public extension Todo {
	static func predicate(sameDayAs date: Date, hideComplete: Bool) -> NSPredicate {
		let calendar = Calendar.autoupdatingCurrent
		let startOfDay = calendar.startOfDay(for: date)
		let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
		return NSPredicate(format: "targetDate_ >= %@ AND targetDate_ < %@", startOfDay as NSDate, endOfDay as NSDate)
	}
}
