//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/20.
//

import SwiftUI
import Lottie


public enum EmptyViewState {
	case emptyFolder
	case emptyFolderWithCreateDescription
	case emptyTodo
	case emptyTodoForToday
	
	public var title: String {
		switch self {
		case .emptyFolder:
			return NSLocalizedString("Empty", bundle: .module, comment: "")
		case .emptyFolderWithCreateDescription:
			return NSLocalizedString("There is no folder", bundle: .module, comment: "")
		case .emptyTodo:
			return NSLocalizedString("Empty", bundle: .module, comment: "")
		case .emptyTodoForToday:
			return NSLocalizedString("Empty", bundle: .module, comment: "")
		}
	}
	
	public var subTitle: String {
		switch self {
		case .emptyFolder:
			return NSLocalizedString("There is no folder", bundle: .module, comment: "")
			
		case .emptyFolderWithCreateDescription:
			return NSLocalizedString("You can create folders in the folder tab", bundle: .module, comment: "")
			
		case .emptyTodo:
			return NSLocalizedString("There is nothing todo", bundle: .module, comment: "")
			
		case .emptyTodoForToday:
			return NSLocalizedString("There are no todos for today", bundle: .module, comment: "")
		}
	}
}

public struct BoxEmptyView: View {
	public let state: EmptyViewState
	public init(state: EmptyViewState) {
		self.state = state
	}
	public var body: some View {
		VStack {
			LottieView(animation: .named("empty-box", bundle: .module))
				.playing(loopMode: .playOnce)
				.frame(maxHeight: 250)
			
			Text(state.title)
				.font(.headline)
				.foregroundStyle(.foreground)
			
			Text(state.subTitle)
				.font(.callout)
				.foregroundStyle(.gray)
				.padding(.bottom, 40)
		}
	}
}
