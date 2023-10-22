//
//  Knock38.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
import Common
public enum Knock38 {
    public struct ContentView: View {
public init() {}
        @State var isPresentSheet = false
        public var body: some View {
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
