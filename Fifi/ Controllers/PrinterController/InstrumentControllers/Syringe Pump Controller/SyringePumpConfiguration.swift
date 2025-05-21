//
//  SyringePumpConfiguration.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/17/25.
//

import Foundation
import SwiftVISASwift
import XPSQ8Kit


// TODO: Move all configurations to the controller
// MARK: - Pump Configuration
public struct syringePumpConfiguration: Sendable {
  public var address: String
  public var port: Int
  public var timeout: TimeInterval = 5.0

  public init(
    address: String,
    port: Int,
    timeout: TimeInterval = 5.0
  ) {
    self.address = address
    self.port = port
    self.timeout = timeout
  }

  public static var empty: syringePumpConfiguration {
    return .init(address: "0.0.0.0", port: 5001)
  }

  func makeInstrument() async throws -> SyringePumpController {
    try await SyringePumpController(address: address, port: port, timeout: timeout)
  }
}
