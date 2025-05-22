/*
 Class used for all operations on the syringe pump
 */
import Foundation
import Socket


actor SyringePumpController {
    /// Communicator connects to syringe pump through the TCP/IP to Serial converter
    private var communicator: SyringePumpCommunicator?
    
    /** IP Address for the syringe pump
     
    Taken from User Defaults
     */
    var address: String {
        return UserDefaults.standard.string(forKey: UserDefaults.syringePumpIPAddress) ?? "0.0.0.0.0"
    }
    
    var port: Int {
        return UserDefaults.standard.integer(forKey: UserDefaults.syringePumpPort)
    }
    
    var dualControl: Bool {
        return UserDefaults.standard.bool(forKey: UserDefaults.syringePumpDualControl)
    }
    
    var timeout: TimeInterval = 5.0
    
    
    var pump1 = Pump(.p00)
    var pump2 = Pump(.p01)
    
    
    
    // TODO: Remove if unneeded
    private var substring: String = ""
    private var lastTwo: String = ""

    
    
  
    
    init() async throws {
        try await createCommunicator()
    }
    
    
    deinit {
        communicator?.socket.close()
        communicator = nil
        print("socket closed")
    }
    
    
    // MARK: - Communicating
    private func createCommunicator() async throws {
        do {
            communicator = try SyringePumpCommunicator(address: address, port: port, timeout: timeout)
            print("Connected to the syringe pump")
        } catch {
            print("Failed to connect: \(error)")
            throw SyringeControllerError.communicatorNotConnected
        }
    }
    
    
    private func removeCommunicator() {
        if communicator != nil {
            communicator?.socket.close()
            self.communicator = nil
        }
    }
    
    
    

    func send(_ sendData: String) throws {
        let sendString = sendData + "\r\n"
        
        guard let communicator else {
            print("ERROR: send - communicator == nil")
            return
        }
        
        print("Syringe pump controller sent: \(sendString)")
        if let data = sendString.data(using: .utf8) {
            
            try communicator.write(data: data)
            Thread.sleep(forTimeInterval: 0.05)
        }
    }
    
    
    func getVolDispensed(of pump: Pump) throws -> Double {
        var data = Data()
        let idString = pump.pumpCommunicationID
        
        if let dispensedVolumeString = try communicator?.readAndPrint(data: &data, pump: idString){
            
            return Double(dispensedVolumeString) ?? 0.0
        } else{
            throw SyringeControllerError.communicatorNotConnected
        }
    }

}



extension SyringePumpController: InstrumentController {
    
    static func makeInstrument() async throws -> SyringePumpController {
        return try await SyringePumpController(timeout: 5.0)
    }
    
    
    func connect() async throws {
        try await self.createCommunicator()
    }
    
    
    func disconnect() {
        self.removeCommunicator()
    }
}


extension SyringePumpController {
    enum SyringeControllerError: Error {
        case communicatorNotConnected
    }
}
