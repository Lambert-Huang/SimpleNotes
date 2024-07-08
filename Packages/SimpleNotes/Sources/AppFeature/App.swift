import UIFeatureKit
import OnboardingFeature
import RootTabFeature
import SwiftUI
import Combine

@Reducer
public struct AppLogic {
	public init() {
		
	}
	@ObservableState
	public struct State: Equatable {
		var view: View.State
		@Shared(.appStorage("didLoadOnboarding")) var didLoadOnboarding = false
		public init() {
			view = _didLoadOnboarding.wrappedValue ? .rootTab(RootTab.State()) : .onboarding(Onboarding.State())
		}
	}
	public enum Action {
		case didChangeOnboardingState(Bool)
		case onTask
		case view(View.Action)
	}
	public var body: some ReducerOf<Self> {
		Scope(state: \.view.onboarding, action: \.view.onboarding) {
			Onboarding()
		}
		Scope(state: \.view.rootTab, action: \.view.rootTab) {
			RootTab()
		}
		Reduce { state, action in
			switch action {
			case let .didChangeOnboardingState(didLoad):
				state.view = didLoad ? .rootTab(RootTab.State()) : .onboarding(Onboarding.State())
				return .none
			case .onTask:
				return .publisher {
					state.$didLoadOnboarding.publisher
						.map(Action.didChangeOnboardingState)
				}
			case .view:
				return .none
			}
		}
	}
	
	@Reducer
	public struct View {
		public enum State: Equatable {
			case onboarding(Onboarding.State = .init())
			case rootTab(RootTab.State = .init())
		}

		public enum Action {
			case onboarding(Onboarding.Action)
			case rootTab(RootTab.Action)
		}

		public var body: some Reducer<State, Action> {
			Scope(state: \.onboarding, action: \.onboarding, child: Onboarding.init)
			Scope(state: \.rootTab, action: \.rootTab, child: RootTab.init)
		}
	}
}

public struct AppView: View {
	let store: StoreOf<AppLogic>
	public init(store: StoreOf<AppLogic>) {
		self.store = store
	}
	public var body: some View {
		SwitchStore(store.scope(state: \.view, action: \.view)) { initialState in
			switch initialState {
			case .onboarding:
				CaseLet(
					/AppLogic.View.State.onboarding,
					 action: AppLogic.View.Action.onboarding,
					 then: OnboardingView.init(store:)
				)
			case .rootTab:
				CaseLet(
					/AppLogic.View.State.rootTab,
					 action: AppLogic.View.Action.rootTab,
					 then: RootTabView.init(store:)
				)
			}
		}
		.task {
			await store.send(.onTask).finish()
		}
			
	}
}

#Preview {
  AppView(
    store: Store(
      initialState: AppLogic.State(),
      reducer: { AppLogic() }
    )
  )
}
