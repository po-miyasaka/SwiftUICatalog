//
//  Knock48.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import SwiftUI

enum Knock48 {
    struct ContentView: View {
        @AppStorage("str") var str: String = "str"

        var body: some View {
            VStack {
                TextField(str, text: $str)
            }
        }
    }
}

#Preview {
    Knock48.ContentView()
}
