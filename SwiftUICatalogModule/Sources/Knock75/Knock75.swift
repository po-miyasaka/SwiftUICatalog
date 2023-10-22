//
//  Knock75.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI
import Common
public enum Knock75 {
    public struct ContentView: View {
public init() {}
        @State var selected = 2
        @State var arr = ["pika", "kabigon", "kirinriki"]
        public var body: some View {
            TabView(selection: $selected,
                    content: {
                        VStack {
                            Text("Tab Content 1")
                            Button("switch") {
                                selected = 2
                            }
                        }.tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)

                        VStack {
                            Text("Tab Content 2")
                            Button("switch") {
                                selected = 1
                            }
                        }.tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)

                        VStack {
                            Image("kabigon2", bundle: .main)
                            Text("Tab Content 3")
                        }.tabItem {
                            VStack {
                                Image(uiImage: image())
                                Text("Tab Content 3")
                            }
                        }.tag(2)
            })
        }
    }
}

#Preview {
    Knock75.ContentView()
}
