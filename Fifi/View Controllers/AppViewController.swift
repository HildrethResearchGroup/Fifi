//
//  AppViewController.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/21/25.
//

import Foundation

@Observable
final class AppViewController {
    var delegate: AppViewControllerDelegate?
    
    var printerController: PrinterController
    var manualSyringePumpVC: ManualSyringePumpViewController?
    
    init(printerController: PrinterController) {
        self.printerController = printerController
        
        Task {
            await self.setupChildViewController()
        }
        
    }
    
    
    func setupChildViewController() async {
        
        Task {
            if let localSyringPumpController = await printerController.syringePumpController {
                manualSyringePumpVC = ManualSyringePumpViewController(controller: localSyringPumpController)
            }
        }
    }
}


protocol AppViewControllerDelegate {
    
}
