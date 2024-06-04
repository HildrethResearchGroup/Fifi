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

  public internal(set) var innerDiameter1: String?
  public internal(set) var innerDiameter2: String?
    public internal(set) var flowRate1: String?
    public internal(set) var flowRate2: String?
    
    public var amplifiedVoltage: Double? {
        rawVoltage.flatMap { $0 * 1000 }
    }
    
    public var amplifiedVoltageOffset: Double? {
        rawVoltageOffset.flatMap { $0 * 1000 }
    }
}
