//
//  Knock41.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

enum Knock41 {
    #warning("try old style")
    @available(iOS 15, *)
    struct ContentView: View {
        var body: some View {
            let thankYouString = try! AttributedString(
                markdown: "[website](https://example.com)")
            VStack {
                HStack {
                    Text(thankYouString).underline() +
                        Text(" \("b") ")
                }
            }
        }
    }
}

@available(iOS 15, *)
#Preview {
    Knock41.ContentView()
}
