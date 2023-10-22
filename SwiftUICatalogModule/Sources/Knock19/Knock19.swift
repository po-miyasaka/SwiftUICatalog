//
//  Knock19.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
import Common
public struct ContentView: View {
    @State var str = ""
    @State var isPresentAlert = false
    @State var isPresentSheet = false
    public init() {}
    public var body: some View {
        TextField("text", text: $str)
        Button("show", action: {
            if Int(str) != nil {
                isPresentSheet = true
            } else {
                isPresentAlert = true
            }
        })
            ._alert(isPresented: $isPresentAlert, title: "input error", data: "", action: { _ in
                Button("ok", action: {
                    print("ok")
            })
        }).sheet(isPresented: $isPresentSheet, content: {
                Text(str)
        })
    }
}

#Preview {
    ContentView()
}
