//
//  File.swift
//
//
//  Created by lambert on 2024/7/15.
//

import Database
import Entity
import SwiftUI
import UIDesignKit
import UIFeatureKit

@Reducer
public struct HomeRootFeature {
	public init() {}
	
	@Dependency(\.todoDatabase) var todoDatabase
  
	@ObservableState
	public struct State: Equatable {
		var todos: [Todo] = []
		public init() {}
	}
  
	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		case checkTodo(Todo)
		case didFetchedTodos([Todo])
		case didTapSettingsButton
		case onTask
		case tapTodo(Todo)
	}
  
	public var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { state, action in
			switch action {
				case .binding:
					return .none
				
				case let .checkTodo(todo):
					let originalState = todo.isComplete
					todo.isComplete.toggle()
					return .run { _ in
						try todo.managedObjectContext?.save()
					} catch: { _, _ in
						todo.isComplete = originalState
					}
				
				case let .didFetchedTodos(todos):
					state.todos = todos
					return .none
				
				case .didTapSettingsButton:
					return .none
				
				case .onTask:
				return .run { send in
					await send(.didFetchedTodos(try todoDatabase.fetchAll()))
				}
				
				case .tapTodo:
					return .none
			}
		}
	}
}

public struct HomeRootView: View {
	var store: StoreOf<HomeRootFeature>
	public init(store: StoreOf<HomeRootFeature>) {
		self.store = store
	}

	public var body: some View {
		WithPerceptionTracking {
			ZStack {
				VStack(spacing: 0) {
					NavigationBar(style: .titleWithButton(LocalString("Home", bundle: .module), .GearFill)) {
						store.send(.didTapSettingsButton)
					}
					.padding(.horizontal, 20)
					Divider()
						.padding(.top, 10)
          
					ScrollView {
						searchView
							.padding(20)
						todayTodoListView(store.todos)
							.padding(.horizontal, 20)
//						FetchRequestWrapperView(sameDayAs: .now, hideCompleteTodo: false) { todos in
//							todayTodoListView(todos)
//								.padding(.horizontal, 20)
//						}
					}
				}
			}
			.task {
				await store.send(.onTask).finish()
			}
		}
	}
}

private extension HomeRootView {
	func todayTodoListView(_ todos: [Todo]) -> some View {
		LazyVStack {
			Text("Today's todos", bundle: .module)
				.font(.headline)
				.frame(maxWidth: .infinity, alignment: .leading)
			if todos.isEmpty {
				BoxEmptyView(state: .emptyTodoForToday)
			} else {
				ForEach(todos) { todo in
					TodoView(
						todo: todo,
						checkTapped: { store.send(.checkTodo($0)) },
						onTapped: { store.send(.tapTodo($0)) }
					)
					.id(todo.objectID)
				}
			}
		}
	}
	
	var searchView: some View {
		Button {} label: {
			HStack {
				Image.MagnifyingGlass
					.resizable()
					.renderingMode(.template)
					.foregroundStyle(.foreground)
					.frame(width: 25, height: 25)
        
				Text(LocalString("Please enter a search term", bundle: .module))
					.font(.body)
					.foregroundStyle(.gray)
        
				Spacer()
			}
		}
		.padding()
		.frame(maxWidth: .infinity)
		.background(
			RoundedRectangle(cornerRadius: 16)
				.fill(Color.secondarySystemBackground)
		)
	}
}

#Preview {
	HomeRootView(
		store: Store(
			initialState: HomeRootFeature.State(),
			reducer: HomeRootFeature.init,
			withDependencies: {
				$0.database = .testValue
			}
		)
	)
}
