//
//  PumpState.swift
//  Fifi
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import Foundation

//TODO: change the copy pasted-code so that it actually works with the
public struct PumpState {
  public var updateInterval: TimeInterval? = 0.2
  
  public internal(set) var rawVoltage: Double?
  public internal(set) var rawVoltageOffset: Double?
  public internal(set) var frequency: Double?
  public internal(set) var phase: Double?
  public internal(set) var waveFunction: WaveFunction?
    public internal(set) var impedance: Double?
    public internal(set) var voltageIsOn: Bool?
    
    public var amplifiedVoltage: Double? {
        rawVoltage.flatMap { $0 * 1000 }
    }
    
    public var amplifiedVoltageOffset: Double? {
        rawVoltageOffset.flatMap { $0 * 1000 }
    }
}
