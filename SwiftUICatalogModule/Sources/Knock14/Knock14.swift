//
//  Knock14.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

public enum Knock14 {
    public struct ContentView: View {
public init() {}
        @State var isShowingAlert = false
        public var body: some View {
            Button("alert", action: {
                isShowingAlert.toggle()
            }).alert(isPresented: $isShowingAlert, content: {
                .init(title: Text("This is Alert"),
                      message: Text("do you like kabigon"),
                      primaryButton: .default(Text("OK"),
                                              action: {
                                                  print("OK")
                }),
                      secondaryButton: .cancel())
            })
        }
    }
}

#Preview {
    Knock14.ContentView()
}
