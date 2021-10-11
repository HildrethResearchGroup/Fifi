//
//  WaveformSettingsOperationView.swift
//  WaveformSettingsOperationView
//
//  Created by Connor Barnes on 9/20/21.
//

import SwiftUI
import SeeayaUI
import PrinterController

struct WaveformSettingsOperationView: View {
  @Binding var configuration: WaveformSettingsConfiguration
  
  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Toggle("Update Frequency", isOn: updateFrequency)
        
        if updateFrequency.wrappedValue {
          HStack {
            Text("Frequency: ")
            ValidatingTextField<Double?>("Frequency", value: $configuration.frequency) { value in
              if let value = value {
                return String(value)
              } else {
                return "nil"
              }
            } validate: { string in
              Double(string)
            }
          }
        }
        
        Toggle("Update Amplitude", isOn: updateAmplitude)
        
        if updateAmplitude.wrappedValue {
          HStack {
            Text("Amplitude: ")
            ValidatingTextField<Double?>("Amplitude", value: $configuration.amplitude) { value in
              if let value = value {
                return String(value)
              } else {
                return "nil"
              }
            } validate: { string in
              Double(string)
            }
          }
        }
        
        Toggle("Update Offset", isOn: updateOffset)
        
        if updateOffset.wrappedValue {
          HStack {
            Text("Offset: ")
            ValidatingTextField<Double?>("Offset", value: $configuration.offset) { value in
              if let value = value {
                return String(value)
              } else {
                return "nil"
              }
            } validate: { string in
              Double(string)
            }
          }
        }
        
        Toggle("Update Phase", isOn: updatePhase)
        
        if updatePhase.wrappedValue {
          HStack {
            Text("Phase: ")
            ValidatingTextField<Double?>("Phase", value: $configuration.phase) { value in
              if let value = value {
                return String(value)
              } else {
                return "nil"
              }
            } validate: { string in
              Double(string)
            }
          }
        }
        
        
        
        
      }
      .textFieldStyle(.squareBorder)
      Spacer()
    }
  }
}

// MARK: - Helpers
private extension WaveformSettingsOperationView {
  var updateAmplitude: Binding<Bool> {
    Binding {
      configuration.amplitude != nil
    } set: { newValue in
      if newValue {
        configuration.amplitude = 0.0
      } else {
        configuration.amplitude = nil
      }
    }
  }
  
  var updatePhase: Binding<Bool> {
    Binding {
      configuration.phase != nil
    } set: { newValue in
      if newValue {
        configuration.phase = 0.0
      } else {
        configuration.phase = nil
      }
    }
  }
  
  var updateFrequency: Binding<Bool> {
    Binding {
      configuration.frequency != nil
    } set: { newValue in
      if newValue {
        configuration.frequency = 0.0
      } else {
        configuration.frequency = nil
      }
    }
  }
  
  var updateOffset: Binding<Bool> {
    Binding {
      configuration.offset != nil
    } set: { newValue in
      if newValue {
        configuration.offset = 0.0
      } else {
        configuration.offset = nil
      }
    }
  }
  
  var updateWaveFunction: Binding<Bool> {
    Binding {
      configuration.waveFunction != nil
    } set: { newValue in
      if newValue {
        configuration.waveFunction = .sin
      } else {
        configuration.waveFunction = nil
      }
    }
  }
}

// MARK: - Previews
struct WaveformSettingsOperationView_Previews: PreviewProvider {
  static var previews: some View {
    WaveformSettingsOperationView(configuration: .constant(.init()))
      .padding()
  }
}