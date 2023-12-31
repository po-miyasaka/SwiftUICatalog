//
//  Knock74.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI

public enum Knock74 {
    enum Dist: String, Hashable {
        case kabigon
        case pikachu
    }

    public struct ContentView: View {
public init() {}
        @State var tapped = false
        @State var dist: Dist?
        public var body: some View {
            if #available(iOS 16.0, *) {
                Text(tapped ? "t" : "f")
                NavigationStack {
                    Button("push", action: {
                        dist = .kabigon
                        tapped.toggle()
                    })
                        .navigationDestination(isPresented: $tapped) {
                            if let dist {
                                switch dist {
                                case .kabigon:
                                    Text("kabigon")
                                case .pikachu:
                                    Button("kabigon") {}
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    Knock74.ContentView()
}
