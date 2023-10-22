//
//  Knock17.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
import Common
public enum Knock17 {
    public struct ContentView: View {
public init() {}
        @State var isShowingAlert = false
        @State var data = "kabigon"
        @State var data2 = "pikachu"
        public var body: some View {
            Text(data)

            Button("alert1", action: {
                isShowingAlert.toggle()
            })._alert(isPresented: $isShowingAlert,
                      title: "alert1",
                      data: data,
                      action: { _ in
                          Button("a", action: {
                              self.data = "a"
                })

                          Button("b", action: {
                              self.data = "b"
                })
                          Button("c", action: {
                              self.data = "c"
                })
            })

            Button("alert2", action: {
                isShowingAlert.toggle()
            })._alert(isPresented: $isShowingAlert,
                      title: "alert2",
                      data: data2,
                      action: { _ in
                          Button("d", action: {
                              self.data2 = "d"
                })

                          Button("e", action: {
                              self.data2 = "e"
                })

            })
        }
    }
}

#Preview {
    Knock17.ContentView()
}
