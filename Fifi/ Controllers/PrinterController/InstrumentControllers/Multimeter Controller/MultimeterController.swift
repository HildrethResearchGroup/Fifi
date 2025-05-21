//
//  MultimeterController.swift
//  
//
//  Created by Connor Barnes on 12/13/21.
//

import Foundation
import SwiftVISASwift

public actor MultimeterController {
    /// The `MessageBasedInstrument` instance that the `MultimeterController` will use to communicate with.
    var instrument: MessageBasedInstrument
    
    /// Initializes a new `MultimeterController` with a given `MessageBasedInstrument`.
    /// - Parameter instrument: The `MessageBasedInstrument` to be used for controlling the multimeter.
    init(instrument: MessageBasedInstrument) {
        self.instrument = instrument
    }
}
