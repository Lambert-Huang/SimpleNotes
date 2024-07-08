//
//  File.swift
//  
//
//  Created by lambert on 2024/7/6.
//

import Foundation
import SwiftDate
import ComposableArchitecture

#if os(iOS)
import UIKit

public class AppDelegate: NSObject, UIApplicationDelegate {
  public let store = Store(
    initialState: AppLogic.State(),
    reducer: {
			AppLogic()._printChanges()
    }
  )
  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    setupDateRegion()
    return true
  }
}
#elseif os(macOS)
import AppKit
public class AppDelegate: NSObject, NSApplicationDelegate {
  public let store = Store(
    initialState: AppLogic.State(),
    reducer: {
      AppLogic()
    }
  )
  public func applicationDidFinishLaunching(_ notification: Notification) {
    setupDateRegion()
  }
}

#endif

private extension AppDelegate {
  func setupDateRegion() {
    SwiftDate.defaultRegion = .local
  }
}
