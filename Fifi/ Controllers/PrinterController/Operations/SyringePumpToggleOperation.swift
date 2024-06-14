//
//  SyringePumpToggleOperation.swift
//  SyringePumpToggleOperation
//
//  Created by Elijah Cook on 9/12/21.
// See SyringePumpSettingsOperation.swift for comments on format of operations.

import SwiftUI

public struct SyringePumpToggleConfiguration: Hashable, Codable {

    var pump1Action: PumpAction = .hold
    var pump2Action: PumpAction = .hold
    
  public init() { }
}

extension PrinterOperation {
  public static func syringePumpToggleOperation<Body: View>(
    body: @escaping (Binding<SyringePumpToggleConfiguration>) -> Body
  ) -> PrinterOperation<SyringePumpToggleConfiguration, Body> {
    .init(
      kind: .syringePumpToggle,
      configuration: .init(),
      name: "Syringe Pump Toggle",
      thumbnailName: "drop.circle",
      body: body
    ) { configuration, printerController in
        switch configuration.pump1Action {
        case .start: 
            try await printerController.startPump1()
        case .stop:
            try await printerController.stopPump1()
        case .hold: break
        }
        
        switch configuration.pump2Action {
        case .start:
            try await printerController.startPump2()
        case .stop:
            try await printerController.stopPump2()
        case .hold: return
        }
    }
  }
}
