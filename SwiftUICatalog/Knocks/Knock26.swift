//
//  Knock26.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

enum Knock26 {
    
    struct SectionData: Identifiable {
        let id: String
        let rows: [String]
    }
    
    struct ContentView: View {
        @State var selected: String?
        @State var sections: [SectionData] = [.init(id: "Pokemon", rows: ["pikachu", "kabigon"]), .init(id: "Trainer", rows: ["Takeshi", "Kasumi"])]
        @State var isPresentingAlert: Bool = false
        var body: some View {
            NavigationView {
                List(sections) { section in
                    if #available(iOS 15.0, *) {
                        Section(section.id) {
                            ForEach(section.rows, id: \.self) { row in
                                Button(row, action: {
                                    selected = row
                                    isPresentingAlert = true
                                })
                                
                                
                            }.onDelete(perform: { offsets in
                                offsets.forEach { offset in
                                    
                                }
                                print(section.id, offsets.map{$0})
                            })
                        }
                    } else {
                        Section(header: Text(section.id)) {
                            ForEach(section.rows, id: \.self) { row in
                                Text(row)
                            }.onDelete(perform: { offsets in
                                offsets.forEach { offset in
                                    
                                }
                                print(section.id, offsets.map{$0})
                            })
                        }
                    }
                    
                }
                ._alert(isPresented: $isPresentingAlert, title: "tapped", message: selected ?? "",
                         data: selected, action: { _ in
                   
               })
                .toolbar(content: {
                    EditButton()
                })
            }
            
        }
        
        
    }
}





#Preview {
    Knock26.ContentView()
}

