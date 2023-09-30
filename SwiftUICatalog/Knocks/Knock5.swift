//
//  Knock4.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock5 {
    struct ContentView: View {
        var body: some View {
            ScrollView(.horizontal) {
                HStack(spacing: 50) {
                    ForEach(0..<6) { _ in
                        image()
                    }
                }
            }
        }
        
        func image() -> some View {
            Image("kabigon2", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame( maxWidth: 50, maxHeight: 50)
                .clipShape(Circle())
                ._overlay()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        }
    }
}

private extension View {
   @ViewBuilder
   func _overlay() -> some View {
       
       
     if #available(iOS 15.0, *) {
         overlay {
             Circle().strokeBorder(.red, lineWidth: 5)
         }
     } else {
         ZStack {
             self
             Circle().strokeBorder(.red, lineWidth: 5)
         }
     }
   }
}

#Preview {
    Knock5.ContentView()
}
