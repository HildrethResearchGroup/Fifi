//
//  PrintDotArrayOperation.swift
//  
//
//  Created by Connor Barnes on 7/15/22.
//

import SwiftUI

public struct PrintDotArrayConfiguration: Codable, Hashable {
	public var spacing: Double = 1.0
	public var voltage: Double = 1.0
	public var voltageTime: Double = 0.1
	//public var numberOfDots: Int = 1
    //collin
    public var numberOfXDots: Int = 1
    public var numberOfYDots: Int = 1
    //add in dot row control
    
    
	public var numberOfLayers: Int = 1
	
	public init() { }
}


extension PrinterOperation {
	public static func printDotArrayOperation<Body: View>(
		body: @escaping (Binding<PrintDotArrayConfiguration>) -> Body
	) -> PrinterOperation<PrintDotArrayConfiguration, Body> {
		.init(
			kind: .printDotArray,
			configuration: .init(),
			name: "Print Dot Array",
			thumbnailName: "circle.dotted",
			body: body
		) { configuration, printerController in
			// Start Print the dot array
            
            // Get the starting position so that stage can return to this position if mulitple layers are being printed
			let startX = try await printerController.position(in: .x)
			let startY = try await printerController.position(in: .y)
			
            
            
            
            
            // Get the current velocity of the stages.  Assume that x and y have the same velocity and that the velocity is fixed
            var velocity = 10.0 // default is 10 mm
            if let displacementMode = await printerController.xpsq8State.xDisplacementMode {
                switch displacementMode {
                case .large: velocity = 10.0
                case .medium: velocity = 1.0
                case .small: velocity = 0.1
                case .fine: velocity = 0.01
                }
            }
            
            
            // Need to add delays/sleeps to give the stages enough time to move before moving again
            // Determine how long it will take to move in seconds
            let buffer = 1.1  // Assume the moves will take a little longer than minimum
            let stepTime = configuration.spacing * buffer/velocity
            let nextRowTime = configuration.spacing * buffer/velocity
            let returnToStartXLocation = Double(configuration.numberOfXDots) * buffer * configuration.spacing / velocity
            let returnToStartYLocation = Double(configuration.numberOfYDots) * buffer * configuration.spacing / velocity
            
            
            
            // TODO: Remove logging information for print dot array command
            // Logging information because the print dot command wasn't working properly.
            func location() async -> String {
                let currentX = try? await printerController.position(in: .x)
                let currentY = try? await printerController.position(in: .y)
                
                let outputString = ("x = \(String(describing: currentX))\t y = \(String(describing: currentY))")
                return outputString
            }
            
            func recordInfo(layer layerNumber: Int, column columnNumber: Int, row rowNumber: Int) async {
                let locationString = await location()
                print("\n Printing: Layer: \(layerNumber)\tColumn: \(columnNumber)\tRow: \(rowNumber) at: \(locationString)")
            }
            
            
            
			
			// Printing Layers.  Each set of x-y dots is printed as an array, and then the next layer returns to startX and startY to print next layer.
			for layerNumber in 0..<configuration.numberOfLayers {
				for rowIndex in 0..<configuration.numberOfYDots {
					for columnIndex in 0..<configuration.numberOfXDots {
						await recordInfo(layer: layerNumber, column: columnIndex, row: rowIndex)
						// Print a Dot
						try await printerController.turnVoltageOn()
						try await Task.sleep(nanoseconds: UInt64(configuration.voltageTime * 1_000_000_000))
						try await printerController.turnVoltageOff()
						
                        
						// Relative Move in x to next print location in that row
						try await printerController.moveRelative(in: .x, by: configuration.spacing)
                        
                        // Wait until the step move is done
                        try await Task.sleep(nanoseconds: UInt64(stepTime * 1000000000.0))
                        
					} // Done printing all the columns in that row (configuration.numberOfXDots)
					
					
					// Relative Move in y down to next row
					try await printerController.moveRelative(in: .y, by: configuration.spacing)
                
                    // Wait until the step move is done
                    try await Task.sleep(nanoseconds: UInt64(nextRowTime * 1000000000.0))
					
                    
					// Return Absolute to xStart
					try await printerController.moveAbsolute(in: .x, to: startX)
                    try await Task.sleep(nanoseconds: UInt64(returnToStartXLocation * 1000000000.0))
                    
                    
				} // Done printing a complete set of rows and columns for one layer.
				
				
				// STARTING OVER - REMOVE
				/*
				 // COLUMNS
				 for columnNumber in 0..<configuration.numberOfYDots {
					 // Shift one position in y
					 try await printerController.moveRelative(in: .y, by: configuration.spacing)
					 
					 // Return to
					 
					 // ROWS
					 for rowNumber in 0..<configuration.numberOfXDots {
						 // Shift one position in x
						 try await printerController.moveRelative(in: .x, by: configuration.spacing)
						 
						 await recordInfo(layer: layerNumber, column: columnNumber, row: rowNumber)
						 
						 try await printerController.turnVoltageOn()
						 try await Task.sleep(nanoseconds: UInt64(configuration.voltageTime * 1_000_000_000))
						 try await printerController.turnVoltageOff()
						 
						 try await printerController.moveRelative(in: .x, by: -configuration.spacing*Double(configuration.numberOfXDots))
						 
					 }
					 
					 
					 try await Task.sleep(nanoseconds: 1_000_000_000)
					 
					 
				 }
				 */
				
				// STARTING OVER - REMOVE
				
				// KEEP
				// Returning to starting position
				try await printerController.moveAbsolute(in: .x, to: startX)
                try await Task.sleep(nanoseconds: UInt64(returnToStartXLocation * 1000000000.0))
				try await printerController.moveAbsolute(in: .y, to: startY)
                try await Task.sleep(nanoseconds: UInt64(returnToStartYLocation * 1000000000.0))
                
			}
			
			
		}
	}
}
