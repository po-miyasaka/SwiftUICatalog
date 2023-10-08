//
//  Knock32.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
enum Knock32 {
    struct ContentView: View {
        @State var isPresentSheet = false
        var body: some View {
            Button("show", action: {
                isPresentSheet = true
            }).fullScreenCover(isPresented: $isPresentSheet, content: {
                NavigationView {
                    VStack {
                        Text("sheet")
                    }
                    //                .toolbar(content: {
                    //
                    //                    ToolbarItem(placement: .destructiveAction) {
                    //                        Button(action: {isPresentSheet = false}, label: {
                    //                            Text("Dismiss")
                    //                        })
                    //                                 }
                    //                })
                }

            })
        }
    }
}

#Preview {
    Knock32.ContentView()
}
