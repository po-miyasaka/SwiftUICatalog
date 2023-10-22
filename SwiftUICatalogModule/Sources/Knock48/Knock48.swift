//
//  Knock48.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import SwiftUI

public enum Knock48 {
    public struct ContentView: View {
public init() {}
        @AppStorage("str") var str: String = "str"

        public var body: some View {
            VStack {
                TextField(str, text: $str)
            }
        }
    }
}

#Preview {
    Knock48.ContentView()
}
