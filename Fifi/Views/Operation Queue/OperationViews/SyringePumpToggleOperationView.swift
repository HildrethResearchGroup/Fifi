//
//  SyringePumpVoltageToggleOperationView.swift
//  Fifi
//
//  Created by Matt Boughey on 6/4/24.
//

import Foundation
import SwiftUI

struct SyringePumpToggleOperationView: View {
  @Binding var configuration: SyringePumpToggleConfiguration
  var body: some View {
      HStack{
          Picker("Pump 1", selection: $configuration.pump1Action) {
              ForEach(PumpAction.allCases) { pump1action in
                  Text(pump1action.rawValue).tag(pump1action)
              }
          }
              Divider()
          Picker("Pump 2", selection: $configuration.pump2Action) {
              ForEach(PumpAction.allCases) { pump2action in
                  Text(pump2action.rawValue).tag(pump2action)
              }
          }
      }
    .id(UUID())
  }
}

// MARK: Previews
struct SyringePumpToggleOperationView_Previews: PreviewProvider {
  static var previews: some View {
    SyringePumpToggleOperationView(
      configuration: .constant(
        .init()
      )
    )
      .padding()
  }
}
