//
//  OperationQueueView.swift
//  OperationQueueView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct OperationQueueView: View {
  @Binding var operationQueue: [PrinterOperation]
  
  var body: some View {
    VStack {
      heading
      
      List($operationQueue) { $operation in
        PrinterOperationView(queue: $operationQueue,
                             operation: $operation,
                             operationIndex: operationQueue.firstIndex(of: operation)!)
      }
      .listStyle(.plain)
    }
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
        ForEach(0..<PrinterOperation.allEmptyOperations.count) { index in
          let templateOperation = PrinterOperation.allEmptyOperations[index]
          
          Button() {
            operationQueue.append(templateOperation)
          } label: {
            HStack {
              Image(systemName: templateOperation.operationType.thumbnailImageName)
              Text(templateOperation.operationType.name)
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
    OperationQueueView(operationQueue: .constant([
      .init(operationType: .voltageToggle(.init())),
      .init(operationType: .voltageToggle(.init())),
      .init(operationType: .voltageToggle(.init())),
      .init(operationType: .voltageToggle(.init())),
      .init(operationType: .voltageToggle(.init()))
    ]))
      .padding()
  }
}
