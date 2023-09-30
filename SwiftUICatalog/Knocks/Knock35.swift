//
//  Knock35.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

import SwiftUI
enum Knock35 {
    struct ContentView: View {
        @State var shakeDetail: String = ""
        let column = [GridItem(), GridItem(), GridItem()]
        var body: some View {
            if #available(iOS 16.0, *) {
                ScrollView {
                    Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                        ForEach(0..<5) { row in
                            GridRow {
                                ForEach(0..<5) { column in
                                    VStack {
                                        Color.green
                                        Text("(\(column), \(row))")
                                    }
                                    
                                }
                            }
                        }
                    }.padding()
                    LazyVGrid(columns: column, content: {
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                        Text("Placeholder")
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                        /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    })
                }
            } else {
                LazyVGrid(columns: column, content: {
                    /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    Text("Placeholder")
                    /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                    /*@START_MENU_TOKEN@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                })
                
            }
        }
    }
    
}
#Preview {
    Knock35.ContentView()
}
