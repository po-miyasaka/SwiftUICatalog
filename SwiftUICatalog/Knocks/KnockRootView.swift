//
//  ContentView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
enum Knock {
    struct ContentView: View {
        var body: some View {
            ZStack(alignment: .center) {
                Color.white.ignoresSafeArea()
                Knock101
                    .ContentView()
            }
        }
    }
}

#Preview {
    Knock.ContentView()
}
