//
//  Knock16.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock18 {
    struct ContentView: View {
        @State var tapped = false
        var body: some View {
            Text(tapped ? "A" : "B").font(.caption)
            
            Button( action: {
                tapped.toggle()
            }, label: {
                HStack {
                    Image("kabigon2", bundle: nil)
                        .resizable()
                        .scaledToFill()
                        .frame( maxWidth: 50, maxHeight: 50)
                        .clipShape(Circle())
                    Text("tap here").font(.caption)
                }
                .padding()
                .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
            })
            
            
            
        }
    }
    
    
    
}

#Preview {
    Knock18.ContentView()
}
