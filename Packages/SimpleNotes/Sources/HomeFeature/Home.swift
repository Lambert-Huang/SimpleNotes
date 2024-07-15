//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/7.
//

import SwiftUI
import UIFeatureKit
import SearchFeature

@Reducer
public struct HomeFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
    public var path = StackState<Path.State>()
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case path(StackActionOf<Path>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding:
          return .none
          
        case .path:
          return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
  
  @Reducer(state: .equatable)
  public enum Path {
    case search(SearchFeature)
  }
}


public struct HomeView: View {
  @Perception.Bindable var store: StoreOf<HomeFeature>
  public init(store: StoreOf<HomeFeature>) {
    self.store = store
  }
  public var body: some View {
    WithPerceptionTracking {
      Text("Hello World")
    }
  }
}
