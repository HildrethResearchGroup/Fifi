//
//  SettingsController.swift
//  Fifi
//
//  Created by Owen Hildreth on 5/21/25.
//

import Foundation

@Observable
class SettingsController {
    
}


extension UserDefaults {
    static var syringePumpIPAddress: String { "syringePumpIPAddress" }
    static var syringePumpPort: String { "syringePumpPort" }
    static var syringePumpDualControl: String { "syringePumpDualControl" }
    static var syringePumpTimeOut: String { "syringePumpTimeOut" }

}
