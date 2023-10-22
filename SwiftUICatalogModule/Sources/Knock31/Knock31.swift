//
//  Knock31.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

public enum Knock31 {
    public struct ContentView: View {
public init() {}
        @State var isPresentSheet = false
        public var body: some View {
            Button("show", action: {
                isPresentSheet = true
            }).fullScreenCover(isPresented: $isPresentSheet, content: {
                Text("sheet")
                Button(action: { isPresentSheet = false }, label: {
                    Text("Dismiss")
                })
            })
        }
    }
}

#Preview {
    Knock31.ContentView()
}
