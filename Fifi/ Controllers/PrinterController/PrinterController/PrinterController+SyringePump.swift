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
    
//TODO: fix these funcs
    func enablePump1(to quantity: String, of units:String) async throws {
      try await with(.pump) {
          try await syringePumpController?.setRate(for: "01", to: quantity, of: units)
      }
    }
    
    func enablePump2(to quantity: String, of units:String) async throws {
      try await with(.pump) {
          try await syringePumpController?.setRate(for: "01", to: quantity, of: units)
      }
    }

    func setInnerDiameter1(to value: String) async throws {
        try await with(.pump) {
            try await syringePumpController?.setInnerDiameter(for: "00", to: value)
        }
    }

    func setInnerDiameter2(to value: String) async throws {
        try await with(.pump) {
            try await syringePumpController?.setInnerDiameter(for: "01", to: value)
        }
    }
    
}
