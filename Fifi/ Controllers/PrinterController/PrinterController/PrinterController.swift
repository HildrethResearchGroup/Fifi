//
//  PrinterController.swift
//
//
//  Created by Connor Barnes on 7/13/21.
//

import XPSQ8Kit
import SwiftUI


public actor PrinterController: ObservableObject {
    //	var xpsq8Controller: XPSQ8Controller?
    var waveformController: WaveformController?
    var multimeterController: MultimeterController?
    var xpsq8CollectiveController: XPSQ8CollectiveController?
    var syringePumpController: SyringePumpController?
    
    @MainActor
    @Published var xpsq8ConnectionState = CommunicationState.notConnected
    
    @MainActor
    @Published var waveformConnectionState = CommunicationState.notConnected
    
    @MainActor
    @Published var multimeterConnectionState = CommunicationState.notConnected
    
    @MainActor
    @Published var syringePumpConnectionState = CommunicationState.notConnected
    
    @MainActor
    @Published var xpsq8State = XPSQ8State()
    
    @MainActor
    @Published public var waveformState = WaveformState()
    
    @MainActor
    @Published public var multimeterState = MultimeterState()
    
    @MainActor
    @Published public var printerQueueState = PrinterQueueState()
    
    @MainActor
    @Published public var pumpState = PumpState()
    
    @MainActor
    @Published public var updateInterval: TimeInterval? = 0.2
    
    //MARK: State vars for SyringePump
    @State var nextPortState: String = "Connect"
    var nextPumpState: NextPumpState = .startPumping1
    var nextPumpState2: NextPumpState2 = .startPumping2
    
    @State var id1: String = "10"
    @State var id2: String = "10"
    
    @State var units: flowRateUnits = .nL_min
    @State var units2: flowRateUnits2 = .nL_min
    
    @State var pumpNum: pumpNumber = .p0
    
    @State var flowRate: String = "20"
    @State var flowRate2: String = "20"
    
    @State var pump: String = "00"
    @State var dualStart: Bool = false
    @State var subString: String = ""
    
    //MARK: Syringe pump ENUMS
    enum NextPumpState: String {
        case startPumping1 = "Start Pumping 1"
        case stopPumping1 = "Stop Pumping 1"
    }
    
    
    enum NextPumpState2: String {
        case startPumping2 = "Start Pumping 2"
        case stopPumping2 = "Stop Pumping 2"
    }
    
    enum pumpNumber: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case p0 = "Pump 1"
        case p1 = "Pump 2"
        
        var queryString: String {
            switch self {
            case .p0: return "00"
            case .p1: return "01"
            }
        }
    }
    
    enum flowRateUnits: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case mm_hr = "ml / hr"
        case uL_hr = "µl / hr"
        case nL_hr = "nl / hr"
        case mm_min = "ml / min"
        case uL_min = "µl / min"
        case nL_min = "nl / min"
        
        var queryString2: String {
            switch self {
            case .mm_hr: return "MH"
            case .uL_hr: return "UH"
            case .nL_hr: return "NH"
            case .mm_min: return "MM"
            case .uL_min: return "UM"
            case .nL_min: return "NM"
            }
        }
    }
    
    enum flowRateUnits2: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case mm_hr = "ml / hr"
        case uL_hr = "µl / hr"
        case nL_hr = "nl / hr"
        case mm_min = "ml / min"
        case uL_min = "µl / min"
        case nL_min = "nl / min"
        
        var queryString2: String {
            switch self {
            case .mm_hr: return "MH"
            case .uL_hr: return "UH"
            case .nL_hr: return "NH"
            case .mm_min: return "MM"
            case .uL_min: return "UM"
            case .nL_min: return "NM"
            }
        }
    }
    
    // TODO: add updateState for pumpState
    
    public init() async {
        Task {
            await withTaskGroup(of: Void.self) { taskGroup in
                taskGroup.addTask {
                    while true {
                        try? await self.updateXPSQ8State()
                        try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
                    }
                }
                
                taskGroup.addTask {
                    while true {
                        try? await self.updateWaveformState()
                        try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
                    }
                }
                
                taskGroup.addTask {
                    while true {
                        try? await self.updateMultimeterState()
                        try? await Task.sleep(nanoseconds: UInt64(1e9 * (self.updateInterval ?? 1.0)))
                    }
                }
            }
        }
    }
    
    private init() {
        
    }
    
    public static var staticPreview: PrinterController {
        .init()
    }
}

