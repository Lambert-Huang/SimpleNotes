//
//  File.swift
//  
//
//  Created by lambert on 2024/7/15.
//

import Foundation

extension HomeScreen.State: Identifiable {
  public var id: ID {
    switch self {
      case .homeRoot: return ID.homeRoot
      case .search: return ID.search
      case .settings: return ID.settings
    }
  }

  public enum ID: Identifiable {
    case homeRoot
    case search
    case settings

    public var id: ID { self }
  }
}
