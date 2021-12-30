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
  
  @State var targetVoltage = 0.0
  @State var targetVoltageOffset = 0.0
  @State var targetFrequency = 0.0
  @State var targetPhase = 0.0
  @State var targetWaveFunction: WaveFunction = .sin
  
  var body: some View {
    VStack {
      HStack {
        Text("Voltage: \(voltageString)")
        
        ValidatingTextField("Voltage", value: $targetVoltage) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setVoltage(to: targetVoltage)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Voltage Offset: \(voltageOffsetString)")
        
        ValidatingTextField("Voltage Offset", value: $targetVoltageOffset) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setVoltageOffset(to: targetVoltageOffset)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
      
      HStack {
        Text("Frequency: \(frequencyString)")
        
        ValidatingTextField("Frequency", value: $targetFrequency) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
        
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
        Text("Phase: \(phaseString)")
        
        ValidatingTextField("Phase", value: $targetPhase) { value in
          "\(value)"
        } validate: { string in
          Double(string)
        }
        
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
//        .id(UUID())
        
        Button("Set") {
          Task {
            await logger.tryOrError {
              try await printerController.setWaveFunction(to: targetWaveFunction)
            }
          }
        }
        .foregroundColor(.accentColor)
      }
    }
  }
}

// MARK: - Helpers
extension ManualVoltageControlView {
  var voltageString: String {
    stringOfQuestionMarkIfOptional(printerController.waveformState.voltage)
  }
  
  var voltageOffsetString: String {
    stringOfQuestionMarkIfOptional(printerController.waveformState.voltageOffset)
  }
  
  var frequencyString: String {
    stringOfQuestionMarkIfOptional(printerController.waveformState.frequency)
  }
  
  var phaseString: String {
    stringOfQuestionMarkIfOptional(printerController.waveformState.phase)
  }
  
  var waveFunctionString: String {
    stringOfQuestionMarkIfOptional(printerController.waveformState.waveFunction?.rawValue)
  }
  
  func stringOfQuestionMarkIfOptional<T>(_ value: T?) -> String {
    if let value = value {
      return "\(value)"
    } else {
      return "?"
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
