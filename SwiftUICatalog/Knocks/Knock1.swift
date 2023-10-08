//
//  ContentView0.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
enum Knock1 {
    struct ContentView: View {
        var body: some View {
            VStack {
                ZStack {
                    Color.red
                    Image("kabigon", bundle: nil)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: 150, maxHeight: 200)
            }
        }
    }

    struct ContentView0: View {
        var body: some View {
            VStack {
                Image("kabigon", bundle: nil)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150, maxHeight: 200)
                    ._background()
            }
        }
    }
}

private extension View {
    @ViewBuilder
    func _background() -> some View {
        if #available(iOS 15.0, *) {
            background(content: { Color.green })
        } else {
            ZStack {
                Color.green
                self
            }
        }
    }
}

#Preview {
    Group {
        Knock1.ContentView()
        Knock1.ContentView0()
    }
}
