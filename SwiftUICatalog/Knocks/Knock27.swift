//
//  Knock27.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

struct Knock27: View {
    @State var count: Int = 0
    var body: some View {
        
        NavigationView {
    
            VStack {
                Text("\(count)")
                NavigationLink(destination: {
                    Button("fire", action: {  increment() })
                }, label: {
                    Text("Next")
                })
            }
        }
    }
    
    func increment() {
        count += 1
    }
}

#Preview {
    Knock27()
}
