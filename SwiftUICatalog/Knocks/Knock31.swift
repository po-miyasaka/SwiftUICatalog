//
//  Knock31.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

enum Knock31 {
    struct ContentView: View {
        @State var isPresentSheet = false
        var body: some View {
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
