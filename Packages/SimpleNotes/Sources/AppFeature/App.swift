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
			view = _didLoadOnboarding.wrappedValue ? .rootTab(RootTabFeature.State()) : .onboarding(OnboardingFeature.State())
		}
	}
	public enum Action {
		case didChangeOnboardingState(Bool)
		case onTask
		case view(View.Action)
	}
	public var body: some ReducerOf<Self> {
		Scope(state: \.view.onboarding, action: \.view.onboarding) {
      OnboardingFeature()
		}
		Scope(state: \.view.rootTab, action: \.view.rootTab) {
      RootTabFeature()
		}
		Reduce { state, action in
			switch action {
			case let .didChangeOnboardingState(didLoad):
				state.view = didLoad ? .rootTab(RootTabFeature.State()) : .onboarding(OnboardingFeature.State())
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
			case onboarding(OnboardingFeature.State = .init())
			case rootTab(RootTabFeature.State = .init())
		}

		public enum Action {
			case onboarding(OnboardingFeature.Action)
			case rootTab(RootTabFeature.Action)
		}

		public var body: some Reducer<State, Action> {
			Scope(state: \.onboarding, action: \.onboarding, child: OnboardingFeature.init)
			Scope(state: \.rootTab, action: \.rootTab, child: RootTabFeature.init)
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
