//
//  Knock76.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI

public enum Knock76 {
    public struct ContentView: View {
public init() {}
        @State var selected = ""
        @State var arr = ["pika", "kabigon", "kirinriki"]
        public var body: some View {
            Picker(selection: $selected, content: {
                ForEach(arr, id: \.self) { item in
                    Text(item)
                }
            }, label: {
                Text("Pokkemooon")
            })
        }
    }
}

#Preview {
    Knock76.ContentView()
}
