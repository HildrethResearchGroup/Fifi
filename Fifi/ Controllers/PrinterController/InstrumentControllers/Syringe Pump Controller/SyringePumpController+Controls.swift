//
//  SyringePumpController+Controls.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/19/25.
//

import Foundation

extension SyringePumpController {
    /** Sets pump rate for specified pump.
     **/
    public func updateRate(for pump: Pump) async throws {
        try self.send("")
        
        // TODO: Verify New approach works
        try? await Task.sleep(nanoseconds: UInt64(0.1E9))
        let pumpID = pump.pumpCommunicationID
        try self.send("\(pumpID)FUN RAT") // starting pump

        
        try? await Task.sleep(nanoseconds: UInt64(0.2E9))
        try self.send(pump.flowRateCommunicationString)

        
        /* // OLD Way
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             self.send("\(pump)FUN RAT") // starting pump
         }
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
             self.send("\(pump)RAT \(quantity) \(units)") // starting pump
         }
         */
    }
    
    /** Sets the size of the inner diameter of the syringe.
     
     Input is not validated.  Units are in mm we think?
     **/
    public func updateInnerDiameter(for pump: Pump) async throws {
        try self.send("")
        
        // TODO: Verify New approach works
        try? await Task.sleep(nanoseconds: UInt64(0.1E9))
        try self.send(pump.updateInnerDiameterCommunicationString) // Updating Diameter
        
        /*  OLD Way
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             self.send("\(pump)DIA \(diameter)") // starting pump
         }
         */
    }
    
    
    
    /** Sends command to start pump.
     
     Input is not checked or validated
     **/
    func start(pump: Pump) async throws {
        try self.send("") // Sending empty string first seems to make things more consistent
        
        try? await Task.sleep(nanoseconds: UInt64(0.1E9))
        let pumpID = pump.pumpCommunicationID
        
        try self.send("\(pumpID)RUN")
        
        pump.state = .pumping
        
        /** OLD Way
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
             self.send("\(pump)RUN") // starting pump
         }
         */
    }
    
    
    
    /** Sends command to stop the pump.
     
     Input is not checked or validated
     **/
    func stop(pump: Pump) throws {
        let pumpID = pump.pumpCommunicationID
        
        try send("\(pumpID)STP")
        
        pump.state = .stopped
        
        /*
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          self.send("\(pump)STP") // entering rate mode
         }
         */
    }
    
    
    func toggleOnOff(pump: Pump) throws {
        switch pump.state {
        case .pumping: try self.stop(pump: pump)
        case .stopped: try self.stop(pump: pump)
        }
    }
    
    
    func updateAllSettings(for pump: Pump) async throws {
        try await self.updateInnerDiameter(for: pump)
        try await self.updateRate(for: pump)
    }
    
}
