//
//  Knock55.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI

enum Knock55 {
    enum Dist: String, Hashable {
        case kabigon
        case pikachu
    }

    struct ContentView: View {
        @State var tapped = false
        @State var dist: Dist?
        var body: some View {
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
                                    Text(dist.rawValue)
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
    Knock55.ContentView()
}
