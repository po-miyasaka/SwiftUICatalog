//
//  Knock27.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    @State var count: Int = 0
    public var body: some View {
        NavigationView {
            VStack {
                Text("\(count)")
                NavigationLink(destination: {
                    Button("fire", action: { increment() })
                }, label: {
                    Text("Next")
                })
            }
        }
    }

    func increment() {
        count += 1
    }
}

#Preview {
    Knock27.ContentView()
}
