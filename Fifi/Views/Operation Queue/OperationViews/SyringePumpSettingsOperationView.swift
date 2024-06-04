import SwiftUI

struct SyringePumpSettingsOperationView: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    
    var body: some View {
        VStack {
            Text("Syringe Pump Network")
                .font(.title2)
                .padding(.top, 30)
            
            HStack {
                Text("Port")
                Button(action: {
                    // Handle port change action here if needed
                }) {
                    Text("Connect/Disconnect")
                }
            }
            
            HStack {
                VStack {
                    Text("Syringe Pump 1").font(.title2).padding(.top, -5)
                    Form {
                        Toggle("Update Rate 1", isOn: updateRate1)
                        if updateRate1.wrappedValue {
                            HStack {
                                Text("Rate 1:")
                                TextField("Rate", value: $configuration.flowRate1, format: .number)
                            }
                        }
                        
                        Picker("Units", selection: $configuration.units1) {
                            ForEach(SyringePumpController.flowRateUnits1.allCases, id: \.self) { unit1 in
                                Text(unit1.rawValue).tag(unit1)
                            }
                        }
                        
                        Toggle(isOn: $configuration.enable1) {
                            Text("Enable Pump 1")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
                
                VStack {
                    Text("Syringe Pump 2").font(.title2).padding(.top, -5)
                    Form {
                        Toggle("Update Rate 2", isOn: updateRate2)
                        if updateRate2.wrappedValue {
                            HStack {
                                Text("Rate 2:")
                                TextField("Rate", value: $configuration.flowRate2, format: .number)
                            }
                        }
                        
                        Picker("Units", selection: $configuration.units2) {
                            ForEach(SyringePumpController.flowRateUnits2.allCases, id: \.self) { unit2 in
                                Text(unit2.rawValue).tag(unit2)
                            }
                        }
                        
                        Toggle(isOn: $configuration.enable2) {
                            Text("Enable Pump 2")
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
            }
        }
    }
    
    var updateRate1: Binding<Bool> {
        Binding {
            configuration.flowRate1 != nil
        } set: { newValue in
            if newValue {
                configuration.flowRate1 = "0.0"
            } else {
                configuration.flowRate1 = nil
            }
        }
    }
    
    var updateRate2: Binding<Bool> {
        Binding {
            configuration.flowRate2 != nil
        } set: { newValue in
            if newValue {
                configuration.flowRate2 = "0.0"
            } else {
                configuration.flowRate2 = nil
            }
        }
    }
}

// MARK: - Previews
struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(SyringePumpSettingsConfiguration()))
            .padding()
    }
}
