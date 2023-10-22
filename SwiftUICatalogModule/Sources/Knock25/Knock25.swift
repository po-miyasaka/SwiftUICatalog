//
//  Knock25.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

public enum Knock25 {
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }

    public struct ContentView: View {
        public init() {}
        @State var selected: IndexSet = .init()
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        public var body: some View {
            NavigationView {
                List(sections) { section in
                    if #available(iOS 15.0, *) {
                        Section(section.id) {
                            ForEach(section.rows, id: \.self) { row in
                                Button(row, action: {})
                            }.onDelete(perform: { offsets in
                                offsets.forEach { _ in
                                }
                                selected = offsets
                                print(section.id, offsets.map { $0 })
                            })
                        }
                    } else {
                        Section(header: Text(section.id)) {
                            ForEach(section.rows, id: \.self) { row in
                                Text(row)
                            }.onDelete(perform: { offsets in
                                offsets.forEach { _ in
                                }
                                selected = offsets
                                print(section.id, offsets.map { $0 })
                            })
                        }
                    }

                }.toolbar(content: {
                    EditButton()
                })
            }
        }
    }
}

#Preview {
    Knock25.ContentView()
}
