//
//  Knock36.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
public enum Knock36 {
    public struct ContentView: View {
public init() {}
        @State var shouldPush: Bool = false
        public var body: some View {
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
