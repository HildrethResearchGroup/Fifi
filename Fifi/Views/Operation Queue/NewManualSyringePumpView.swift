import SwiftUI

struct CustomVerticalDivider: View {
    let width: CGFloat
    let height: CGFloat
    let color: Color
    
    init(width: CGFloat = 1, height: CGFloat = 20, color: Color = .gray) {
        self.width = width
        self.height = height
        self.color = color
    }
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: width, height: height)
    }
}

struct NewManualSyringePumpView: View {
    @EnvironmentObject private var printerController: PrinterController

    //@ObservedObject var controller: NewManualSyringePumpController
    
    @State private var enable1: Bool = false
    @State private var enable2: Bool = false

    var body: some View {
        VStack {
 
            HStack {
                Toggle(isOn: Binding(
                    get: { self.printerController.dualStart },
                    set: { newValue in
                        self.printerController.dualChange()
                        switch (enable1, enable2) {
                        case (true, false):
                            self.printerController.startOrStopPumping1(pump: "00")
                        case (true, true):
                            self.printerController.startOrStopPumping1(pump: "00")
                            self.printerController.startOrStopPumping2(pump: "01")
                        case (false, true):
                            self.printerController.startOrStopPumping2(pump: "01")
                        default:
                            break
                        }
                    }
                )) {
                    Text(self.printerController.nextPumpState == .startPumping1 ? "Start Both Pumps" : "Stop Both Pumps")
                        .font(.system(size: 16)) // Change the font size here
                }
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            }
            
            HStack {
                VStack {
                    Text("Pump 1")
                        .font(.system(size: 15)) // Change the font size here
                        .padding(.top, -5)
                    
                    Form {
                        // Select units
                        VStack {
                            TextField("Flow Rate", text: $printerController.flowRate)
                                .frame(width: 100) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                            TextField("Diameter", text: self.$printerController.id1)
                                .frame(width: 115) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                        }
                        Picker("Units", selection: $printerController.units) {
                            ForEach(NewManualSyringePumpController.flowRateUnits.allCases) { unit in
                                Text(unit.rawValue)
                                    .tag(unit)
                            }
                        }
                        .font(.system(size: 12))
                        .frame(width: 124) // Set desired width here
                        .clipped() // Ensure the picker does not expand beyond this width
                        
                        Toggle(isOn: Binding(
                            get: { enable1 },
                            set: { newValue in
                                enable1 = newValue
                                if newValue {
                                    print("Enable1: \(enable1)")
                                    if self.controller.dualStart {
                                        self.controller.startOrStopPumping1(pump: "00")
                                    }
                                } else {
                                    print("Enable1: \(enable1)")
                                    if self.controller.dualStart {
                                        self.controller.startOrStopPumping1(pump: "00")
                                    }
                                }
                            }
                        ))
                        
                        
                        {
                            Text("Enable Pump 1")
                                .font(.system(size: 12)) // Change the font size here
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        Text("Volume Dispensed: ")
                            .font(.system(size: 12)) // Change the font size here

                        
                        Text(printerController.subString)
                            .font(.system(size: 12)) // Change the font size here
                    
                    }
                }
                
                
                CustomVerticalDivider(width: 1, height: 140, color: .gray)
                
                VStack {
                    Text("Pump 2")
                        .font(.system(size: 15)) // Change the font size here
                        .padding(.top, -5)
                    
                    Form {
                        // Select units
                        VStack {
                            TextField("Flow Rate", text: $printerController.flowRate2)
                                .frame(width: 100) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                            TextField("Diameter", text: $printerController.id2)
                                .frame(width: 115) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                        }
                        Picker("Units", selection: $printerController.units2) {
                            ForEach(printerController.flowRateUnits2.allCases) { unit2 in
                                Text(unit2.rawValue)
                                    .tag(unit2)
                            }
                        }
                        .font(.system(size: 12))
                        .frame(width: 124) // Set desired width here
                        .clipped() // Ensure the picker does not expand beyond this width
                        
                        Toggle(isOn: Binding(
                            get: { enable2 },
                            set: { newValue in
                                enable2 = newValue
                                if newValue {
                                    print("Enable2: \(enable2)")
                                    if self.printerController.dualStart {
                                        self.printerController.startOrStopPumping2(pump: "01")
                                    }
                                } else {
                                    print("Enable2: \(enable2)")
                                    if self.printerController.dualStart {
                                        self.printerController.startOrStopPumping2(pump: "01")
                                    }
                                }
                            }
                        )) {
                            Text("Enable Pump 2")
                                .font(.system(size: 12)) // Change the font size here
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        Text("Volume Dispensed: ")
                            .font(.system(size: 12)) // Change the font size here

                        
                        Text(printerController.subString)
                            .font(.system(size: 12)) // Change the font size here
                    }
                }
            }
        }
    }
}

//struct NewSyringePumpView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewManualSyringePumpView(controller: NewManualSyringePumpController())
//    }
//}
