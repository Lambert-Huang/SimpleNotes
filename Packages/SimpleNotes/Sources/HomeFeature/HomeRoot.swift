//
//  File.swift
//  
//
//  Created by lambert on 2024/7/15.
//

import SwiftUI
import UIFeatureKit

@Reducer
public struct HomeRootFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case didTapSettingsButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
        case .binding:
          return .none
          
        case .didTapSettingsButton:
          return .none
      }
    }
  }
}


public struct HomeRootView: View {
  @Perception.Bindable var store: StoreOf<HomeRootFeature>
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
          }
        }
      }
    }
  }
}

private extension HomeRootView {
  var searchView: some View {
    Button {
      
    } label: {
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
      reducer: HomeRootFeature.init
    )
  )
}
