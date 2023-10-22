//
//  Knock13.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

public enum Knock13 {
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }

    public struct ContentView: View {
public init() {}
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        public var body: some View {
            if #available(iOS 16.0, *) {
                NavigationStack {
                    List {
                        ForEach(sections) { section in
                            Section(section.id) {
                                ForEach(section.rows, id: \.self) { row in
                                    NavigationLink(row) {
                                        Text(row).navigationBarBackButtonHidden()
                                    }
                                }
                            }
                        }
                    }.listStyle(PlainListStyle())
                }
            } else {
                // Fallback on earlier versions
                Text("not16.0")
            }
        }
    }
}

#Preview {
    Knock13.ContentView()
}
