//
//  Knock14.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock14 {
    
    struct ContentView: View {
        @State var isShowingAlert = false
        var body: some View {
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
