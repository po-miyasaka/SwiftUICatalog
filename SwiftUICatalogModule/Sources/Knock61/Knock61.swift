//
//  Knock61.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
public enum Knock61 {
    public struct ContentView: View {
public init() {}
        let column = [GridItem(), GridItem()]
        public var body: some View {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(0 ..< 7) { _ in
                        VStack {
                            Image("kabigon", bundle: nil)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 100, maxHeight: 100)
                            Text("All")
                        }
                    }
                }
            }
        }
    }
}
