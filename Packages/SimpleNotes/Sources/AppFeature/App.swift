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
    public static let initialState = State(
      onboarding: OnboardingFeature.State(),
      rootTab: RootTabFeature.State()
    )
    var onboarding: OnboardingFeature.State
    var rootTab: RootTabFeature.State
    @Shared(.appStorage("didLoadOnboarding")) var didLoadOnboarding = false
	}
	public enum Action {
		case onTask
    case onboarding(OnboardingFeature.Action)
    case rootTab(RootTabFeature.Action)
	}
	public var body: some ReducerOf<Self> {
		Scope(state: \.onboarding, action: \.onboarding) {
      OnboardingFeature()
		}
		Scope(state: \.rootTab, action: \.rootTab) {
      RootTabFeature()
		}
		Reduce { state, action in
			switch action {
        case .onboarding:
          return .none
        case .rootTab:
          return .none
			case .onTask:
				return .none
			}
		}
	}
}

public struct AppView: View {
	let store: StoreOf<AppLogic>
	public init(store: StoreOf<AppLogic>) {
		self.store = store
	}
	public var body: some View {
    WithPerceptionTracking {
      Group {
        if store.didLoadOnboarding {
          RootTabView(
            store: store.scope(
              state: \.rootTab,
              action: \.rootTab
            )
          )
        } else {
          OnboardingView(
            store: store.scope(
              state: \.onboarding,
              action: \.onboarding
            )
          )
        }
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
      initialState: AppLogic.State(onboarding: OnboardingFeature.State(), rootTab: RootTabFeature.State()),
      reducer: { AppLogic() }
    )
  )
}
