//
//  Knock37.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI


enum Knock37 {
    enum Page: Hashable {
        case first
        case second
        case third
    }
    struct ContentView: View {
        @State var shouldPush: Bool = false
        @State var selection: Page = .first
        var body: some View {
            TabView(selection: $selection,
                         content:  {
                Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(Page.first)
                Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(Page.second)
                Text("Tab Content 3").tabItem { Text("Tab Label 3") }.tag(Page.third)
            })
            .tabViewStyle(PageTabViewStyle())
        }
    }
}

#Preview {
    Knock37.ContentView()
}

