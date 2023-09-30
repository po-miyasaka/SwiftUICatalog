//
//  Knock89.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import SwiftUI

struct Knock89: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Knock89().previewDevice(PreviewDevice.init(rawValue: "iPhone 15 Pro (com.apple.CoreSimulator.SimDeviceType.iPhone-15-Pro)"))
                .previewDisplayName("a")
            
            Knock89().previewDevice(PreviewDevice.init(rawValue: "iPad Pro (11-inch) (4th generation) (com.apple.CoreSimulator.SimDeviceType.iPad-Pro-11-inch-4th-generation-8GB)"))
                .previewDisplayName("b")
        }
    }
}
