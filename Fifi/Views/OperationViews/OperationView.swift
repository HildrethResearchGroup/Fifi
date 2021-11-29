//
//  OperationView.swift
//  OperationView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct PrinterOperationView: View {
  @EnvironmentObject private var printerController: PrinterController
  @State private var showingConfiguration = true
  @Binding var operation: AnyPrinterOperation
  var operationIndex: Int
  
  var body: some View {
    VStack {
      header
      if showingConfiguration {
        configurationView
//          .transition(.move(edge: .top).combined(with: .opacity))
      }
    }
  }
}

// MARK: Subviews
private extension PrinterOperationView {
  @ViewBuilder
  var configurationView: some View {
    operation.body(configuration: $operation.configuration)
  }
  
  @ViewBuilder
  var header: some View {
    HStack(spacing: 0) {
      Button {
        showingConfiguration.toggle()
      } label: {
        Image(systemName: showingConfiguration ? "chevron.down" : "chevron.right")
      }
      .frame(width: 20, height: 24)
      
      Spacer()
        .frame(width: 8)
      
      Toggle(" ", isOn: $operation.isEnabled)
      Label(operation.name, systemImage: operation.thumbnailName)
        .foregroundColor(statusColor)
      
      Spacer()
      

      Image(systemName: "line.3.horizontal")
      .frame(width: 20, height: 20)
      .onDrag {
        NSItemProvider(object: NSURL(string: "fifi:operationReorder?index=\(operationIndex)")!)
      } preview: {
        Label(operation.name, systemImage: operation.thumbnailName)
          .foregroundColor(.primary)
          .frame(minWidth: 400)
      }

      Button {
        printerController.printerQueueState.queue.move(
          fromOffsets: IndexSet(integer: operationIndex),
          toOffset: operationIndex - 1
        )
      } label: {
        Image(systemName: "arrow.up")
      }
      .frame(width: 20, height: 20)
      .disabled(operationIndex == 0)
      
      Button {
        printerController.printerQueueState.queue.move(
          fromOffsets: IndexSet(integer: operationIndex),
          toOffset: operationIndex + 2
        )
      } label: {
        Image(systemName: "arrow.down")
      }
      .frame(width: 20, height: 20)
      .disabled(operationIndex == printerController.printerQueueState.queue.count - 1)
      
      Button {
        printerController.printerQueueState.queue.remove(at: operationIndex)
      } label: {
        Image(systemName: "trash")
      }
      .frame(width: 20, height: 20)
    }
    .buttonStyle(.borderless)
  }
}

// MARK: - Helpers
private extension PrinterOperationView {
  var statusColor: Color {
    guard operation.isEnabled else { return .secondary }
    guard let runningOperationIndex = printerController.printerQueueState.operationIndex else {
      return .primary
    }
    
    if runningOperationIndex > operationIndex {
      return .green
    } else if runningOperationIndex < operationIndex {
      return .primary
    } else {
      return .blue
    }
  }
}

// MARK: Previews
struct PrinterOperationView_Previews: PreviewProvider {
  static var previews: some View {
    PrinterOperationView(
      operation: .constant(
        AnyPrinterOperation(
          .voltageToggleOperation(body: VoltageToggleOperationView.init)
        )
      ),
      operationIndex: 1
    )
			.environmentObject(PrinterController.staticPreview)
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
