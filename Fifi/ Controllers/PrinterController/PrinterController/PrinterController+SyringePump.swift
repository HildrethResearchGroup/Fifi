//
//  File.swift
//
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//
// uses the syringe pump controller to define functions needed by the printercontroller

import Foundation
import Socket


public extension PrinterController {

    /*
     func setInnerDiameter1(to value: Double) async throws {
         try await with(.pump) {
             try await syringePumpController?.setInnerDiameter(for: "00", to: String(format: "%.2f", value))
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
     
    
    
    
    //MARK: Manual control functionality
    // unlike other functions in this file, this one takes the pump number
    // only used by manual control
    func startOrStopPumping(pump: String, shouldStart: Bool) async throws {
        if shouldStart {
            try await syringePumpController?.startPumping(pump: pump)
        } else {
            try await syringePumpController?.stopPumping(pump: pump)
        }
    }
    
    func sendAllSettings(pump: String, rate: String, ID: String, units: String) async throws {
        try await syringePumpController?.setRate(for: pump, to: rate, of: units)
        try await syringePumpController?.setInnerDiameter(for: pump, to: ID)
    }
    
     
    
    
    func getVolume(pump: String) async -> String{
        do{
            return try await self.syringePumpController?.getVolDispensed(pump: pump) ?? "Error"
        }catch{
            return "Error"
        }
    }
     
     */
}
