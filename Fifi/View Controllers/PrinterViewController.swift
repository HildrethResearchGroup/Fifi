//
//  PrinterViewController.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/17/25.
//


import Foundation

@Observable
final class PrinterViewController {
    private var printerController: PrinterController
    
    init(_ printerController: PrinterController) {
        self.printerController = printerController
    }
    
    var xpsq8ConnectionState: CommunicationState = .notConnected
    
    var waveformConnectionState: CommunicationState = .notConnected

    var multimeterConnectionState: CommunicationState = .notConnected
    
    var syringePumpConnectionState: CommunicationState = .notConnected
    
    var xpsq8State: XPSQ8State = XPSQ8State()
    
    var waveformState: WaveformState = WaveformState()
    
    var multimeterState: MultimeterState = MultimeterState()
    
    var printerQueueState: PrinterQueueState = PrinterQueueState()
    
    var pumpState: PumpState = PumpState()
    
    var updateInterval: TimeInterval? = 0.2
    
}
