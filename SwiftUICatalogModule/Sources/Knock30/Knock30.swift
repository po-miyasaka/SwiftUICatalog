//
//  Knock30.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
public enum Knock30 {
    public struct ContentView: View {
public init() {}
        @State var isPresentSheet = false
        public var body: some View {
            Button("show", action: {
                isPresentSheet = true
            }).sheet(isPresented: $isPresentSheet, content: {
                Text("sheet")
            })
        }
    }
}

#Preview {
    Knock30.ContentView()
}
