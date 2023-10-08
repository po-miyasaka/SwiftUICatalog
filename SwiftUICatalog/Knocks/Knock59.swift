//
//  Knock59.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
enum Knock59 {
    struct ContentView: View {
        @State var present: Bool = false
        @State var present2: Bool = false
        @State var present3: Bool = false
        var body: some View {
            VStack {
                Toggle(isOn: $present, label: {
                    Text("Present")
                }).alert(isPresented: $present, content: {
                    .init(title: Text("Alert"))
                })

                Toggle(isOn: $present2, label: {
                    Text("Present2")
                }).alert(isPresented: $present2, content: {
                    .init(title: Text("Alert2"))
                })

                Toggle(isOn: $present3, label: {
                    Text("Present2")
                })
            }
            .padding()
            .alert(isPresented: $present3, content: {
                .init(title: Text("Alert3"))
            })
        }
    }
}

#Preview {
    Knock59.ContentView()
}
