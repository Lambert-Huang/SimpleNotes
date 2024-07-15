//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/7.
//

import Foundation
import SwiftUI
import UIFeatureKit
import HomeFeature
import CalendarFeature
import FolderFeature

public enum RootTab: Int, Equatable, Hashable, CustomStringConvertible {
  
  case home = 0
  case calendar = 1
  case folder = 2
  
  public var title: String {
    switch self {
      case .home: return LocalString("Home", bundle: .module)
      case .calendar: return LocalString("Calendar", bundle: .module)
      case .folder: return LocalString("Folder", bundle: .module)
    }
  }
  
  public var image: Image {
    switch self {
      case .home: return Image.House.renderingMode(.template)
      case .calendar: return Image.CalendarDots.renderingMode(.template)
      case .folder: return Image.Folders.renderingMode(.template)
    }
  }
  
  public var selectedImage: Image {
    switch self {
      case .home: return Image.HouseFill.renderingMode(.template)
      case .calendar: return Image.CalendarDotsFill.renderingMode(.template)
      case .folder: return Image.FolderFill.renderingMode(.template)
    }
  }
  
  public func tabItem(isSelected: Bool) -> some View {
    Label(
      title: { Text(title) },
      icon: { isSelected ? selectedImage : image }
    )
  }
  
  public var description: String {
    title
  }
}

@Reducer
public struct RootTabFeature {
  
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
    @Shared(.appStorage("selectedTab")) var selectedTab: RootTab = .home
    var home = HomeFeature.State.initialState
    var calendar = CalendarFeature.State()
    var folder = FolderFeature.State()
    public init() {}
	}
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case calendar(CalendarFeature.Action)
    case folder(FolderFeature.Action)
    case home(HomeFeature.Action)
		case onTask
	}
  @Dependency(\.device) var device
  @Dependency(\.logger) var logger
  
	public var body: some ReducerOf<Self> {
    BindingReducer()
    Scope(state: \.home, action: \.home, child: HomeFeature.init)
    Scope(state: \.calendar, action: \.calendar, child: CalendarFeature.init)
    Scope(state: \.folder, action: \.folder, child: FolderFeature.init)
		Reduce { state, action in
			switch action {
        case .binding:
          return .none
          
        case .calendar:
          return .none
          
        case .folder:
          return .none
          
        case .home:
          return .none
        case .onTask:
          return .run { [selectedTab = state.selectedTab] _ in
            logger.log("Load Tab \(selectedTab.description)")
          }
			}
		}
	}
}

public struct RootTabView: View {
  @Perception.Bindable var store: StoreOf<RootTabFeature>
	public init(store: StoreOf<RootTabFeature>) {
		self.store = store
	}
	public var body: some View {
    WithPerceptionTracking {
      TabView(selection: $store.selectedTab) {
        HomeView(
          store: store.scope(
            state: \.home,
            action: \.home
          )
        )
        .tabItem { RootTab.home.tabItem(isSelected: store.selectedTab == .home) }
        .tag(RootTab.home)
        
        CalendarView(
          store: store.scope(
            state: \.calendar,
            action: \.calendar
          )
        )
        .tabItem { RootTab.calendar.tabItem(isSelected: store.selectedTab == .calendar) }
        .tag(RootTab.calendar)
        
        FolderView(
          store: store.scope(
            state: \.folder,
            action: \.folder
          )
        )
        .tabItem { RootTab.folder.tabItem(isSelected: store.selectedTab == .folder) }
        .tag(RootTab.folder)
      }
      .tint(.primary)
    }
	}
}

#Preview {
  RootTabView(
    store: Store(
      initialState: RootTabFeature.State(),
      reducer: RootTabFeature.init
    )
  )
}
