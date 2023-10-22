//
//  Knock12.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

public enum Knock12 {
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }

    public struct ContentView: View {
public init() {}
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        public var body: some View {
            NavigationView {
                List {
                    ForEach(sections) { section in
                        Section(header: Text(section.id)) {
                            ForEach(section.rows, id: \.self) { row in
                                NavigationLink(row) {
                                    Text(row).navigationBarBackButtonHidden()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Knock12.ContentView()
}
