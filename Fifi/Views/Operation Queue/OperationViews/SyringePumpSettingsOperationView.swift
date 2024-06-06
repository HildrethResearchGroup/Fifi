import SwiftUI

struct SyringePumpView1: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    
    var body: some View {
        VStack {
            Text("Syringe Pump 1")
                .font(.title2)
                .padding(.top, 30)
            
            Toggle("Update Rate 1", isOn: updateRate1)
            if let updateRate1 = configuration.flowRate1 {
                HStack {
                    Text("Rate 1:")
                    TextField("Rate", value: $configuration.flowRate1, format: .number)
                        .frame(maxWidth: 100) // Set maximum width here
                }
                Menu {
                                Button("mL/hr") {
                                    configuration.units1 = "MH"
                                }
                                
                                Button("mL/min") {
                                    configuration.units1 = "MM"
                                }
                                
                                Button("uL/hr") {
                                    configuration.units1 = "UH"
                                }
                                
                                Button("uL/min") {
                                    configuration.units1 = "UM"
                                }
                            } label: {
                                Text(configuration.units1 == "MH" ? "mL/hr" :
                                     configuration.units1 == "MM" ? "mL/min" :
                                     configuration.units1 == "UH" ? "uL/hr" :
                                     configuration.units1 == "UM" ? "uL/min" : "Select units")
                                  //  .foregroundColor(.black)
                            }
                            .border(Color.gray, width: 1) // Border color and width
                            .frame(maxWidth: 100) // Max width
            }
            
           
            
            Toggle("Update ID 1", isOn: updateID1)
            if let updateID1 = configuration.id1 {
                HStack {
                    Text("ID 1:")
                    TextField("ID", value: $configuration.id1, format: .number)
                        .frame(maxWidth: 100) // Set maximum width here
                }
            }
            
//            if let units1 = configuration.units1 {
//                Picker("Units", selection: $configuration.units1) {
//                    Text(units1).tag(units1)
//                }
//            }
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
    
    var updateID1: Binding<Bool> {
        Binding {
            configuration.id1 != nil
        } set: { newValue in
            if newValue {
                configuration.id1 = 0.0 // Assuming id1 is of type Double
            } else {
                configuration.id1 = nil
            }
        }
    }
}

struct SyringePumpView2: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    
    var body: some View {
        VStack {
            Text("Syringe Pump 2")
                .font(.title2)
                .padding(.top, 30)
            
            Toggle("Update Rate 2", isOn: updateRate2)
            if let updateRate2 = configuration.flowRate2 {
                HStack {
                    Text("Rate 2:")
                    TextField("Rate", value: $configuration.flowRate2, format: .number)
                        .frame(maxWidth: 100) // Set maximum width here
                }
                Menu {
                                Button("mL/hr") {
                                    configuration.units2 = "MH"
                                }
                                
                                Button("mL/min") {
                                    configuration.units2 = "MM"
                                }
                                
                                Button("uL/hr") {
                                    configuration.units2 = "UH"
                                }
                                
                                Button("uL/min") {
                                    configuration.units2 = "UM"
                                }
                            } label: {
                                Text(configuration.units2 == "MH" ? "mL/hr" :
                                     configuration.units2 == "MM" ? "mL/min" :
                                     configuration.units2 == "UH" ? "uL/hr" :
                                     configuration.units2 == "UM" ? "uL/min" : "Select units")
                                  //  .foregroundColor(.black)
                            }
                            .border(Color.gray, width: 1) // Border color and width
                            .frame(maxWidth: 100) // Max width
            }
            
           
                    
            Toggle("Update ID 2", isOn: updateID2)
            if let updateID2 = configuration.id2 {
                HStack {
                    Text("ID 2:")
                    TextField("ID", value: $configuration.id2, format: .number)
                        .frame(maxWidth: 100) // Set maximum width here
                }
            }
            
//            if let units2 = configuration.units2 {
//                Picker("Units", selection: $configuration.units2) {
//                    Text(units2).tag(units2)
//                }
//            }
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
    
    var updateID2: Binding<Bool> {
        Binding {
            configuration.id2 != nil
        } set: { newValue in
            if newValue {
                configuration.id2 = 0.0 // Assuming id2 is of type Double
            } else {
                configuration.id2 = nil
            }
        }
    }
}

struct SyringePumpSettingsOperationView: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    
    var body: some View {
            VStack {
                Text("Syringe Pump Network")
                    .font(.title2)
                    .padding(.top, 20)
                
                HStack(spacing: 30) { // Added spacing between views
                    SyringePumpView1(configuration: $configuration)
                    SyringePumpView2(configuration: $configuration)
                }
                .padding(.horizontal, 20) // Added horizontal padding
            }
        }
}




struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(SyringePumpSettingsConfiguration()))
            .padding()
    }
}
