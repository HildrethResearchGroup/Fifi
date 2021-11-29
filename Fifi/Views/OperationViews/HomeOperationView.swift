//
//  HomeOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI
import PrinterController

struct HomeOperationView: View {
	@Binding var configuration: HomeConfiguration
	
	var body: some View {
		Text("No configuration options")
	}
}

struct HomeOperationView_Previews: PreviewProvider {
	static var previews: some View {
		HomeOperationView(configuration: .constant(.init()))
	}
}
