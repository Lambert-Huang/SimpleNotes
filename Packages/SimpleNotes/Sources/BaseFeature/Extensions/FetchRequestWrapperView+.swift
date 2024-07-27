//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/27.
//

import UIDesignKit
import Entity
import SwiftUI
import CoreData

extension FetchRequestWrapperView where Entity == Todo {
	public init(
		sameDayAs date: Date,
		hideCompleteTodo: Bool,
		@ViewBuilder content: @escaping ([Todo]) -> Content
	) {
		let predicate = Todo.predicate(sameDayAs: date, hideComplete: hideCompleteTodo)
		self.init(sortDescriptors: [], predicate: predicate, content: content)
	}
}
