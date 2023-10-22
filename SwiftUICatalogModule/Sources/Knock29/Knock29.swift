//
//  Knock29.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

public enum Knock29 {
    public struct ContentView: View {
public init() {}
        @State var selected = ""
        @State var selected2 = ""
        @State var arr = ["pika", "kabigon", "kirinriki"]
        @State var arr2 = ["Takeshi", "Kasumi"]
        public var body: some View {
            HStack {
                Picker(selection: $selected, content: {
                    ForEach(arr, id: \.self) { item in
                        Text(item)
                    }
                }, label: {
                    Text("Pokkemooon")
                })

                Picker(selection: $selected2, content: {
                    ForEach(arr2, id: \.self) { item in
                        Text(item)
                    }
                }, label: {
                    Text("Pokkemooon")
                })
            }
        }
    }
}

#Preview {
    Knock29.ContentView()
}
