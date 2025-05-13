//
//  PumpState.swift
//  Fifi
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import Foundation

//Currently unused, mimicked from waveform state. UI does not query the instrument for updates like the waveform controller does.
public struct PumpState {
  public var updateInterval: TimeInterval? = 0.2

    public internal(set) var innerDiameter1: String?
    public internal(set) var innerDiameter2: String?
    public internal(set) var flowRate1: String?
    public internal(set) var flowRate2: String?
    public internal(set) var  dualStart: Bool?
    public internal(set) var dispensed: String?
}
