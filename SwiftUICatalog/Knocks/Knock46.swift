//
//  SwiftUIView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import SwiftUI
import Combine  
enum Knock46 {
    
    struct ContentView: View {
        @State var str: String = ""
        @State var keyboardState: String = ""
        @State var cancellable: Set<AnyCancellable> = []
        
        @MainActor func listen() {
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification).sink(receiveValue: { _ in
                Task {@MainActor in
                    keyboardState = "hide"
                }
                
            })
            .store(in: &cancellable)
            
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification).sink(receiveValue: { _ in
                Task {@MainActor in
                    keyboardState = "show"
                }
                
                
            }).store(in: &cancellable)
            
  
        }
        var body: some View {
            VStack {
                TextField("text", text: $str)
                    .onAppear {
                        listen()
                    }
                Text(keyboardState)
            }
            
        }
    }
    
}

#Preview {
    Knock46.ContentView()
}

