//
//  File.swift
//  
//
//  Created by Anderson  on 2024/7/7.
//

import Foundation
import SwiftUI
import UIFeatureKit

@Reducer
public struct RootTab {
	public init() {}
	
	@ObservableState
	public struct State: Equatable {
		public init() {}
	}
	public enum Action: Equatable {
		
	}
	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
				
			}
		}
	}
}

public struct RootTabView: View {
	let store: StoreOf<RootTab>
	public init(store: StoreOf<RootTab>) {
		self.store = store
	}
	public var body: some View {
		/*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
	}
}
