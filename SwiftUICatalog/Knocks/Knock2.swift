//
//  Knock1.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock2 {
    struct ContentView: View {
        var body: some View {
            VStack {
                Image("kabigon2", bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 150, maxHeight: 200)
                    .clipped()
            }
            ._background()
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
    Knock2.ContentView()
}
