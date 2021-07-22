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
      
      CommandGroup(replacing: .newItem, addition: { })
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
