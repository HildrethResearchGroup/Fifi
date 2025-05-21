//
//  Pump.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/21/25.
//


// MARK: Pump
class Pump: Identifiable {
    var id: PumpID
    var state: PumpingState = .stopped {
        didSet {
        
        }
    }
    var flowRate: Double = 20.0
    var units: FlowRateUnits = .nL_min
    var diameter: Double = 1.0
    var pumpCommunicationID: String { id.rawValue  }
    
    init(_ id: PumpID) {
        self.id = id
    }
    
    
    var flowRateCommunicationString: String {
        let idString = self.pumpCommunicationID
        let quantity = String(format: "%.2f", flowRate)
        let units = units.queryString
        
        return "\(idString)RAT \(quantity)\(units)"
    }
    
    var updateInnerDiameterCommunicationString: String {
        let idString = self.pumpCommunicationID
        let quantity = String(diameter)
        
        return "\(idString)DIA \(quantity)"
    }
    
    enum PumpingState: String {
        case pumping
        case stopped
    }
    
    
    enum PumpID: String, CaseIterable, Identifiable {
        var id: Self { self }
        case p00
        case p01
        
        var queryString: String {
            switch self {
            case .p00: return "00"
            case .p01: return "01"
            }
        }
    }
    
    enum FlowRateUnits: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case mm_hr = "ml / hr"
        case uL_hr = "µl / hr"
        case nL_hr = "nl / hr"
        case mm_min = "ml / min"
        case uL_min = "µl / min"
        case nL_min = "nl / min"
        
        
        var queryString: String {
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
}
