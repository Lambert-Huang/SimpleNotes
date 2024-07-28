//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/28.
//

import Foundation
import CoreData

public protocol ManagedEntity: NSManagedObject {
	static var entityName: String { get }
}

public extension ManagedEntity {
	static var entityName: String {
		String(describing: self)
	}
}

public extension ManagedEntity {
	static func fetch<Entity: ManagedEntity>(
		matching predicate: NSPredicate?,
		sortedBy sortDescriptors: [NSSortDescriptor] = [],
		in context: NSManagedObjectContext
	) throws -> [Entity] {
		let request = NSFetchRequest<Entity>(entityName: Entity.entityName)
		request.predicate = predicate
		request.sortDescriptors = sortDescriptors
		return try context.fetch(request)
	}
}

extension Todo: ManagedEntity {}
extension Folder: ManagedEntity {
	public var todoCount: Int {
		todos?.count ?? 0
	}
}
