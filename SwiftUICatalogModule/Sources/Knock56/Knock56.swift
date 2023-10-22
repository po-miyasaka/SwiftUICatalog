//
//  Knock56.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI

public enum Knock56 {
    enum Dist: String, Hashable {
        case kabigon
        case pikachu
    }

    public struct ContentView: View {
public init() {}
        @State var tapped = false
        @State var dist: Dist?
        @State var str: String = ""
        public var body: some View {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    Text(str)
                    Button("push", action: {
                        tapped.toggle()
                    })
                        .navigationDestination(isPresented: $tapped) {
                            Child(str: $str)
                        }
                }
            }
        }
    }
}

#Preview {
    Knock56.ContentView()
}

struct Child: View {
    @Binding var str: String
    public var body: some View {
        TextField("str", text: $str)
    }
}
