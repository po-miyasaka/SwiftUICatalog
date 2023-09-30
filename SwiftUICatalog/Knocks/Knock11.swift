//
//  Knock11.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock11 {
    
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }
    
    struct ContentView: View {
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        var body: some View {
            NavigationView {
                List {
                    ForEach(sections) { section in
                        Section(header: Text(section.id)) {
                            ForEach(section.rows, id: \.self) { row in
                                NavigationLink(row) {
                                    Text(row)
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
    Knock11.ContentView()
}

