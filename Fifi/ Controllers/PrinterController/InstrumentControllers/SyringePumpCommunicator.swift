//
//  SyringePumpCommunicator.swift
//  Fifi
//
//  Created by Alyssa Hanson (Student) on 6/3/24.
//

import Foundation
import Socket //import bluesocket library

final class SyringePumpCommunicator {
    var substring: String = ""
    var lastTwo: String = ""

    let socket: Socket

    /// Tries to create an instance from the specified address, and port of the instrument. A timeout value must also be specified.
        ///
        /// - Parameters:
        ///   - address: The IPV4 address of the instrument in dot notation.
        ///   - port: The port of the instrument.
        ///   - timeout: The maximum time to wait before timing out when communicating with the instrument.
        ///
        /// - Throws: An error if a socket could not be created, connected, or configured properly.
        ///
        init(address: String, port: Int, timeout: TimeInterval) throws {
            // Try to create a socket:
            // - usr-tcp232-302 uses an IPV4 address, so the protocol family .inet is used.
            // - We would like to read to and write from the socket, so .stream is used.
            // - device communicates over .tcp.
            do {
                socket = try Socket.create(family: .inet, type: .stream, proto: .tcp)
            } catch { throw Error.couldNotCreateSocket }

            // USr-TCP232-302 sends packets in sizes of 400 bytes
            socket.readBufferSize = 1024

            do {
                print(address)
                print(port)
                try socket.connect(to: address, port: Int32(port))
            } catch { throw Error.couldNotConnect }

            do {
                // Timeout is set as an integer in milliseconds, but it is clearer to pass in a TimeInterval into the function because TimeInterval is used
                // thoughout Foundation to represent time in seconds.
                let timeoutInMilliseconds = UInt(timeout * 1_000.0)
                try socket.setReadTimeout(value: timeoutInMilliseconds)
                try socket.setWriteTimeout(value: timeoutInMilliseconds)
            } catch { throw Error.couldNotSetTimeout }

            do {
                // I'm not sure why we need to senable blocking, but the python drivers enabled it, so we will too.
                try socket.setBlocking(mode: true)
            } catch { throw Error.couldNotEnableBlocking }
        }

        deinit {
            // Close the connection to the socket because we will no longer need it.
            socket.close()
        }
    }

extension SyringePumpCommunicator {
    /// Reads a message from the instrument.
    ///
    /// - Throws: If a reading or decoding error occurred.
    ///
    /// - Returns: The message string and integer code returned by the instrument.
    func read() throws -> (message: String, code: Int) {
        // The message may not fit in a single buffer (only 1024 bytes). To overcome this, we continue to request data until we are at the end of the message.
        // The API ends all of its messages in the string ",EndOfAPI", so we continue to append values to `string` until it ends in ",EndOfAPI".
        var string = ""
        repeat {
            do {
                guard let substring = try socket.readString() else { throw Error.failedReadOperation }
                string += substring
            } catch { throw Error.failedReadOperation }
        } while !string.hasSuffix(",EndOfAPI")

        // The message returned is divided into three parts seperated by commas:
        // 1. The integer code associated with the message
        // 2. The string content of the message
        // 3. The string "EndOfAPI" to indicate the end of the message
        //
        // We can discard the "EndOfAPI" portion because every message ends with this, so it carries no information.
        // We then want to seperate the integer code and string content to return to the user.
        // The firstDividerIndex is the string index of the first comma, which seperates the integer code and string content.
        guard let firstDividerIndex = string.firstIndex(of: ",") else { throw Error.couldNotDecode }

        // integerCodeRange is the range of characters of the integer code. It is from the first character to immediately before the first comma.
        let integerCodeRange = string.startIndex..<firstDividerIndex
        guard let integerCode = Int(string[integerCodeRange]) else { throw Error.couldNotDecode }

        // messageRange is the range of characters of the string content. It is from after the first comma to immediately before the comma directly before
        // the substring "EndOfAPI". Because there will always be 9 final characters we want to cut from the end (",EndOfAPI"), we can simply subtract 9 from
        // the string's end index to get the end index.
        let messageRange = string.index(after: firstDividerIndex)..<string.index(string.endIndex, offsetBy: -9)
        let message = String(string[messageRange])

        return (message, integerCode)
    }
}

