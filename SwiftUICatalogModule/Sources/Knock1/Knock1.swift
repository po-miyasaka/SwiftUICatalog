//
//  SwiftUIView.swift
//
//
//  Created by po_miyasaka on 2023/10/22.
//

import SwiftUI

public struct ContentView: View {

    public init() {}
    public var body: some View {
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

public struct ContentView0: View {
    public init() {}
    public  var body: some View {
        VStack {
            Image("kabigon", bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150, maxHeight: 200)
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
    Group {
        Knock1.ContentView()
        Knock1.ContentView0()
    }
}
