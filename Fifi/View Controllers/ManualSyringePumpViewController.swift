//
//  SyringePumpViewController.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/16/25.
//

import Foundation

@Observable
final class ManualSyringePumpViewController {
    var controller: SyringePumpController
    
    var pump1: Pump
    var pump2: Pump
    
    init(controller: SyringePumpController) {
        self.controller = controller
        
        self.pump1 = .init(.p00)
        self.pump2 = .init(.p01)
    }
        
    
    
}


// MARK: - State and Pump Numbers
extension ManualSyringePumpViewController {
    func updatePump1FlowRate(for pump: Pump) {
        Task {
            try await controller.updateRate(for: pump)
        }
    }
    
    
    func updateInnerDiameter(for pump: Pump) {
        Task {
            try await controller.updateInnerDiameter(for: pump)
        }
    }
    
    func start(pump: Pump) {
        Task {
            try await controller.start(pump: pump)
        }
    }
    
    func stop(pump: Pump) {
        Task {
            try await controller.stop(pump: pump)
        }
    }
    
    
    func toggleOnOff(pump: Pump) {
        Task {
            try await controller.toggleOnOff(pump: pump)
        }
    }
    
    
    func updateAllSettings(pump: Pump) {
        Task {
            try await controller.updateAllSettings(for: pump)
        }
    }
}




