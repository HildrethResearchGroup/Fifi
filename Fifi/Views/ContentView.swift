//
//  ContentView.swift
//  Fifi
//
//  Created by Connor Barnes on 6/17/21.
//

import SwiftUI
import SeeayaUI
import PrinterController

struct ContentView: View {
  @EnvironmentObject private var printerController: PrinterController
  
  @AppStorage("waveformAddress") private var waveformAddress = "0.0.0.0"
  @AppStorage("waveformPort") private var waveformPort = 0
  @AppStorage("xpsq8Address") private var xpsq8Address = "0.0.0.0"
  @AppStorage("xpsq8Port") private var xpsq8Port = 0
  
  @ObservedObject private var logger = Fifi.logger
  
  var body: some View {
    VStack(spacing: 0) {
      HStack {
        Spacer()
        Divider()
        
        VStack {
          ManualControlView()
            .frame(width: 500)
            .padding()
          Spacer()
        }
      }
      
      Divider()
      
      bottomBar
    }
    .toolbar {
      toolbarContent
    }
  }
}

// MARK: - Subviews
private extension ContentView {
  @ViewBuilder
  var bottomBar: some View {
    HStack {
      if let lastLog = logger.lastLogOfLevelOrHigher[.warning] {
        HStack {
          Spacer()
            .frame(width: 4)
          
          lastLog.icon
          
          Text(lastLog.message)
        }
        .transition(.slide.combined(with: .opacity))
        .id(lastLog)
      }
      
      Spacer()
    }
    .frame(height: 26)
    .animation(.easeInOut, value: logger.lastLogOfLevelOrHigher)
    // TODO: This isn't providing behind-window blending
    .background(Material.bar)
  }
}

// MARK: - Toolbar
private extension ContentView {
  @ViewBuilder
  var toolbarContent: some View {
    Button {
      waveformAction()
    } label: {
      Image(systemName: "waveform")
        .foregroundColor(printerController.waveformConnectionState.color)
    }
    .help(helpForInstrument(named: "Waveform generator", state: printerController.waveformConnectionState))
    
    Button {
      xpsq8Action()
    } label: {
      Image(systemName: "move.3d")
        .foregroundColor(printerController.xpsq8ConnectionState.color)
    }
    .help(helpForInstrument(named: "XPS-Q8", state: printerController.xpsq8ConnectionState))
  }
  
  func helpForInstrument(named name: String, state: CommunicationState) -> String {
    switch state {
    case .notConnected:
      return "\(name) not connected – press to connect"
    case .notInitialized:
      return "\(name) not initialized – press to initialize"
    case .connecting:
      return "\(name) connecting"
    case .busy:
      return "\(name) busy"
    case .ready, .reading:
      return "\(name) ready"
    case .blocked:
      return "\(name) blocked – this instrument is not in use but is blocked by an ongoing operation"
    }
  }
}

// MARK: - Helpers
private extension ContentView {
  func waveformAction() {
    switch printerController.waveformConnectionState {
    case .notConnected:
      Task {
        logger.info("Connecting to waveform generator at \(waveformAddress)::\(waveformPort)")
        let configuration = WaveformConfiguration(address: waveformAddress, port: waveformPort)
        await logger.tryOrError {
          try await printerController.connectToWaveform(configuration: configuration)
          logger.info("Connected to waveform generator at \(waveformAddress)::\(waveformPort)")
        } errorString: { error in
          "Could not connect to waveform generator: \(error)"
        }
      }
    case .notInitialized:
      Task {
        logger.info("Initializing waveform generator")
        await logger.tryOrError {
          try await printerController.initializeWaveform()
          logger.info("Initialized waveform generator")
        } errorString: { error in
          "Could not initialize waveform generator: \(error)"
        }
      }
    default:
      break
    }
  }
  
  func xpsq8Action() {
    switch printerController.xpsq8ConnectionState {
    case .notConnected:
      Task {
        logger.info("Connecting to XPS-Q8 at \(xpsq8Address)::\(xpsq8Port)")
        let configuration = XPSQ8Configuration(address: xpsq8Address, port: xpsq8Port)
        await logger.tryOrError {
          try await printerController.connectToXPSQ8(configuration: configuration)
          logger.info("Connected to XPS-Q8 at \(xpsq8Address)::\(xpsq8Port)")
        } errorString: { error in
          "Could not connect to XPS-Q8: \(error)"
        }
      }
    case .notInitialized:
      Task {
        logger.info("Initializing XPS-Q8")
        await logger.tryOrError {
          try await printerController.initializeXPSQ8()
          logger.info("Initialized XPS-Q8")
        } errorString: { error in
          "Could not initialize XPSQ8: \(error)"
        }
      }
    default:
      break
    }
  }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
