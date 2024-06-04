import SwiftUI

struct SyringePumpSettingsOperationView: View {
    @Binding var configuration: SyringePumpSettingsConfiguration

    let width: CGFloat
    let height: CGFloat
    let color: Color

    @ObservedObject var controller: SyringePumpController
    @State private var enable1: Bool = false
    @State private var enable2: Bool = false

    init(configuration: Binding<SyringePumpSettingsConfiguration>,
         width: CGFloat = 1,
         height: CGFloat = 140,
         color: Color = .gray) {
        self._configuration = configuration
        self.width = width
        self.height = height
        self.color = color
     
    }

    var body: some View {
        VStack {
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)

            Text("Syringe Pump Network").font(.title2).padding(.top, 30)

            HStack {
                Text("Port")
                Button(action: { controller.connectOrDisconnect() }) {
                    Text(controller.nextPortState)
                }
                Toggle(isOn: Binding(
                    get: { self.controller.nextPumpState == .stopPumping1 && self.controller.nextPumpState2 == .stopPumping2 },
                    set: { value in
                        if value {
                            self.controller.startOrStopPumping1(pump: "00")
                            self.controller.startOrStopPumping2(pump: "01")
                        } else {
                            self.controller.stopPumping1(pump: "00")
                            self.controller.stopPumping2(pump: "01")
                        }
                    }
                )) {
                    Text(self.controller.nextPumpState == .startPumping1 && self.controller.nextPumpState2 == .startPumping2 ? "Start Both Pumps" : "Stop Both Pumps")
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }

            HStack {
                VStack {
                    Text("Syringe Pump 1").font(.title2).padding(.top, -5)
                    Form {
                        // Flow Rate
                        HStack {
                            TextField("Flow Rate", text: $controller.flowRate1)
                        }
                        // Units
                        Picker("Units", selection: $controller.units1) {
                            ForEach(SyringePumpController.flowRateUnits1.allCases, id: \.self) { unit1 in
                                Text(unit1.rawValue).tag(unit1)
                            }
                        }
                        // Enable Toggle
                        Toggle(isOn: $enable1) {
                            Text("Enable Pump 1")
                        }
                        .onChange(of: enable1) { value in
                            if value {
                                controller.startPumping1(pump: "00")
                            } else {
                                controller.stopPumping1(pump: "00")
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
                VStack {
                    Text("Syringe Pump 2").font(.title2).padding(.top, -5)
                    Form {
                        // Flow Rate
                        HStack {
                            TextField("Flow Rate", text: $controller.flowRate2)
                        }
                        // Units
                        Picker("Units", selection: $controller.units2) {
                            ForEach(SyringePumpController.flowRateUnits2.allCases, id: \.self) { unit2 in
                                Text(unit2.rawValue).tag(unit2)
                            }
                        }
                        // Enable Toggle
                        Toggle(isOn: $enable2) {
                            Text("Enable Pump 2")
                        }
                        .onChange(of: enable2) { value in
                            if value {
                                controller.startPumping2(pump: "01")
                            } else {
                                controller.stopPumping2(pump: "01")
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
            }
        }
    }
}


private extension SyringePumpSettingsOperationView {
  var updateRate1: Binding<Bool> {
    Binding {
      configuration.flowRate1 != nil
    } set: { newValue in
      if newValue {
        configuration.flowRate1 = 0.0
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
        configuration.flowRate2 = 0.0
      } else {
        configuration.flowRate2 = nil
      }
    }
  }
  
  var updateInnerDiam1: Binding<Bool> {
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
  
  var updateInnerDiam2: Binding<Bool> {
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
  
    var updateEnable1: Binding<Bool> {
        Binding {
            configuration.enable1 != nil
        } set: { newValue in
            if newValue {
                configuration.enable1 = 0.0
            } else {
                configuration.enable1 = nil
            }
        }
    }
    var updateEnable2: Binding<Bool> {
        Binding {
            configuration.enable2 != nil
        } set: { newValue in
            if newValue {
                configuration.enable2 = 0.0
            } else {
                configuration.enable2 = nil
            }
        }
    }
    
}

// MARK: - Previews
struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(.init()))
            .padding()
    }
}
