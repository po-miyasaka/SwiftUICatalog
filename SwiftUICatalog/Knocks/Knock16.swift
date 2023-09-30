//
//  Knock16.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock16 {
    
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
                      message: "message1",
                      data: data,
                      action: { st in
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
                      message: "message2",
                      data: data2,
                      action: { st in
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
    func _alert<T>(isPresented: Binding<Bool>,title: String, message: String,  data: T, @ViewBuilder action: ((T) -> some View )) -> some View {
        if #available(iOS 15.0, *) {
            alert(title, isPresented: isPresented, presenting: data, actions: { data in
                action(data)
            }, message: { data in
                Text(message)
            })
        } else {
            alert(
                isPresented: isPresented,
                content: {
                    .init(title: Text(title),
                          message: Text(message),
                          primaryButton: .default(Text("OK"),
                                                  action: {
                        print("ok")
                    }),
                          secondaryButton: .cancel())
                })
        }
    }
}


#Preview {
    Knock16.ContentView()
}