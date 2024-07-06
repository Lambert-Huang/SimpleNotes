//
//  AppApp.swift
//  App
//
//  Created by Anderson  on 2024/3/26.
//

import SwiftUI
import ComposableArchitecture
import AppFeature

final class AppDelegate: NSObject, UIApplicationDelegate {

	static let shared = AppDelegate()
	let store = Store(
		initialState: AppLogic.State(),
		reducer: {
			AppLogic()
		}
	)

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
	) -> Bool {
		return true
	}

	func application(
		_ application: UIApplication,
		didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
	) {

	}

	func application(
		_ application: UIApplication,
		didFailToRegisterForRemoteNotificationsWithError error: Error
	) {
		
	}

	func application(
		_ app: UIApplication,
		open url: URL,
		options: [UIApplication.OpenURLOptionsKey: Any] = [:]
	) -> Bool {
		return true
	}
}

@main
struct SimpleNotesApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
	var body: some Scene {
		WindowGroup {
			AppView(
				store: appDelegate.store
			)
		}
	}
}
