//
//  Knock22.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    public var body: some View {
        Text("Hello ⭐️ World!\n") +
            Text("My ").bold() +
            Text("Great").style().font(/*@START_MENU_TOKEN@*/ .title/*@END_MENU_TOKEN@*/)
    }
}

extension Text {
    func style() -> Text {
        if #available(iOS 17.0, *) {
            foregroundStyle(.green)
        } else {
            foregroundColor(.green)
        }
    }
}

#Preview {
    Knock22.ContentView()
}
