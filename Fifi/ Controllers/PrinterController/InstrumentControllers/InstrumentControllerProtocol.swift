//
//  InstrumentProtocol.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/21/25.
//

import Foundation

protocol InstrumentController {
    func connect() async throws
    func disconnect() async throws
}
