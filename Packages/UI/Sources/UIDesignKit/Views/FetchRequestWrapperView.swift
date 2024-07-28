//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/27.
//

import SwiftUI
import CoreData
import Entity

public struct FetchRequestWrapperView<Entity: ManagedEntity, Content: View>: View {
	@FetchRequest var fetchRequest: FetchedResults<Entity>
	public let content: ([Entity]) -> Content
	public init(
		sortDescriptors: [NSSortDescriptor] = [],
		predicate: NSPredicate? = nil,
		@ViewBuilder content: @escaping ([Entity]) -> Content
	) {
		self._fetchRequest = FetchRequest<Entity>(sortDescriptors: sortDescriptors, predicate: predicate, animation: .default)
		self.content = content
	}
	public var body: some View {
		content(Array(fetchRequest))
	}
}
