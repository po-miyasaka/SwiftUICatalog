//
//  Knock82.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import SwiftUI
enum Knock82 {
    struct ContentView: View {
        @GestureState private var magnifyBy = 1.0
        @State var scale = 1.0
        @State var lastValue: Double = 1
        var magnification: some Gesture {
            MagnificationGesture()
                .onChanged { v in
                    let gap = abs(lastValue - v)
                    if v < lastValue {
                        scale = max(scale - gap, 0.4)
                    } else {
                        scale = min(scale + gap, 3.0)
                    }
                    lastValue = v
                }.onEnded { _ in
                    lastValue = 1
                }
        }

        var body: some View {
            Image("kabigon", bundle: nil)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .gesture(magnification)
                .frame(maxWidth: 300)
        }
    }
}

#Preview {
    Knock82.ContentView()
}