// MARK: Writing

extension SyringePumpCommunicator {
    /// Sends a string to the instrument. This should be a function such as `"ElapsedTimeGet(double *)"`.
    /// - Parameter string: The string to sent the instrument.
    func write(data: Data) throws {

            do{
                try socket.write(from: data)

            } catch {
                throw Error.failedWriteOperation
            }

    }
}

// MARK: Error

//update these errors so they correspond with the errors from the pump
extension SyringePumpCommunicator {
    /// An error associated with an XPSQ8Communicator.
    ///
    /// - `couldNotCreateSocket`: The socket to communicate with the instrument could not be created.
    /// - `couldNotConnect`: The instrument could not be connected to. The instrument may not be connected, or could have a different address/port than the one specified.
    /// - `couldNotSetTimeout`: The timeout value could not be set.
    /// - `couldNotEnableBlocking`: The socket was unable to enable blocking.
    enum Error: Swift.Error {
        case couldNotCreateSocket
        case couldNotConnect
        case couldNotSetTimeout
        case couldNotEnableBlocking
        case failedWriteOperation
        case failedReadOperation
        case couldNotDecode
    }
}

// MARK: Error Descriptions
extension SyringePumpCommunicator.Error {
    var localizedDescription: String {
        switch self {
        case .couldNotConnect:
            return "Could not connect."
        case .couldNotCreateSocket:
            return "Could not create socket."
        case .couldNotSetTimeout:
            return "Could not set timeout."
        case .couldNotEnableBlocking:
            return "Could not enable blocking."
        case .failedWriteOperation:
            return "Failed write operation."
        case .failedReadOperation:
            return "Failed read operation."
        case .couldNotDecode:
            return "Could not decode."
        }
    }
}


extension SyringePumpCommunicator{
    
    // This function sends a query command to the pump, reads the socket to get the response from the pump, and parses this string to find the specific substring containing the amount dispensed.
    // data is an unused parameter from an older version of the function
    // pump is the string with the pump address, for two pumps its either "00" or "01"
    //returns the string with the pump response
    public func readAndPrint(data: inout Data, pump: String) throws -> String {
//        if let data = "\(pump)CLD".data(using: .utf8){
//            do{
//                try self.write(data: data)
//                Thread.sleep(forTimeInterval: 0.05)
//            }catch{
//                print("Failed to send")
//            }
//        }
       // self.write(data: "CLD")
        if let data = "\(pump)DIS\r".data(using: .utf8){
            do{
                print("Check")
                try socket.write(from: data)
                Thread.sleep(forTimeInterval: 0.05)
            }catch{
                print("Failed to send")
            }
        }
        data.count = 0
        let bytesRead = try socket.read(into: &data)
        if bytesRead > 0 {
            guard let response = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue) else {
                print("Error accessing received data...")
                return "Error"
            }
            print(response)
            

            let inputString = response as String
            if inputString.count >= 3 {
                let index = inputString.index(inputString.endIndex, offsetBy: -3)
                lastTwo = String(inputString[index...])
            } else {
                lastTwo = inputString
            }
            // Find the range of "W"
            if let rangeOfW = inputString.range(of: "W") {
                // Check if there are at least 4 characters before "W"
                if inputString.distance(from: inputString.startIndex, to: rangeOfW.lowerBound) >= 5 {
                    let startIndex = inputString.index(rangeOfW.lowerBound, offsetBy: -5)
                    let endIndex = inputString.index(rangeOfW.lowerBound, offsetBy: -1)
                    substring = String(inputString[startIndex...endIndex])
                    //print("Characters before W: \(substring)")
                    let output: String = (substring + lastTwo)
                    return String(output)
                } else {
                    print("Not enough characters before W")
                }
            } else {
                print("Could not find 'W' in the string")
            }
        }
        return substring
    }
}
