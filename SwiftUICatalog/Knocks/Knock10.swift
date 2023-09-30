//
//  Knock10.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock10 {
    
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }
    
    struct ContentView: View {
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        var body: some View {
            
            List {
                ForEach(sections) { section in
                    if #available(iOS 15.0, *) {
                        Section(section.id) {
                            ForEach(section.rows, id: \.self) { row in
                                Text(row)
                            }
                        }
                    } else {
                        Section(header: Text(section.id)) {
                            ForEach(section.rows, id: \.self) { row in
                                Text(row)
                            }
                        }
                    }
                    
                }
            }
            
        }
    }
    
    

}

#Preview {
    Knock10.ContentView()
}
