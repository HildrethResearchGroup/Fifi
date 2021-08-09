//
//  ManualControlView.swift
//  ManualControlView
//
//  Created by Connor Barnes on 7/22/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct ManualControlView: View {
  @EnvironmentObject private var printerController: PrinterController
  
  @State private var xJogLocation = 0.0
  @State private var yJogLocation = 0.0
  @State private var zJogLocation = 0.0
  
  @State private var xMoveLocation = 0.0
  @State private var yMoveLocation = 0.0
  @State private var zMoveLocation = 0.0
  
  let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 3
    formatter.minimumFractionDigits = 3
    
    return formatter
  }()
  
  var body: some View {
    VStack {
      ZStack {
        Text("Manual Stage Control")
          .font(.title3)
        
        HStack {
          Spacer()
          Button("Abort Move") {
            Task {
              // FIXME: This throws error -27 (Invalid stage name)
              try await printerController.abortAllMoves()
            }
          }
          // The button style should be .automatic, but SwiftUI 3 beta is having horrible performance with it
          .buttonStyle(.plain)
          .foregroundColor(.accentColor)
          .disabled(printerController.xpsq8State.groupStatus != .moving)
        }
      }
      Text(stageStatusString)
      
      ForEach(PrinterController.Dimension.allCases, id: \.rawValue) { dimension in
        stageView(for: dimension)
      }
    }
  }
}

// MARK: Subviews
private extension ManualControlView {
  @ViewBuilder
  func stageView(for dimension: PrinterController.Dimension) -> some View {
    HStack {
      // Use another HStack to right alight the positions
      HStack(spacing: 0) {
        Text("\(dimension.rawValue):")
        Spacer()
        positionText(for: dimension)
          .font(.body.monospacedDigit())
      }
      .frame(width: 75)
      
      Spacer()
        .frame(width: 20)
      
      Button("Jog") {
        Task {
          let offset = jogLocation(for: dimension).wrappedValue
          logger.info("Jogging \(dimension.rawValue) by \(offset)")
          await logger.tryOrError {
            try await printerController.moveRelative(in: dimension, by: offset)
          } errorString: { error in
            "Could not jog by \(offset) in \(dimension.rawValue): \(error)"
          }
        }
      }
      // The button style should be .automatic, but SwiftUI 3 beta is having horrible performance with it
      .buttonStyle(.plain)
      .foregroundColor(.accentColor)
      .disabled(!canMove)
      
      ValidatingTextField(
        "\(dimension.rawValue) position",
        value: jogLocation(for: dimension),
        showError: true
      ) { value in
        numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
      } validate: { string in
        Double(string)
      } errorMessage: { _ in
        "Value must be a number"
      }
      .font(.body.monospacedDigit())
      .multilineTextAlignment(.trailing)
      
      Spacer()
        .frame(width: 20)
      
      Button("Move") {
        Task {
          let location = moveLocation(for: dimension).wrappedValue
          logger.info("Move \(dimension.rawValue) to \(location)")
          await logger.tryOrError {
            try await printerController.moveAbsolute(in: dimension, to: location)
          } errorString: { error in
            "Could not move to \(location) in \(dimension.rawValue): \(error)"
          }
        }
      }
      // The button style should be .automatic, but SwiftUI 3 beta is having horrible performance with it
      .buttonStyle(.plain)
      .foregroundColor(.accentColor)
      .disabled(!canMove)
      
      ValidatingTextField(
        "\(dimension.rawValue) position",
        value: moveLocation(for: dimension),
        showError: true
      ) { value in
        numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
      } validate: { string in
        Double(string)
      } errorMessage: { _ in
        "Value must be a number"
      }
      .font(.body.monospacedDigit())
      .multilineTextAlignment(.trailing)
      
      Menu(displacementMode(for: dimension).wrappedValue?.description ?? "") {
        ForEach(DisplacementMode.allCases, id: \.description) { mode in
          Button(mode.description) {
            displacementMode(for: dimension).wrappedValue = mode
          }
        }
      }
//      .menuStyle(.borderlessButton)
      .id(UUID())
    }
  }
}

// MARK: Helpers
private extension ManualControlView {
  var canMove: Bool {
    [.ready, .reading].contains(printerController.xpsq8ConnectionState)
    && ![nil, .moving].contains(printerController.xpsq8State.groupStatus)
  }
  
  var stageStatusString: String {
    if let status = printerController.xpsq8State.groupStatus {
      return "\(status) (\(status.rawValue))"
    } else {
      return "?"
    }
  }
  
  func position(for dimension: PrinterController.Dimension) -> Double? {
    switch dimension {
    case .x:
      return printerController.xpsq8State.xPosition
    case .y:
      return printerController.xpsq8State.yPosition
    case .z:
      return printerController.xpsq8State.zPosition
    }
  }
  
  func positionText(for dimension: PrinterController.Dimension) -> Text {
    if let position = position(for: dimension) {
      return Text("\(position, format: .number.precision(.fractionLength(3)))")
    } else {
      return Text("?")
    }
  }
  
  func jogLocation(for dimension: PrinterController.Dimension) -> Binding<Double> {
    switch dimension {
    case .x:
      return $xJogLocation
    case .y:
      return $yJogLocation
    case .z:
      return $zJogLocation
    }
  }
  
  func moveLocation(for dimension: PrinterController.Dimension) -> Binding<Double> {
    switch dimension {
    case .x:
      return $xMoveLocation
    case .y:
      return $yMoveLocation
    case .z:
      return $zMoveLocation
    }
  }
  
  func displacementMode(for dimension: PrinterController.Dimension) -> Binding<DisplacementMode?> {
    switch dimension {
    case .x:
      return $printerController.xpsq8State.xDisplacementMode
    case .y:
      return $printerController.xpsq8State.yDisplacementMode
    case .z:
      return $printerController.xpsq8State.zDisplacementMode
    }
  }
}

// MARK: Previews
struct ManualControlView_Previews: PreviewProvider {
  static var previews: some View {
    ManualControlView()
      .padding()
  }
}
