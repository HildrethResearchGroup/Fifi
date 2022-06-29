//
//  ManualVoltageControlView.swift
//  ManualVoltageControlView
//
//  Created by Connor Barnes on 8/16/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct ManualVoltageControlView: View {
  @EnvironmentObject private var printerController: PrinterController
  
	@State var targetImpedance = 1.0
  @State var targetVoltage = 0.0
  @State var targetVoltageOffset = 0.0
  @State var targetFrequency = 0.0
  @State var targetPhase = 0.0
  @State var targetWaveFunction: WaveFunction = .sin
  
  var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Impedance: \(impedanceString)")
				
				Toggle("Infinite", isOn: infiniteImpedance)
				
				
				TextField("", value: $targetImpedance, format:  appDefaultTextFieldNumberFormatter())
					.disabled(infiniteImpedance.wrappedValue)
					.appDefaultTextFieldStyle()
				
				/*
				ValidatingTextField("Impedance", value: $targetImpedance) { value in
					"\(value)"
				} validate: { string in
					Double(string)
				}
				 */
				
				
				Button("Set") {
					Task {
						await logger.tryOrError {
							try await printerController.setImpedance(to: targetImpedance)
						}
					}
				}
				.foregroundColor(.accentColor)
			}
			
      HStack {
        Text("Amplitude: \(amplifiedVoltageString)V [\(rawVoltageString)V]")
				
				TextField("", value: $targetVoltage, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
        
				/*
        ValidatingTextField("Amplitude", value: $targetVoltage) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
				 */
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setAmplifiedVoltage(to: targetVoltage)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Voltage Offset: \(amplifiedVoltageOffsetString)V [\(rawVoltageOffsetString)V]")
        
				TextField("", value: $targetVoltageOffset, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
				
				/*
        ValidatingTextField("Voltage Offset", value: $targetVoltageOffset) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
				 */
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setAmplifiedVoltageOffset(to: targetVoltageOffset)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Frequency: \(frequencyString)Hz")
        
				TextField("", value: $targetFrequency, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
				
				/*
        ValidatingTextField("Frequency", value: $targetFrequency) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
				 */
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setFrequency(to: targetFrequency)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Phase: \(phaseString)º")
        
				TextField("", value: $targetPhase, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
				
				/*
        ValidatingTextField("Phase", value: $targetPhase) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
				 */
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setPhase(to: targetPhase)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Wave Function: \(waveFunctionString)")
        
        Menu(targetWaveFunction.displayValue) {
          ForEach(WaveFunction.allCases, id: \.rawValue) { waveFunction in
            Button(waveFunction.displayValue) {
              targetWaveFunction = waveFunction
            }
          }
        }
				.frame(width: 100)
//        .id(UUID())
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setWaveFunction(to: targetWaveFunction)
            }
          }
        }
        .foregroundColor(.accentColor)
				
				Spacer()
      }
    }
  }
}

// MARK: - Helpers
extension ManualVoltageControlView {
	var impedanceString: String {
		let string = printerController.waveformState.impedance
			.flatMap { $0 == .infinity ? "∞" : "\($0)Ω" }
		return stringOrQuestionMarkIfOptional(string)
	}
	
  var rawVoltageString: String {
    stringOrQuestionMarkIfOptional(printerController.waveformState.rawVoltage)
  }
  
  var rawVoltageOffsetString: String {
    stringOrQuestionMarkIfOptional(printerController.waveformState.rawVoltageOffset)
  }
	
	var amplifiedVoltageString: String {
		stringOrQuestionMarkIfOptional(printerController.waveformState.amplifiedVoltage)
	}
  
	var amplifiedVoltageOffsetString: String {
		stringOrQuestionMarkIfOptional(printerController.waveformState.amplifiedVoltageOffset)
	}
	
  var frequencyString: String {
    stringOrQuestionMarkIfOptional(printerController.waveformState.frequency)
  }
  
  var phaseString: String {
    stringOrQuestionMarkIfOptional(printerController.waveformState.phase)
  }
  
  var waveFunctionString: String {
    stringOrQuestionMarkIfOptional(printerController.waveformState.waveFunction?.rawValue)
  }
  
  func stringOrQuestionMarkIfOptional<T>(_ value: T?) -> String {
    if let value = value {
      return "\(value)"
    } else {
      return "?"
    }
  }
	
	var infiniteImpedance: Binding<Bool> {
		.init {
			targetImpedance == .infinity
		} set: { value in
			if value {
				targetImpedance = .infinity
			} else {
				// Don't set target impedance if it is already finite
				if !targetImpedance.isFinite {
					targetImpedance = 1.0
				}
			}
		}
	}
	
}

// MARK: - Previews
struct ManualVoltageControlView_Previews: PreviewProvider {
  static var previews: some View {
    ManualVoltageControlView()
			.environmentObject(PrinterController.staticPreview)
  }
}
