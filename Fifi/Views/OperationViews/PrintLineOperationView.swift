//
//  PrintLineOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 1/21/22.
//

import SwiftUI
import SeeayaUI
import PrinterController

struct PrintLineOperationView: View {
	@Binding var configuration: PrintLineConfiguration
	
	var body: some View {
		VStack {
			HStack {
				Text("Direction")
				
				Menu(configuration.dimension.rawValue) {
					ForEach(PrinterController.Dimension.allCases) { dimension in
						Button(dimension.rawValue) {
							configuration.dimension = dimension
						}
					}
				}
			}
			
			HStack {
				Text("Line length")
				
				ValidatingTextField("Line length", value: $configuration.lineLength) { value in
					Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
				} validate: { string in
					Double(string)
				}
			}
			
			HStack {
				Text("Voltage")
				
				ValidatingTextField("Voltage", value: $configuration.voltage) { value in
					Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
				} validate: { string in
					Double(string)
				}
			}
			
			HStack {
				Text("Layers")
				
				ValidatingTextField("Layers", value: $configuration.numberOfLayers) { value in
					String(value)
				} validate: { string in
					Int(string)
				}
			}
			
			
		}
	}
	
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		
		return formatter
	}()
}

struct PrintLineOperationView_Previews: PreviewProvider {
	static var previews: some View {
		PrintLineOperationView(configuration: .constant(.init()))
	}
}
