//
//  Knock15.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock15 {
    struct ContentView: View {
        @State var isShowingAlert = false
        @State var data = "kabigon"
        @State var data2 = "pikachu"
        var body: some View {
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

extension View {
    @ViewBuilder
    func _alert<T>(isPresented: Binding<Bool>, title: String, data: T, @ViewBuilder action: (T) -> some View) -> some View {
        if #available(iOS 15.0, *) {
            alert(title, isPresented: isPresented, presenting: data, actions: { data in
                action(data)
            }, message: { _ in
                Text("message")
            })
        } else {
            alert(isPresented: isPresented, content: {
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
    Knock15.ContentView()
}
