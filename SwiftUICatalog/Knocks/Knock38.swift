//
//  Knock38.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

enum Knock38 {
    struct ContentView: View {
        @State var isPresentSheet = false
        var body: some View {
            Button("show", action: {
                isPresentSheet = true
            }).sheet(isPresented: $isPresentSheet, content: {
                NavigationView {
                    VStack {
                        Text("sheet")
                    }
                }.if {
                    if #available(iOS 15.0, *) {
                        $0.interactiveDismissDisabled()
                    } else {
                        // Fallback on earlier versions
                    }
                }

            })
        }
    }
}

#Preview {
    Knock38.ContentView()
}
