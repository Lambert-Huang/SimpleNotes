//
//  File.swift
//  
//
//  Created by lambert on 2024/7/15.
//


import SwiftUI
import UIFeatureKit

@Reducer
public struct CalendarFeature {
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


public struct CalendarView: View {
  @Perception.Bindable var store: StoreOf<CalendarFeature>
  public init(store: StoreOf<CalendarFeature>) {
    self.store = store
  }
  public var body: some View {
    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
  }
}
