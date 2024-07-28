//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/28.
//

import UIFeatureKit
import SwiftUI

@Reducer
public struct FolderDetailFeature {
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

public struct FolderDetailView: View {
	@Perception.Bindable var store: StoreOf<FolderDetailFeature>
	public init(store: StoreOf<FolderDetailFeature>) {
		self.store = store
	}
	public var body: some View {
		WithPerceptionTracking {
			
		}
	}
}
