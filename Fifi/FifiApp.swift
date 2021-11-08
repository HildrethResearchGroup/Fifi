//
//  FifiApp.swift
//  Fifi
//
//  Created by Connor Barnes on 6/17/21.
//

import SwiftUI
import PrinterController

@main
struct FifiApp: App {
  init() {
    AnyPrinterOperation.DynamicDispatch.shared
      .register(
        kind: .comment,
        operation: .commentOperation(body: CommentOperationView.init)
      )
      .register(
        kind: .voltageToggle,
        operation: .voltageToggleOperation(body: VoltageToggleOperationView.init)
      )
      .register(
        kind: .waveformSettings,
        operation: .waveformSettingsOperation(body: WaveformSettingsOperationView.init)
      )
      .finalize()
  }
  
  let printerController = PrinterController()
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(printerController)
        .onReceive(
          NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification)
        ) { _ in
          for window in NSApplication.shared.windows {
            if window.title == OpenWindows.mainWindow.title {
              window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isEnabled = false
              break
            }
          }
        }
    }
    .commands {
      CommandGroup(before: .windowList) {
        ForEach(0..<OpenWindows.allCases.count) { index in
          let window = OpenWindows.allCases[index]
          
          if let digit = Character(String(index)) {
            Button(window.title) {
              window.open()
            }
            .keyboardShortcut(KeyboardShortcut(KeyEquivalent(digit), modifiers: [.command, .shift]))
          } else {
            Button(window.title) {
              window.open()
            }
          }
        }
        
        Divider()
      }
      
			CommandGroup(replacing: .newItem) {
				Button("New…") {
					print("New...")
				}
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent("n"), modifiers: [.command]))
				.disabled(true)
				
				Button("Open…") {
					open()
				}
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent("o"), modifiers: [.command]))
				.disabled(printerController.printerQueueState.isRunning)
				
				Divider()
				
				Button("Save") {
					save()
				}
				.keyboardShortcut(KeyboardShortcut(KeyEquivalent("s"), modifiers: [.command]))
			}
    }
    .handlesExternalEvents(matching: ["mainWindow"])
    
    WindowGroup("Logs") {
      LogView()
    }
    .handlesExternalEvents(matching: ["logWindow"])
    
    Settings {
      PreferencesView()
        .frame(width: 240, height: 360, alignment: .top)
    }
  }
}

// MARK: Helpers
extension FifiApp {
	@MainActor
	func save() {
		let panel = NSSavePanel()
		panel.allowedContentTypes = [.json]
		panel.canCreateDirectories = true
		panel.isExtensionHidden = false
		panel.allowsOtherFileTypes = false
		panel.title = "Save Operation Queue…"
		
		let response = panel.runModal()
		guard let url = response == .OK ? panel.url : nil else { return }
		do {
			let data = try JSONEncoder().encode(printerController.printerQueueState.queue)
			try data.write(to: url)
		} catch {
			print("Could not save")
		}
	}
	
	@MainActor
	func open() {
		let panel = NSOpenPanel()
		panel.allowedContentTypes = [.json]
		panel.allowsMultipleSelection = false
		panel.canChooseDirectories = false
		panel.canChooseFiles = true
		
		let response = panel.runModal()
		guard let url = response == .OK ? panel.url : nil else { return }
		do {
			let data = try Data(contentsOf: url)
			let decoded = try JSONDecoder().decode(Array<AnyPrinterOperation>.self, from: data)
			printerController.printerQueueState.queue = decoded
		} catch {
			print("Could not open")
		}
	}
	
	func new() {
		
	}
}

// MARK: Open Windows
enum OpenWindows: String, CaseIterable {
  case mainWindow
  case logWindow
  
  var title: String {
    switch self {
    case .mainWindow:
      return "Fifi"
    case .logWindow:
      return "Logs"
    }
  }
  
  func open() {
    for window in NSApplication.shared.windows {
      if title == window.title {
        window.makeKeyAndOrderFront(nil)
        return
      }
    }
    
    if let url = URL(string: "fifi://\(self.rawValue)") {
      NSWorkspace.shared.open(url)
    }
  }
}
