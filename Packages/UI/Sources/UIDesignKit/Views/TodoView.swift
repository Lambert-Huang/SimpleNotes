//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/20.
//

import Entity
import SwiftUI
import DesignKit

public struct TodoView: View {
	
	@ObservedObject private var todo: Todo
	private var checkTapped: (Todo) -> Void
	private var onTapped: (Todo) -> Void
	
	public init(
		todo: Todo,
		checkTapped: @escaping (Todo) -> Void,
		onTapped: @escaping (Todo) -> Void
	) {
		self.todo = todo
		self.checkTapped = checkTapped
		self.onTapped = onTapped
	}
	
	public var body: some View {
		HStack {
			VStack(alignment: .leading) {
				HStack(spacing: 3) {
					Image.FolderFill
						.resizable()
						.renderingMode(.template)
						.aspectRatio(contentMode: .fit)
						.frame(width: 20, height: 20)
						.foregroundStyle(Color(hexOrGray: todo.folder?.hexColor))
					
					if let title = todo.folder?.title {
						Text(title)
							.font(.callout)
							.foregroundStyle(Color(hexOrGray: todo.folder?.hexColor))
					} else {
						Text("None", bundle: .module)
							.font(.callout)
							.foregroundStyle(Color(hexOrGray: todo.folder?.hexColor))
					}
				}
				
				Text(todo.todo)
					.font(.body)
					.foregroundStyle((todo.isComplete) ? .secondary : .primary)
				
				Text("\(todo.targetDate.formatted(date: .complete, time: .omitted))")
					.font(.caption)
					.foregroundStyle(.secondary)
			}
			
			Spacer()
			
			Button {
				withAnimation {
					checkTapped(todo)
				}
			} label: {
				let image = todo.isComplete ? Image.CheckCircleFill : Image.Circle
				image
					.resizable()
					.renderingMode(.template)
					.frame(width: 30, height: 30)
					.foregroundStyle(.foreground)
			}
		}
		.padding()
		.background(
			RoundedRectangle(cornerRadius: 16)
				.foregroundStyle(Color.secondarySystemBackground)
		)
		.onTapGesture {
			onTapped(todo)
		}
	}
}
