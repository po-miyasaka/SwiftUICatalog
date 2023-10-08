//
//  Knock33.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
enum Knock33 {
    struct ContentView: View {
        var body: some View {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    if #available(iOS 15.0, *) {
        Knock33.ContentView().previewInterfaceOrientation(.landscapeLeft)
    } else {
        Knock33.ContentView().previewLayout(PreviewLayout.fixed(width: 568, height: 320))
    }
}
