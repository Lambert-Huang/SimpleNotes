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
	let container = PersistentContainer(name: "Todo", bundle: .todoBundle, inMemory: true).withInitialData()
	return container
}()

public let testPersistentContainer: PersistentContainer = .testValue

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
//				todoEntity.folder = folder
				todoEntity.targetDate_ = .now
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
		container: { testPersistentContainer }
	)
}

public extension DependencyValues {
	var database: Database {
		get { self[Database.self] }
		set { self[Database.self] = newValue }
	}
}

public struct TodoDatabase {
	public var fetch: @Sendable (_ predicate: NSPredicate?, _ sortedBy: [NSSortDescriptor]) throws -> [Todo]
}

extension TodoDatabase: DependencyKey {
	public static var liveValue = TodoDatabase(
		fetch: {
			predicate,
			sortedBy in
			@Dependency(\.database.container) var container
			let context = try container().viewContext
			return try Todo.fetch(
				matching: predicate,
				sortedBy: sortedBy,
				in: context
			)
		}
	)
	public static var testValue = TodoDatabase(
		fetch: { _, _ in
			let context = testPersistentContainer.viewContext
			let folder = Folder(id: UUID(1000), title: "默认的", hexColor: "#000000", context: context)
			return [
				Todo(id: UUID(0), todo: "Like the Wind", folder: folder, in: context),
				Todo(id: UUID(1), todo: "啊", folder: folder, in: context),
			]
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
	public var fetch: @Sendable (_ predicate: NSPredicate?) throws -> [Folder]
}

extension FolderDatabase: DependencyKey {
	public static var liveValue = FolderDatabase(
		fetch: {
			predicate in
			@Dependency(\.database.container) var container
			let context = try container().viewContext
			return try Folder.fetch(
				matching: predicate,
				sortedBy: Folder.defaultSortDescriptors(),
				in: context
			)
		}
	)
}

public extension DependencyValues {
	var folderDatabase: FolderDatabase {
		get { self[FolderDatabase.self] }
		set { self[FolderDatabase.self] = newValue }
	}
}
