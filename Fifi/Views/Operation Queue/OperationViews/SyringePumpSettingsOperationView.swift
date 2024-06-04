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
                // This button might need to trigger a configuration change or notify the controller in some way
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
                        HStack {
                            TextField("Flow Rate", text: $configuration.flowRate1)
                        }
                        Picker("Units", selection: $configuration.units1) {
                            ForEach(SyringePumpController.flowRateUnits1.allCases) { unit1 in
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
                        HStack {
                            TextField("Flow Rate", text: $configuration.flowRate2)
                        }
                        Picker("Units", selection: $configuration.units2) {
                            ForEach(SyringePumpController.flowRateUnits2.allCases) { unit2 in
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
}

// MARK: - Previews
struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(SyringePumpSettingsConfiguration()))
            .padding()
    }
}
