//
//  Knock1.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

public  enum Knock2 {
 public struct ContentView: View {

        public init() {}
        public  var body: some View {
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
