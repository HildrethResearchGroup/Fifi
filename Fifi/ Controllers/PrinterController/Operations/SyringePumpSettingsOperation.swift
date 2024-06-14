//
//  File.swift
//
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import SwiftUI

public struct SyringePumpSettingsConfiguration: Hashable, Codable { // for each operation define a new struct containing all data needed to perform that operation. This struct will be used in the operation view and in the operation code below.
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
            thumbnailName: "syringe.fill", body: body) {configuration, printerController in // code to be executed goes in this trailing closure. Must take configuration and printerController. The configuration here is an instance of the struct declared above.
                    if let flowRate1 = configuration.flowRate1, let units1 = configuration.units1 {
                        print(units1)
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
    
          
