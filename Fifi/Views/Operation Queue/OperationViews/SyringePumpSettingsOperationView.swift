import SwiftUI
struct SyringePumpSettingsOperationView: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    
    var body: some View {
        VStack {
            Text("Syringe Pump Network")
                .font(.title2)
                .padding(.top, 30)
            
            HStack {
                VStack {
                    Text("Syringe Pump 1").font(.title2).padding(.top, -5)
                    Toggle("Update Rate 1", isOn: updateRate1)
                    if let updateRate1Value = configuration.flowRate1 {
                        HStack {
                            Text("Rate 1:")
                            TextField("Rate", value: $configuration.flowRate1, format: .number)
                        }
                    }
                    
                    if let units1 = configuration.units1 {
                        Picker("Units", selection: $configuration.units1) {
                            Text(units1).tag(units1)
                        }
                    }
                    
                    VStack {
                        Text("Syringe Pump 2").font(.title2).padding(.top, -5)
                        Toggle("Update Rate 2", isOn: updateRate2)
                        if let updateRate2Value = configuration.flowRate2 {
                            HStack {
                                Text("Rate 2:")
                                TextField("Rate", value: $configuration.flowRate2, format: .number)
                            }
                        }
                        
                        if let units2 = configuration.units2 {
                            Picker("Units", selection: $configuration.units2) {
                                Text(units2).tag(units2)
                            }
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
                    configuration.flowRate1 = 0.0 // Assuming flowRate1 is of type Double
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
                    configuration.flowRate2 = 0.0 // Assuming flowRate2 is of type Double
                } else {
                    configuration.flowRate2 = nil
                }
            }
        }
    }
}

struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(SyringePumpSettingsConfiguration()))
            .padding()
    }
}