// MARK: - Connecting to Instruments
public extension PrinterController {
    func connectToWaveform(configuration: VISAEthernetConfiguration) async throws {
        do {
            await setState(instrument: .waveform, state: .connecting)
            sleep(1)
            waveformController = try await WaveformController(instrument: configuration.makeInstrument())
            await setState(instrument: .waveform, state: .notInitialized)
        } catch {
            await setState(instrument: .waveform, state: .notConnected)
            throw error
        }
    }
    
    func connectToXPSQ8(configuration: XPSQ8Configuration) async throws {
        do {
            await setState(instrument: .xpsq8, state: .connecting)
            xpsq8CollectiveController = try await configuration.makeInstrument()
            await setState(instrument: .xpsq8, state: .notInitialized)
        } catch {
            await setState(instrument: .xpsq8, state: .notConnected)
            throw error
        }
    }
    
    func connectToMultimeter(configuration: VISAEthernetConfiguration) async throws {
        do {
            await setState(instrument: .multimeter, state: .connecting)
            sleep(1)
            multimeterController = try await MultimeterController(instrument: configuration.makeInstrument())
            await setState(instrument: .multimeter, state: .notInitialized)
        } catch {
            await setState(instrument: .multimeter, state: .notConnected)
            throw error
        }
    }
    
    //TODO: add connectToPump
    
    func connectToSyringePump(configuration: syringePumpConfiguration) async throws {
        do {
            await setState(instrument: .pump, state: .connecting)
            sleep(1)
            //maybe problem here, might need to pass the new instrument to the pumpcontroller like the other instruments
            syringePumpController = try await configuration.makeInstrument()
            await setState(instrument: .pump, state: .notInitialized)
        } catch {
            await setState(instrument: .pump, state: .notConnected)
            throw error
        }
    }
    
    
    //TODO: add disconnect from pump
    
    
    func disconnectFromWaveform() async {
        waveformController = nil
        await setState(instrument: .waveform, state: .notConnected)
    }
    
    func disconnectFromXPSQ8() async {
        xpsq8CollectiveController = nil
        await setState(instrument: .waveform, state: .notConnected)
    }
    
    func disconnectFromMultimeter() async {
        multimeterController = nil
        await setState(instrument: .multimeter, state: .notConnected)
    }
}

// MARK: - Initializing Instruments
public extension PrinterController {
    func initializeWaveform() async throws {
        // TODO: Implement
        await setState(instrument: .waveform, state: .ready)
    }
    
    func initializeXPSQ8() async throws {
        //    guard let xpsq8Controller = xpsq8Controller else { throw Error.instrumentNotConnected }
        //		try await xpsq8Controller.restart()
        //    try await stageGroup.waitForStatus(.readyFromFocus)
        //    try await print("Restarted: ", stageGroup.status)
        //		try await stageGroup.initialize()
        //
        //    try await stageGroup.waitForStatus(.notReferenced)
        //    try await print("Initialized: ", stageGroup.status)
        //    try await searchForHome()
        //    try await stageGroup.waitForStatus(.readyFromHoming)
        //    try await print("Homed: ", stageGroup.status)
        await setState(instrument: .xpsq8, state: .ready)
    }
    
    func initializeSyringePump() async throws {
        await setState(instrument: .pump, state: .ready)
    }
    
    
    func initializeMultimeter() async throws {
        // TODO: Implement
        await setState(instrument: .multimeter, state: .ready)
    }
}
