//
//  OperationQueueView.swift
//  OperationQueueView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct OperationQueueView: View {
  @EnvironmentObject private var printerController: PrinterController
  
  var body: some View {
    VStack {
      heading
      
      List(queueState.queue) { $operation in
        PrinterOperationView(
          operation: $operation,
          operationIndex: queueState.queue.wrappedValue.firstIndex(of: operation)!
        )
          
      }
      .listStyle(.plain)
    }
  }
}

// MARK: - Helpers
private extension OperationQueueView {
  var queueState: Binding<PrinterQueueState> {
    $printerController.printerQueueState
  }
}

// MARK: - Subviews
private extension OperationQueueView {
  var heading: some View {
    HStack {
      Text("Operation Queue")
        .font(.title3)
      Spacer()
      Menu {
        ForEach(0..<AnyPrinterOperation.allEmptyOperations.count) { index in
          let templateOperation = AnyPrinterOperation.allEmptyOperations[index]
          
          Button() {
            queueState.queue.wrappedValue.append(templateOperation)
          } label: {
            HStack {
              Image(systemName: templateOperation.thumbnailName)
              Text(templateOperation.name)
            }
          }
        }
      } label: {
        Image(systemName: "plus")
      }
      .menuStyle(.borderlessButton)
      .fixedSize()
    }
  }
}

// MARK: - Previews
struct OperationQueueView_Previews: PreviewProvider {
  static var previews: some View {
    OperationQueueView()
      .environmentObject(PrinterController())
      .padding()
  }
}
