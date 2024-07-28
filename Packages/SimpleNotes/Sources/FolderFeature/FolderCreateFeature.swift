//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/28.
//

import UIFeatureKit
import SwiftUI

@Reducer
public struct FolderCreateFeature {
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

public struct FolderCreateView: View {
	@Perception.Bindable var store: StoreOf<FolderCreateFeature>
	public init(store: StoreOf<FolderCreateFeature>) {
		self.store = store
	}
	public var body: some View {
		WithPerceptionTracking {
			
		}
	}
}
