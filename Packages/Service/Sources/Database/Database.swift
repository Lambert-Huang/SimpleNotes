//
//  File.swift
//
//
//  Created by Anderson  on 2024/7/20.
//

import CoreData
import DependenciesAdditions
import Entity
import Foundation

public struct Database {
	public let container: () throws -> PersistentContainer
}

@MainActor
private let persistentContainer: PersistentContainer = {
	let container = PersistentContainer(name: "Todo", bundle: .todoBundle, inMemory: false).withInitialData()
	return container
}()

public extension PersistentContainer {
	@MainActor
	func withInitialData() -> Self {
		with { context in
			@Dependency(\.uuid) var uuid

			func todo(_ todo: String, in folder: Folder) -> Todo? {
				guard let entityDescription = NSEntityDescription.entity(forEntityName: "Todo", in: context) else {
					print("Failed to get Todo entity description")
					return nil
				}
				let todoEntity = Todo(entity: entityDescription, insertInto: context)
				todoEntity.id = uuid()
				todoEntity.todo_ = todo
				todoEntity.folder = folder
				todoEntity.targetDate_ = Date()
				return todoEntity
			}

			func folder(_ title: String) -> Folder? {
				guard let entityDescription = NSEntityDescription.entity(forEntityName: "Folder", in: context) else {
					print("Failed to get Folder entity description")
					return nil
				}
				let folder = Folder(entity: entityDescription, insertInto: context)
				folder.id = uuid()
				folder.title = title
				folder.hexColor = "#000000"
				return folder
			}

			// 检查是否已存在数据
			let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
			let count = try? context.count(for: fetchRequest)

			if count == 0 {
				if let defaultFolder = folder(NSLocalizedString("Default Folder", bundle: .module, comment: "")) {
					_ = todo("Buy me a Coffee!", in: defaultFolder)
					_ = todo("Wear Mask", in: defaultFolder)

					do {
						try context.save()
					} catch {
						print("Failed to save initial data: \(error)")
					}
				}
			}
		}
	}
}

extension Database: DependencyKey {
	@MainActor
	public static var liveValue = Database(
		container: { persistentContainer }
	)

	@MainActor
	public static var testValue = Database(
		container: { persistentContainer }
	)
}

public extension DependencyValues {
	var database: Database {
		get { self[Database.self] }
		set { self[Database.self] = newValue }
	}
}

public struct TodoDatabase {
	public var fetchAll: @Sendable () throws -> [Todo]
	public var fetch: @Sendable (NSPredicate) throws -> [Todo]
}

extension TodoDatabase: DependencyKey {
	public static var liveValue = TodoDatabase(
		fetchAll: {
			@Dependency(\.database.container) var container
			guard let storeUrl = try container().viewContext.persistentStoreCoordinator?.persistentStores.first?.url else {
				throw NSError(domain: "TodoDatabase", code: 2, userInfo: [NSLocalizedDescriptionKey: "Persistent store not loaded"])
			}
			let context = try container().viewContext
			guard let entityDescription = NSEntityDescription.entity(forEntityName: "Todo", in: context) else {
				throw NSError(domain: "TodoDatabase", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get entity description for Todo"])
			}
			
			let request = Todo.fetchRequest()
			request.predicate = NSPredicate(format: "TRUEPREDICATE")
			request.sortDescriptors = [
				NSSortDescriptor(keyPath: \Todo.targetDate_, ascending: false)
			]
			return try context.fetch(request)
		},
		fetch: { predicate in
			let request = NSFetchRequest<Todo>(entityName: "Todo")
			request.predicate = predicate
			request.sortDescriptors = [
				NSSortDescriptor(keyPath: \Todo.targetDate_, ascending: false)
			]
			@Dependency(\.database.container) var container
			return try container().viewContext.fetch(request)
		}
	)
}

public extension DependencyValues {
	var todoDatabase: TodoDatabase {
		get { self[TodoDatabase.self] }
		set { self[TodoDatabase.self] = newValue }
	}
}

public struct FolderDatabase {
	public var fetchAll: @Sendable () throws -> [Folder]
	public var fetch: @Sendable (NSPredicate) throws -> [Folder]
}

extension FolderDatabase: DependencyKey {
	public static var liveValue = FolderDatabase(
		fetchAll: {
			@Dependency(\.database.container) var container
			let context = try container().viewContext
			guard let entityDescription = NSEntityDescription.entity(forEntityName: "Folder", in: context) else {
				throw NSError(domain: "FolderDatabase", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to get entity description for Folder"])
			}
			let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Folder")
			request.predicate = NSPredicate(format: "TRUEPREDICATE")
			request.sortDescriptors = [
				NSSortDescriptor(keyPath: \Folder.title_, ascending: true)
			]

			@Dependency(\.logger) var logger
			let results = try context.fetch(request)
			let folders = results.compactMap { $0 as? Folder }
			logger.debug("results: \(results.count) folders: \(folders.count)")
			return folders
		},
		fetch: { predicate in
			let request = NSFetchRequest<Folder>(entityName: "Folder")
			request.predicate = predicate
			request.sortDescriptors = [
				NSSortDescriptor(keyPath: \Folder.title, ascending: true)
			]
			@Dependency(\.database.container) var container
			return try container().viewContext.fetch(request)
		}
	)
}

public extension DependencyValues {
	var folderDatabase: FolderDatabase {
		get { self[FolderDatabase.self] }
		set { self[FolderDatabase.self] = newValue }
	}
}
