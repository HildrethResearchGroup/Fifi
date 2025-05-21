/*
 Class used for all operations on the syringe pump
 */
import Foundation
import Socket


actor SyringePumpController {
    
    var address: String
    var port: Int
    var timeout: TimeInterval
    
    var pump1 = Pump(.p00)
    var pump2 = Pump(.p01)
    
    var dualControl = false
    
    // TODO: Remove if unnded
    private var substring: String = ""
    private var lastTwo: String = ""

    
    
    private var communicator: SyringePumpCommunicator?
    /*
     creates the communicator that connects to the converter over an ethernet socket.
     */
    
    init(address: String, port: Int, timeout: TimeInterval) async throws {
        do {
            self.address = address
            self.port = port
            self.timeout = timeout
            communicator = try SyringePumpCommunicator(address: address, port: Int(port), timeout: timeout)
            print("Connected to the syringe pump")
        } catch {
            print("Failed to connect: \(error)")
            throw SyringeControllerError.communicatorNotConnected
        }
    }
    
    deinit {
        communicator?.socket.close()
        communicator = nil
        print("socket closed")
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

extension SyringePumpController {
    enum SyringeControllerError: Error {
        case communicatorNotConnected
    }
}
