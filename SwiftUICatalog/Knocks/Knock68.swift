//
//  Knock66.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
enum Knock68 {
    struct ContentView: View {
        @State var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
        var body: some View {
            List {
                ForEach(arr, id: \.self) { num in
                    HStack {
                        Button("1") {
                            print("1", num)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        Button("2") {
                            print("2", num)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .contentShape(Rectangle())
                        Button(action: {
                            print("3", num)
                        }, label: {
                            Text("3").font(.body).foregroundColor(.blue)
                        })
                            .buttonStyle(PlainButtonStyle()) // This is essential
                            .contentShape(Rectangle())
                    }
                }
                .onMove { source, distination in
                    arr.move(fromOffsets: source, toOffset: distination)
                }
            }
        }
    }
}

#Preview {
    Knock68.ContentView()
}
