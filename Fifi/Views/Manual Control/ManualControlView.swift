//
//  ManualControlView.swift
//  ManualControlView
//
//  Created by Connor Barnes on 7/22/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct ManualControlView: View {
  @EnvironmentObject private var printerController: PrinterController
  
  @State private var xJogLocation = 0.0
  @State private var yJogLocation = 0.0
  @State private var zJogLocation = 0.0
  
  @State private var xMoveLocation = 0.0
  @State private var yMoveLocation = 0.0
  @State private var zMoveLocation = 0.0
  
  var body: some View {
    VStack {
      ZStack {
        Text("Manual Stage Control")
          .font(.title3)
        
        HStack {
          Spacer()
					Button(movesHaveBeenAborted ? "Reenable Movement" : "Abort Move") {
						if movesHaveBeenAborted {
							Task {
								try await printerController.reenableMovement()
							}
						} else {
							Task {
								try await printerController.abortAllMoves()
							}
						}
          }
          .foregroundColor(.red)
          .disabled(printerController.xpsq8State.groupStatus != .moving)
        }
      }
      Text(stageStatusString)
      
      ForEach(PrinterController.Dimension.allCases, id: \.rawValue) { dimension in
        ManualStageView(dimension: dimension, jogLocation: jogLocation(for: dimension), moveLocation: moveLocation(for: dimension), displacementMode: displacementMode(for: dimension))
      }
      
			ZStack {
				Text("Manual Voltage Control")
					.font(.title3)
				
				HStack {
					Spacer()
					Button("Turn Off Voltage") {
						Task {
							try await printerController.turnVoltageOff()
						}
					}
					.foregroundColor(.red)
				}
			}
      
      ManualVoltageControlView()
			
			Text("Manual Multimeter Control")
				.font(.title3)
			
			HStack {
				ManualMultimeterView()
				Spacer()
			}
    }
  }
}

// MARK: Helpers
private extension ManualControlView {
	var movesHaveBeenAborted: Bool {
		printerController.xpsq8State.groupStatus == .readyDueToAbortMove
	}
	
  var stageStatusString: String {
    if let status = printerController.xpsq8State.groupStatus {
      return "\(status) (\(status.rawValue))"
    } else {
      return "?"
    }
  }
  
	func jogLocation(for dimension: PrinterController.Dimension) -> Binding<Double> {
		switch dimension {
		case .x:
			return $xJogLocation
		case .y:
			return $yJogLocation
		case .z:
			return $zJogLocation
		}
	}
  
  func moveLocation(for dimension: PrinterController.Dimension) -> Binding<Double> {
    switch dimension {
    case .x:
      return $xMoveLocation
    case .y:
      return $yMoveLocation
    case .z:
      return $zMoveLocation
    }
  }
  
  func displacementMode(for dimension: PrinterController.Dimension) -> Binding<DisplacementMode?> {
    switch dimension {
    case .x:
      return $printerController.xpsq8State.xDisplacementMode
    case .y:
      return $printerController.xpsq8State.yDisplacementMode
    case .z:
      return $printerController.xpsq8State.zDisplacementMode
    }
  }
}

// MARK: Previews
struct ManualControlView_Previews: PreviewProvider {
  static var previews: some View {
    ManualControlView()
      .padding()
			.environmentObject(PrinterController.staticPreview)
  }
}
