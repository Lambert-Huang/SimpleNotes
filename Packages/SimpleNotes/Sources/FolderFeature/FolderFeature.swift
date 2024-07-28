//
//  File.swift
//  
//
//  Created by lambert on 2024/7/15.
//

import SwiftUI
import UIFeatureKit

@Reducer
public struct FolderFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
		public static let intialState = Self(
			routes: [.root(
				.folderHome(FolderHomeFeature.State()),
				embedInNavigationView: true
			)]
		)
		var routes: [Route<FolderScreen.State>]
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
		case router(IndexedRouterActionOf<FolderScreen>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
			guard case .folderHome = state.routes.first?.screen else {
				return .none
			}
      switch action {
        case .binding:
          return .none
			case .router(.routeAction(id: _, action: .folderHome(.didTapAddButton))):
				state.routes.presentCover(.folderCreate(FolderCreateFeature.State()), embedInNavigationView: false)
				return .none
				case .router:
					return .none
      }
    }
		.forEachRoute(\.routes, action: \.router)
  }
}

@Reducer(state: .equatable)
public enum FolderScreen {
	case folderHome(FolderHomeFeature)
	case folderCreate(FolderCreateFeature)
	case folderDetail(FolderDetailFeature)
}


public struct FolderRootView: View {
  @Perception.Bindable var store: StoreOf<FolderFeature>
  public init(store: StoreOf<FolderFeature>) {
    self.store = store
  }
  public var body: some View {
		WithPerceptionTracking {
			TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
				switch screen.case {
				case let .folderHome(store):
					FolderHomeView(store: store)
				case let .folderCreate(store):
					FolderCreateView(store: store)
				case let .folderDetail(store):
					FolderDetailView(store: store)
				}
			}
		}
  }
}
