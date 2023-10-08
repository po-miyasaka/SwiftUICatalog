//
//  Knock69.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
extension Int: Identifiable {
    public var id: Int {
        self
    }
}

@available(iOS 16.0, *)
enum Knock69 {
    struct ContentView: View {
        @State var arr = ["Takeshi", "Kasumi", "Takashi"]
        @State var searching: String = ""
        var body: some View {
            NavigationView {
                List {
                    ForEach(arr.filter { searching.isEmpty || $0.contains(searching) }, id: \.self) { element in
                        Text(element)
                    }
                    .onMove { source, distination in
                        arr.move(fromOffsets: source, toOffset: distination)
                    }
                }
                .searchable(text: $searching)
            }
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    Knock69.ContentView()
}
