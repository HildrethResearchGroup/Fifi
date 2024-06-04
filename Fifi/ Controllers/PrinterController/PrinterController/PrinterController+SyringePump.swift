//
//  File.swift
//
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import Foundation


public extension PrinterController {
    func setFlowRate1(to quantity: Double, of units:String) async throws {
        // TODO:
        try await with(.pump) {
            try await syringePumpController?.setRate(for: "00", to: String(format: "%f", quantity), of: units)
        }
    }

    func setFlowRate2(to quantity: Double, of units:String) async throws {
      try await with(.pump) {
          try await syringePumpController?.setRate(for: "01", to: String(format: "%f", quantity), of: units)
      }
    }
    

    func setInnerDiameter1(to value: Double) async throws {
        try await with(.pump) {
            try await syringePumpController?.setInnerDiameter(for: "00", to: String(format: "%f", value))
        }
    }

    func setInnerDiameter2(to value: Double) async throws {
        try await with(.pump) {
            try await syringePumpController?.setInnerDiameter(for: "01", to: String(format: "%f", value))
        }
    }
    
    func startPump1() async throws {
        try await syringePumpController?.startPumping(pump: "00")
    }
    
    func startPump2() async throws {
        try await syringePumpController?.startPumping(pump: "01")
    }
    
    func stopPump1() async throws {
        try await syringePumpController?.stopPumping(pump: "00")
    }
    
    func stopPump2() async throws {
        try await syringePumpController?.stopPumping(pump: "01")
    }
    
}
