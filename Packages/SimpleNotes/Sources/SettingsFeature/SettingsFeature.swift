//
//  File.swift
//  
//
//  Created by lambert on 2024/7/15.
//

import SwiftUI
import UIFeatureKit

@Reducer
public struct SettingsFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding:
          return .none
      }
    }
  }
}


public struct SettingsView: View {
  @Perception.Bindable var store: StoreOf<SettingsFeature>
  public init(store: StoreOf<SettingsFeature>) {
    self.store = store
  }
  public var body: some View {
    List {
      Text("1")
      Text("2")
    }
  }
}
