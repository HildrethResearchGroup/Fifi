//
//  AppController.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/14/25.
//

import Foundation

@Observable
@MainActor
final class AppController {
    var printerController: PrinterController?
    var appViewController: AppViewController?
    
    init() {
        
        Task {
            let localPrinterController = await PrinterController()
            self.printerController = localPrinterController
            
            self.appViewController = AppViewController(printerController: localPrinterController)
            
            
        }
        
        
        
    }
    
    
    
    
}
