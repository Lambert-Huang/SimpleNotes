//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/7.
//

import SwiftUI
import UIFeatureKit
import SearchFeature
import SettingsFeature

@Reducer
public struct HomeFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public static let initialState = Self(routes: [.root(.homeRoot(HomeRootFeature.State()), embedInNavigationView: true)])
    var search = SearchFeature.State()
    var settings = SettingsFeature.State()
    var routes: [Route<HomeScreen.State>]
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case router(IndexedRouterActionOf<HomeScreen>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      guard case let .homeRoot(homeRoot) = state.routes.first?.screen else {
        return .none
      }
      switch action {
        case .binding:
          return .none
        case .router(.routeAction(id: _, action: .homeRoot(.didTapSettingsButton))):
          state.routes.presentSheet(.settings(SettingsFeature.State()), embedInNavigationView: true)
          return .none
        default: break
          
      }
      return .none
    }
    .forEachRoute(\.routes, action: \.router)
  }
}

@Reducer(state: .equatable)
public enum HomeScreen {
  case homeRoot(HomeRootFeature)
  case search(SearchFeature)
  case settings(SettingsFeature)
}

public struct HomeView: View {
  @Perception.Bindable var store: StoreOf<HomeFeature>
  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  public var body: some View {
    WithPerceptionTracking {
      TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
        switch screen.case {
          case let .homeRoot(store):
            HomeRootView(store: store)
          case let .search(store):
            SearchView(store: store)
          case let .settings(store):
            SettingsView(store: store)
        }
      }
    }
  }
}
