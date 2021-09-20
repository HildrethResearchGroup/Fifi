//
//  OperationView.swift
//  OperationView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct PrinterOperationView: View {
  @State private var showingConfiguration = true
  @Binding var queue: [PrinterOperation]
  @Binding var operation: PrinterOperation
  var operationIndex: Int
  
  var body: some View {
    VStack {
      header
      if showingConfiguration {
        configurationView
          .transition(.move(edge: .top).combined(with: .opacity))
      }
    }
  }
}

// MARK: Subviews
private extension PrinterOperationView {
  @ViewBuilder
  var configurationView: some View {
    switch operation.operationType {
    case .voltageToggle:
      VoltageToggleOperationView(configuration: $operation.voltageConfiguration)
    }
  }
  
  @ViewBuilder
  var header: some View {
    HStack(spacing: 0) {
      Button {
        showingConfiguration.toggle()
      } label: {
        Image(systemName: showingConfiguration ? "chevron.down" : "chevron.right")
      }
      
      Spacer()
        .frame(width: 8)
      
      Label(operation.operationType.name,
            systemImage: operation.operationType.thumbnailImageName)
        .foregroundColor(.primary)
      
      Spacer()
      
      Button {
        queue.move(fromOffsets: IndexSet(integer: operationIndex),
                   toOffset: operationIndex - 1)
      } label: {
        Image(systemName: "arrow.up")
      }
      .frame(width: 20, height: 20)
      .disabled(operationIndex == 0)
      
      Button {
        queue.move(fromOffsets: IndexSet(integer: operationIndex),
                   toOffset: operationIndex + 2)
      } label: {
        Image(systemName: "arrow.down")
      }
      .frame(width: 20, height: 20)
      .disabled(operationIndex == queue.count - 1)
      
      Button {
        queue.remove(at: operationIndex)
      } label: {
        Image(systemName: "trash")
      }
      .frame(width: 20, height: 20)
    }
    .buttonStyle(.borderless)
  }
}

// MARK: Previews
struct PrinterOperationView_Previews: PreviewProvider {
  static var previews: some View {
    PrinterOperationView(
      queue: .constant(
        .init(repeating: PrinterOperation(operationType: .voltageToggle(.init())),
              count: 3)
      ),
      operation: .constant(
        PrinterOperation(operationType: .voltageToggle(.init()))
      ),
      operationIndex: 1
    )
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
