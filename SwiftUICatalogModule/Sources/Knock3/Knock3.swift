//
//  Knock2.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI
public  enum Knock3 {
 public struct ContentView: View {

        public init() {}
        public  var body: some View {
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
