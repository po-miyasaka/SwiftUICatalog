//
//  Knock8.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI


enum Knock9 {
    struct ContentView: View {
        @State var tapped = false
        var body: some View {
            
            Button("Button", action: {
                tapped.toggle()
            })
            Text(tapped ? "tapped" : "tap here").font(.caption)
            
        }
    }
    
    

}

#Preview {
    Knock9.ContentView()
}
