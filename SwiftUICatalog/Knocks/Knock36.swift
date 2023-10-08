//
//  Knock36.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
enum Knock36 {
    struct ContentView: View {
        @State var shouldPush: Bool = false
        var body: some View {
            NavigationView {
                NavigationLink("a", isActive: $shouldPush, destination: {
                    Text("weeee")
                })
            }
            .onAppear {
                withAnimation {
                    shouldPush = true
                }
            }
        }
    }
}

#Preview {
    Knock36.ContentView()
}
