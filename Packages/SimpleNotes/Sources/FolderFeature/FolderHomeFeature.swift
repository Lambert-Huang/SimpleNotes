//
//  File.swift
//
//
//  Created by Anderson  on 2024/7/28.
//

import SwiftUI
import UIFeatureKit

@Reducer
public struct FolderHomeFeature {
	public init() {}

	@ObservableState
	public struct State: Equatable {
		public init() {}
	}

	public enum Action: BindableAction {
		case binding(BindingAction<State>)
		case didTapAddButton
	}

	public var body: some ReducerOf<Self> {
		BindingReducer()
		Reduce { _, action in
			switch action {
			case .binding:
				return .none
				
			case .didTapAddButton:
				return .none
			}
		}
	}
}

public struct FolderHomeView: View {
	@Perception.Bindable var store: StoreOf<FolderHomeFeature>
	public init(store: StoreOf<FolderHomeFeature>) {
		self.store = store
	}

	public var body: some View {
		WithPerceptionTracking {
			VStack(alignment: .leading, spacing: 0) {
				NavigationBar(style: .titleOnly(LocalString("Folder", bundle: .module)))
					.padding(.horizontal, 20)
				Divider()
					.padding(.top, 10)
				listView
					.padding(.horizontal, 20)
			}
			.frame(maxHeight: .infinity, alignment: .top)
		}
	}
}

private extension FolderHomeView {
	var listView: some View {
		ScrollView {
			LazyVGrid(
				columns: listGridItems(),
				spacing: 10
			) {
				Button {
					store.send(.didTapAddButton)
				} label: {
					VStack(spacing: 10) {
						Image.Plus
							.resizable()
							.renderingMode(.template)
							.frame(width: 30, height: 30)
							.foregroundStyle(.blue)
					}
					.frame(maxWidth: .infinity, minHeight: 100)
					.padding(.horizontal, 20)
					.padding(.vertical, 20)
					.background(
						RoundedRectangle(cornerRadius: 16, style: .continuous)
							.fill(Color.blue.opacity(0.2))
					)
				}
			}
			.padding(.vertical, 20)
		}
	}

	func listGridItems() -> [GridItem] {
		if UIDevice.current.isPhone {
			return [GridItem(spacing: 10), GridItem(spacing: 10)]
		} else {
			return [GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10)]
		}
	}
}

#Preview {
	FolderHomeView(
		store: Store(
			initialState: FolderHomeFeature.State(),
			reducer: { FolderHomeFeature() }
		)
	)
}
