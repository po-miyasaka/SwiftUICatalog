//
//  Knock2.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
enum Knock3 {
    struct ContentView: View {
        var body: some View {
            VStack {
                Image("kabigon2", bundle: nil)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: 150, maxHeight: 150)

                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    Knock3.ContentView()
}
