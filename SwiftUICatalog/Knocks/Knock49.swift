//
//  Knock49.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import SwiftUI

enum Knock49 {
    struct ContentView: View {
        var body: some View {
            ZStack {
                Image("kabigon", bundle: nil)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150, maxHeight: 200)
                if #available(iOS 17.0, *) {
                    Text("Kabigon").foregroundStyle(.white).shadow(color: .black, radius: 5, x: 1, y: 1)
                }
            }
        }
    }
}

#Preview {
    Knock49.ContentView()
}
