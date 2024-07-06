import UIFeatureKit
import SwiftUI

@Reducer
public struct AppLogic {
	public init() {}
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

public struct AppView: View {
	let store: StoreOf<AppLogic>
	public init(store: StoreOf<AppLogic>) {
		self.store = store
	}
	public var body: some View {
    Text(LocalString("Hello, world!", bundle: .module))
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
