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
    //MARK: State vars
    @State var nextPortState: String = "Connect"
    @State var startPumping1: Bool = true
    @State var startPumping2: Bool = true
    
    @State var id1: String = "10"
    @State var id2: String = "10"
    @State var amntDisp1: String = ""
    @State var amntDisp2: String = ""

    
    @State var units: flowRateUnits = .nL_min
    @State var units2: flowRateUnits2 = .nL_min
    
    @State var pumpNum: pumpNumber = .p0
    
    @State var flowRate: String = "20"
    @State var flowRate2: String = "20"
    
    @State var pump: String = "00"
    @State var dualStart: Bool = false
    @State var subString: String = ""
    
    //MARK: ENUMS
    enum pumpNumber: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case p0 = "Pump 1"
        case p1 = "Pump 2"
        
        var queryString: String {
            switch self {
            case .p0: return "00"
            case .p1: return "01"
            }
        }
    }

    enum flowRateUnits: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case mm_hr = "ml / hr"
        case uL_hr = "µl / hr"
        case nL_hr = "nl / hr"
        case mm_min = "ml / min"
        case uL_min = "µl / min"
        case nL_min = "nl / min"
        
        var queryString: String {
            switch self {
            case .mm_hr: return "MH"
            case .uL_hr: return "UH"
            case .nL_hr: return "NH"
            case .mm_min: return "MM"
            case .uL_min: return "UM"
            case .nL_min: return "NM"
            }
        }
    }
    enum flowRateUnits2: String, CaseIterable, Identifiable {
        var id: Self { self }
        
        case mm_hr = "ml / hr"
        case uL_hr = "µl / hr"
        case nL_hr = "nl / hr"
        case mm_min = "ml / min"
        case uL_min = "µl / min"
        case nL_min = "nl / min"
        
        var queryString2: String {
            switch self {
            case .mm_hr: return "MH"
            case .uL_hr: return "UH"
            case .nL_hr: return "NH"
            case .mm_min: return "MM"
            case .uL_min: return "UM"
            case .nL_min: return "NM"
            }
        }
    }

    @EnvironmentObject var printerController: PrinterController

    //@ObservedObject var controller: NewManualSyringePumpController
    @State private var enable1: Bool = false
    @State private var enable2: Bool = false

    var body: some View {    //MARK: State vars

        VStack {
 
            HStack {
                Toggle(isOn: Binding(
                    get: { self.dualStart},
                    set: { newValue in
                        Task {
                            self.dualStart = !dualStart
                            switch (enable1, enable2) {
                            case (true, false):
                                if startPumping1 {
                                    try await printerController.sendAllSettings(pump: "00", rate: flowRate, ID: id1, units: units.queryString)
                                }
                                try await printerController.startOrStopPumping(pump: "00", shouldStart: startPumping1)
                                if !startPumping1{
                                    amntDisp1 = try await printerController.getVolDispensed(pump: "00")
                                }
                                startPumping1 = !startPumping1
                            case (true, true):
                                if startPumping1 {
                                    try await printerController.sendAllSettings(pump: "00", rate: flowRate, ID: id1, units: units.queryString)
                                }
                                try await printerController.startOrStopPumping(pump: "00", shouldStart: startPumping1)
                                if !startPumping1{
                                    amntDisp1 = try await printerController.getVolDispensed(pump: "00")
                                }
                                startPumping1 = !startPumping1
                                
                                if startPumping2 {
                                    try await printerController.sendAllSettings(pump: "01", rate: flowRate2, ID: id2, units: units2.queryString2)
                                }
                                try await printerController.startOrStopPumping(pump: "01", shouldStart: startPumping2)
                                if !startPumping2{
                                    amntDisp2 = try await printerController.getVolDispensed(pump: "01")
                                }
                                startPumping2 = !startPumping2
                            case (false, true):
                                if startPumping2 {
                                    try await printerController.sendAllSettings(pump: "01", rate: flowRate2, ID: id2, units: units2.queryString2)
                                }
                                try await printerController.startOrStopPumping(pump: "01", shouldStart: startPumping2)
                                if !startPumping2{
                                    amntDisp2 = try await printerController.getVolDispensed(pump: "01")
                                }
                                startPumping2 = !startPumping2
                            default:
                                break
                            }
                        }
                    }
                )) {
                    Text(self.startPumping1 ? "Start Both Pumps" : "Stop Both Pumps")
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
                            TextField("Flow Rate", text: self.$flowRate)
                                .frame(width: 100) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                            TextField("Diameter", text: self.$id1)
                                .frame(width: 115) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                        }
                    Picker("Units", selection: self.$units) {
                        ForEach(NewManualSyringePumpView.flowRateUnits.allCases) { unit in
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
                                Task {
                                    enable1 = newValue
                                    if newValue {
                                        print("Enable1: \(enable1)")
                                        if self.dualStart {
                                            if startPumping1 {
                                                try await printerController.sendAllSettings(pump: "00", rate: flowRate, ID: id1, units: units.queryString)
                                            }
                                            try await printerController.startOrStopPumping(pump: "00", shouldStart: startPumping1)
                                            if !startPumping1{
                                                amntDisp1 = try await printerController.getVolDispensed(pump: "00")
                                            }
                                            startPumping1 = !startPumping1
                                        }
                                    } else {
                                        print("Enable1: \(enable1)")
                                        if self.dualStart {
                                            if startPumping1 {
                                                try await printerController.sendAllSettings(pump: "00", rate: flowRate, ID: id1, units: units.queryString)
                                            }
                                            try await printerController.startOrStopPumping(pump: "00", shouldStart: startPumping1)
                                            if !startPumping1{
                                                amntDisp1 = try await printerController.getVolDispensed(pump: "00")
                                            }
                                            startPumping1 = !startPumping1
                                        }
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

                        
                        Text(self.amntDisp1)
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
                            TextField("Flow Rate", text: self.$flowRate2)
                                .frame(width: 100) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                            TextField("Diameter", text: self.$id2)
                                .frame(width: 115) // Set desired width here
                                .fixedSize(horizontal: true, vertical: false) // Prevent expansion
                        }
                    Picker("Units", selection: self.$units2) {
                        ForEach(NewManualSyringePumpView.flowRateUnits2.allCases) { unit2 in
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
                                Task {
                                    enable2 = newValue
                                    if newValue {
                                        print("Enable2: \(enable2)")
                                        if self.dualStart {
                                            if startPumping2 {
                                                try await printerController.sendAllSettings(pump: "01", rate: flowRate2, ID: id2, units: units2.queryString2)
                                            }
                                            try await printerController.startOrStopPumping(pump: "01", shouldStart: startPumping2)
                                            if !startPumping2{
                                                amntDisp2 = try await printerController.getVolDispensed(pump: "01")
                                            }
                                            startPumping2 = !startPumping2
                                        }
                                    } else {
                                        print("Enable2: \(enable2)")
                                        if self.dualStart {
                                            if startPumping2 {
                                                try await printerController.sendAllSettings(pump: "01", rate: flowRate2, ID: id2, units: units2.queryString2)
                                            }
                                            try await printerController.startOrStopPumping(pump: "01", shouldStart: startPumping2)
                                            if !startPumping2{
                                                amntDisp2 = try await printerController.getVolDispensed(pump: "01")
                                            }
                                            startPumping2 = !startPumping2
                                        }
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

                        
                    Text(self.amntDisp2)
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
