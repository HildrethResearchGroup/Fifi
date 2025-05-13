//
//  PumpActions.swift
//  Fifi
//
//  Created by Eli Cook on 6/4/24.
//

import Foundation

enum PumpAction: String, Codable, Hashable, CaseIterable {
    
    case start = "Start"
    case stop = "Stop"
    case hold = "Hold"
    
    public enum Error: Swift.Error {
      case unknownFunction
    }
    
    var queryString: String {
        switch self {
        case .start: return "Start"
        case .stop: return "Stop"
        case .hold: return "Hold"
        }
    }
}

#if canImport(SwiftUI)
extension PumpAction: Identifiable {
    public var id: String {
        rawValue
    }
}
#endif
