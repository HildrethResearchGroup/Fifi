//
//  XPSConfiguration.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/17/25.
//

import Foundation
import SwiftVISASwift
import XPSQ8Kit


// MARK: - XPSQ8 Configuration
public struct XPSQ8Configuration: Sendable {
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
  
  public static var empty: XPSQ8Configuration {
    return .init(address: "0.0.0.0", port: 5001)
  }
  
  func makeInstrument() async throws -> XPSQ8CollectiveController {
    try await XPSQ8CollectiveController(address: address, port: port, timeout: timeout)
  }
}
