//
//  HomeOperation.swift
//  
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI

public struct HomeConfiguration: Hashable, Codable {
	public init() { }
}

extension PrinterOperation {
    // This function creates a `PrinterOperation` specifically for the "home" operation.
    // Steps:
    // 1. It is a generic function that accepts a `View` type as a parameter.
    // 2. It takes a closure that provides a `Binding` to a `HomeConfiguration` and returns a `Body` view.
    // 3. It initializes a `PrinterOperation` with specific parameters for the home operation.
    // 4. The `kind` is set to `.home` to indicate the type of operation.
    // 5. A new `HomeConfiguration` instance is created for the `configuration`.
    // 6. The operation is named "Home" and uses "house" as the thumbnail name.
    // 7. The `body` closure is passed directly to the `PrinterOperation`.
    // 8. The execution closure is defined to perform the actual home operation using the `printerController`.
    public static func homeOperation<Body: View>(
        body: @escaping (Binding<HomeConfiguration>) -> Body
    ) -> PrinterOperation<HomeConfiguration, Body> {
        .init(
            kind: .home, // The kind of operation is set to 'home'.
            configuration: .init(), // A new HomeConfiguration instance is created.
            name: "Home", // The name of the operation is set to "Home".
            thumbnailName: "house", // The thumbnail for the operation is set to an image named "house".
            body: body // The body closure is passed to the PrinterOperation.
        ) { configuration, printerController in
            // This closure is called when the operation is executed.
            // It attempts to perform the home operation on the printer.
            try await printerController.searchForHome()
        }
    }
}
