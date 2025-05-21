//
//  WaveformConfiguration.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/17/25.
//

import Foundation
import SwiftVISASwift
import XPSQ8Kit


// MARK: - Waveform Configuration
public struct VISAEthernetConfiguration {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0
  public var attributes = MessageBasedInstrumentAttributes()
  
  public init(
    address: String,
    port: Int,
    timeout: TimeInterval = 5.0,
    attributes: MessageBasedInstrumentAttributes = .init()
  ) {
    self.address = address
    self.port = port
    self.timeout = timeout
    self.attributes = attributes
  }
  
  public static var empty: VISAEthernetConfiguration {
    return .init(address: "0.0.0.0", port: 5025)
  }
  
  func makeInstrument() async throws -> MessageBasedInstrument {
    var instrument = try await InstrumentManager.shared.instrumentAt(
      address: address,
      port: port,
      timeout: timeout
    )
    instrument.attributes = attributes
    return instrument
  }
}
