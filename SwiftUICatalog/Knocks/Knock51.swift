//
//  Knock51.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import SwiftUI
enum Knock51 {
    struct ContentView: View {
        var body: some View {
            Image("kabigon", bundle: nil)
                .resizable()
                .scaledToFit()
                .frame(maxWidth:150 ,maxHeight: 200)
                .onLongPressGesture(perform: {
                    
                })
                .contextMenu(menuItems: {
                    VStack {
                        Text("a")
                        Text("b")
                    }
                })
            
        }
    }
    
}
#Preview {
    Knock51.ContentView()
}
