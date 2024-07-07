//
//  File.swift
//
//
//  Created by Anderson  on 2024/7/7.
//

import Foundation
import SwiftUI
import UIFeatureKit

public struct OnboardingFeature: Identifiable, Codable, Equatable {
	public var id: UUID = .init()
	public let systemIcon: String
	public let title: String
	public let description: String

	public static let defaultFeatures: [OnboardingFeature] = [
		OnboardingFeature(systemIcon: "folder.fill", title: LocalString("Folder-based Management", bundle: .module), description: LocalString("Organize your tasks in folders for neat and structured management.", bundle: .module)),
		OnboardingFeature(systemIcon: "calendar", title: LocalString("Calendar Filtering", bundle: .module), description: LocalString("Quickly find tasks for specific dates to efficiently plan each day.", bundle: .module)),
		OnboardingFeature(systemIcon: "mic.fill", title: LocalString("Voice Entry", bundle: .module), description: LocalString("Use voice input for your tasks to free your hands and enhance entry efficiency.", bundle: .module)),
		OnboardingFeature(systemIcon: "cloud", title: LocalString("iCloud Sync", bundle: .module), description: LocalString("Sync your tasks across all devices to keep up to date anywhere, anytime.", bundle: .module))
	]
}

@Reducer
public struct Onboarding {
	public init() {}

	@ObservableState
	public struct State: Equatable {
		var features: [OnboardingFeature] = []
		var isLoading = false
		public init() {}
	}

	public enum Action {
		case didTapContinueButton
		case onTask
		case onboardingFeaturesLoaded([OnboardingFeature])
	}

	public var body: some ReducerOf<Self> {
		Reduce { state, action in
			switch action {
			case .didTapContinueButton:
				@Shared(.appStorage("didLoadOnboarding")) var didLoadOnboarding = false
				didLoadOnboarding = true
				return .none

			case .onTask:
				state.isLoading = true
				return .run { send in
					try await Task.sleep(nanoseconds: 1_500_000_000)
					await send(.onboardingFeaturesLoaded(OnboardingFeature.defaultFeatures))
				}

			case let .onboardingFeaturesLoaded(features):
				state.isLoading = false
				state.features = features
				return .none
			}
		}
	}
}

public struct OnboardingView: View {
	let store: StoreOf<Onboarding>
	public init(store: StoreOf<Onboarding>) {
		self.store = store
	}

	public var body: some View {
		Color(.systemBackground)
			.ignoresSafeArea()
			.sheet(isPresented: .constant(true)) {
				ZStack(alignment: .top) {
					VStack {
						Text(LocalString("SimpleNotes", bundle: .module))
							.font(.largeTitle)
							.fontWeight(.bold)
							.padding(.top, 56)
						WithPerceptionTracking {
							Group {
								if store.isLoading {
									ProgressView()
								} else {
									VStack(alignment: .leading, spacing: 16) {
										WithPerceptionTracking {
											ForEach(store.features) { feature in
												HStack(spacing: 20) {
													Image(systemName: feature.systemIcon)
													VStack(alignment: .leading) {
														Text(feature.title)
															.font(.headline)
															.bold()
														Text(feature.description)
															.font(.footnote)
															.foregroundStyle(.secondary)
													}
												}
												.frame(maxWidth: .infinity, alignment: .leading)
												.padding()
												.background(Color.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
											}
										}
									}
								}
							}
							.padding(.top, 56)
						}
						Spacer()
						WithPerceptionTracking {
							Button {
								store.send(.didTapContinueButton)
							} label: {
								Text(LocalString("Continue", bundle: .module))
									.font(.title3)
									.bold()
									.frame(maxWidth: .infinity)
									.frame(height: 40)
							}
							.padding(.bottom, 56)
							.buttonStyle(BorderedProminentButtonStyle())
							.disabled(store.isLoading)
						}
					}
					.padding(.horizontal, 20)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
				}
				.task {
					await store.send(.onTask).finish()
				}
				.interactiveDismissDisabled()
			}
	}
}

#Preview {
	OnboardingView(
		store: Store(
			initialState: Onboarding.State(),
			reducer: { Onboarding() }
		)
	)
}
