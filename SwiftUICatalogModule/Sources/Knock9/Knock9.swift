//
//  Knock8.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

public enum Knock9 {
    public struct ContentView: View {
public init() {}
        @State var tapped = false
        public var body: some View {
            Button("Button", action: {
                tapped.toggle()
            })
            Text(tapped ? "tapped" : "tap here").font(.caption)
        }
    }
}

#Preview {
    Knock9.ContentView()
}
