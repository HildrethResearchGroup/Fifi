//
//  PrintDotArrayOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 7/15/22.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct PrintDotArrayOperationView: View {
	@Binding var configuration: PrintDotArrayConfiguration
	
	var body: some View {
		VStack {
			ValidatingTextField("Spacing", value: $configuration.spacing) { value in
				String(value)
			} validate: { string in
				Double(string)
			}
		}
	}
}
