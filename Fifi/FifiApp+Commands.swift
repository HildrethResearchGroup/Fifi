//
//  FifiApp+Commands.swift
//  Fifi
//
//  Created by Connor Barnes on 11/7/21.
//

import SwiftUI
import PrinterController

extension FifiApp {
	@MainActor
	@CommandsBuilder
	func commands() -> some Commands {
		// MARK: Window
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
		
		// MARK: File
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
