//
//  ManualStageView.swift
//  Fifi
//
//  Created by Connor Barnes on 12/30/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct ManualStageView: View {
	let dimension: PrinterController.Dimension
	@Binding var jogLocation: Double
	@Binding var moveLocation: Double
	@Binding var displacementMode: DisplacementMode?
	@EnvironmentObject private var printerController: PrinterController
	
	var body: some View {
		HStack {
			// Use another HStack to right alight the positions
			HStack(spacing: 0) {
				Text("\(dimension.rawValue):")
				Spacer()
				positionText(for: dimension)
					.font(.body.monospacedDigit())
			}
			.frame(width: 90)
			
			Spacer()
				.frame(width: 20)
			
			Button("Jog") {
				Task {
					let offset = jogLocation
					logger.info("Jogging \(dimension.rawValue) by \(offset)")
					await logger.tryOrError {
						try await printerController.moveRelative(in: dimension, by: offset)
					} errorString: { error in
						"Could not jog by \(offset) in \(dimension.rawValue): \(error)"
					}
				}
			}
			.foregroundColor(.accentColor)
			.disabled(!canMove)
            
            TextField("", value: $jogLocation, format:  FloatingPointFormatStyle
                .number
                .precision(.fractionLength(4)))
                .font(.body.monospacedDigit())
                .multilineTextAlignment(.trailing)
			
			ValidatingTextField(
				"\(dimension.rawValue) position",
				value: $jogLocation,
				showError: true
			) { value in
				Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
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
					let location = moveLocation
					logger.info("Move \(dimension.rawValue) to \(location)")
					await logger.tryOrError {
						try await printerController.moveAbsolute(in: dimension, to: location)
					} errorString: { error in
						"Could not move to \(location) in \(dimension.rawValue): \(error)"
					}
				}
			}
			.foregroundColor(.accentColor)
			.disabled(!canMove)
			
			ValidatingTextField(
				"\(dimension.rawValue) position",
				value: $moveLocation,
				showError: true
			) { value in
				Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
			} validate: { string in
				Double(string)
			} errorMessage: { _ in
				"Value must be a number"
			}
			.font(.body.monospacedDigit())
			.multilineTextAlignment(.trailing)
			
			Menu(displacementMode?.description ?? "") {
				ForEach(DisplacementMode.allCases, id: \.description) { mode in
					Button(mode.description) {
						displacementMode = mode
					}
				}
			}
//			.id(UUID())
		}
	}
    
    var numberTextFieldStyle: FloatingPointFormatStyle<Double> {
        let numberFormatter = FloatingPointFormatStyle<Double>()
        _ = numberFormatter.precision(.fractionLength(4))
        return numberFormatter
    }
}

// MARK: Helpers
private extension ManualStageView {
	var canMove: Bool {
    [.ready, .reading].contains(printerController.xpsq8ConnectionState)
    && ![nil, .moving].contains(printerController.xpsq8State.groupStatus)
	}
	
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		
		return formatter
	}()
	
	func positionText(for dimension: PrinterController.Dimension) -> Text {
    if let position = position(for: dimension) {
      return Text("\(position, format: .number.precision(.fractionLength(3)))mm")
    } else {
      return Text("?mm")
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
}

// MARK: Previews
struct ManualStageView_Previews: PreviewProvider {
	static var previews: some View {
		ManualStageView(dimension: .x,
										jogLocation: .constant(0),
										moveLocation: .constant(0),
										displacementMode: .constant(.medium))
	}
}
