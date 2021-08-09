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
      HStack {
        Text("\(printerController.xpsq8State.groupStatus?.rawValue.description ?? "?")")
        Spacer()
        Text("Manual Stage Control")
          .font(.title3)
        Spacer()
      }
      
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
      .disabled(![CommunicationState.ready, .reading].contains(printerController.xpsq8ConnectionState))
      
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
      .frame(width: 80)
      
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
      .disabled(![CommunicationState.ready, .reading].contains(printerController.xpsq8ConnectionState))
      
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
      .frame(width: 80)

    }
  }
}

// MARK: Helpers
private extension ManualControlView {
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
}

// MARK: Previews
struct ManualControlView_Previews: PreviewProvider {
  static var previews: some View {
    ManualControlView()
      .padding()
  }
}
