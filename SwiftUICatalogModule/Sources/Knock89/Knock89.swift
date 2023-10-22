//
//  Knock89.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

public struct ContentView_Previews: PreviewProvider {
    public static var previews: some View {
        Group {
            ContentView().previewDevice(PreviewDevice(rawValue: "iPhone 15 Pro (com.apple.CoreSimulator.SimDeviceType.iPhone-15-Pro)"))
                .previewDisplayName("a")

            ContentView().previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch) (4th generation) (com.apple.CoreSimulator.SimDeviceType.iPad-Pro-11-inch-4th-generation-8GB)"))
                .previewDisplayName("b")
        }
    }
}
