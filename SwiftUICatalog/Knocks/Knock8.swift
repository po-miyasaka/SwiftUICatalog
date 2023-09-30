//
//  Knock7.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

enum Knock8 {
    struct ContentView: View {
        
        @State var selected = 2
        @State var arr = ["pika", "kabigon", "kirinriki"]
        var body: some View {
            TabView(selection: $selected,
                    content:  {
                Text("Tab Content 1").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 1")/*@END_MENU_TOKEN@*/ }.tag(1)
                Text("Tab Content 2").tabItem { /*@START_MENU_TOKEN@*/Text("Tab Label 2")/*@END_MENU_TOKEN@*/ }.tag(2)
                VStack {
                    Image("kabigon2", bundle: .main)
                    Text("Tab Content 3")
                }.tabItem {
                    VStack {
                        Image(uiImage: image())
                        Text("Tab Content 3")
                    }
                }.tag(2)
            })
        }
    }
}

func image() -> UIImage {
    let image = UIImage(named: "svg")!
    let aspectScale = image.size.height / image.size.width
    
    let resizedSize = CGSize(width: 30, height: 30 * Double(aspectScale))
    
    UIGraphicsBeginImageContext(resizedSize)
    image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage!
}

#Preview {
    Knock8.ContentView()
}

