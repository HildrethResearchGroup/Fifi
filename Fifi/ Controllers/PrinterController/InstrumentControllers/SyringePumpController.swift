import Foundation
import Socket

public class SyringePumpController: ObservableObject {
    
    let address: String
    let port: Int
    let timeout: TimeInterval
    
    
    
    var communicator: SyringePumpCommunicator?
    /*
     creates the communicator that connects to the converter over an ethernet socket.
     */
    public init(address: String, port: Int, timeout: TimeInterval) async throws {
        do {
            self.address = address
            self.port = port
            self.timeout = timeout
            communicator = try SyringePumpCommunicator(address: address, port: Int(port), timeout: timeout)
            print("Connected to the syringe pump")
        } catch {
            print("Failed to connect: \(error)")
        }
    }
    
    deinit {
        communicator?.socket.close()
        communicator = nil
        print("socket closed")
    }
    
    func send(_ sendData: String) {
        let sendString = sendData + "\r\n"
        
        guard let communicator else {
            print("ERROR: send - communicator == nil")
            return
        }
        
        print("Syringe pump controller sent: \(sendString)")
        if let data = sendString.data(using: .utf8) {
            do {
                try communicator.write(data: data)
                Thread.sleep(forTimeInterval: 0.05)
            } catch {
                print("Failed to send data: \(error)")
            }
        }
    }
    
    /*
     sets given pump to pump at given number of given units
     */
    public func setRate(for pump: String, to quantity: String, of units: String) async {
        self.send("")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.send("\(pump)FUN RAT") // starting pump
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.send("\(pump)RAT \(quantity) \(units)") // starting pump
        }
    }
    
    /*
     sets the size of the inner diameter of the syringe. input is not validated.
     units are in mm we think?
     */
    public func setInnerDiameter(for pump: String, to diameter: String) async {
        self.send("")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.send("\(pump)DIA \(diameter)") // starting pump
        }
    }
    
    /*
     sends basic start command to pump of given number
     input is not checked or validated
     */
    public func startPumping(pump: String) {
        self.send("") // Sending empty string first seems to make things more consistent
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.send("\(pump)RUN") // starting pump
        }
    }
    
    /*
     sends command to start pump of given number
     input is not checked or validated
     */
    public func stopPumping(pump: String) {
        send("\(pump)STP")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.send("\(pump)STP") // entering rate mode
        }
    }
}
