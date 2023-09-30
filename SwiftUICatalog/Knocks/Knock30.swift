//
//  Knock30.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
enum Knock30 {
    struct ContentView: View {
        @State var isPresentSheet = false
        var body: some View {
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
