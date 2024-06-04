//
//  File.swift
//
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import SwiftUI

public struct SyringePumpSettingsConfiguration: Hashable, Codable {
    // TODO: Add ON State
//for each separate pump
  public var flowRate1: Double?
  public var units1: String?
  public var flowRate2: Double?
  public var units2: String?
  public var id1: Double?
  public var id2: Double?

    
  
  
  public init() { }
}

extension PrinterOperation {
    public static func syringePumpSettingsOperation<Body: View>(
        body: @escaping (Binding<SyringePumpSettingsConfiguration>) -> Body
    ) -> PrinterOperation<SyringePumpSettingsConfiguration, Body> {
        .init(
            //settings below are for the dropdown menu when adding operations
            kind: .syringePumpSettings,
            configuration: .init(),
            name: "Syringe Pump Settings",
            thumbnailName: "syringe.fill", body: body) {configuration, printerController in
                    if let flowRate1 = configuration.flowRate1, let units1 = configuration.units1 {
                        try await printerController.setFlowRate1(to: flowRate1, of: units1)
                    }
                    
                    if let flowRate2 = configuration.flowRate2, let units2 = configuration.units2 {
                        try await printerController.setFlowRate2(to: flowRate2, of: units2)
                    }
                    
                    if let id1 = configuration.id1 {
                        try await printerController.setInnerDiameter1(to: id1)
                    }
                    
                    if let id2 = configuration.id2 {
                        try await printerController.setInnerDiameter2(to: id2)
                    }
                }
            }
    }
    
          
          
//        if let flowRate1 = configuration.flowRate1 {
//          try await printerController.setFlowRate1(to: flowRate1) //these call a function that calls another function in SyringePumpController
//        }
//
//        if let flowRate2 = configuration.flowRate2 {
//          try await printerController.setAmplifiedVoltage(to: flowRate2)
//        }
    


//// MARK: Running
//extension WaveformSettingsConfiguration: PrinterOperationConfiguration {
//  func run(printerController: PrinterController) async throws {
//    if let frequency = frequency {
//      try await printerController.setFrequency(to: frequency)
//    }
//
//    if let amplitude = amplitude {
//      try await printerController.setVoltage(to: amplitude)
//    }
//
//    if let offset = offset {
//      try await printerController.setVoltageOffset(to: offset)
//    }
//
//    if let phase = phase {
//      try await printerController.setPhase(to: phase)
//    }
//
//    if let waveFunction = waveFunction {
//      try await printerController.setWaveFunction(to: waveFunction)
//    }
//  }
//}
//
//// MARK: - Binding
//public extension Binding where Value == PrinterOperation {
//  var waveformConfiguration: Binding<WaveformSettingsConfiguration> {
//    Binding<WaveformSettingsConfiguration> {
//      if case let .waveformSettings(configuration) = wrappedValue.operationType {
//        return configuration
//      } else {
//        return .init()
//      }
//    } set: { newValue in
//      wrappedValue.operationType = .waveformSettings(newValue)
//    }
//  }
//}

