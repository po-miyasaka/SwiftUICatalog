//
//  SwiftUICatalogApp.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import SwiftUI

@main
struct SwiftUICatalogApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 17.0, *) {
                AKnock4.ContentView()
//                AKnock8.ContentView()
//                VStack(spacing: 16) {
//                    GeometryReader { geometryProxy in AKnock9.ContentView(viewSize: geometryProxy.size) }.frame(height: 250).background(Color.gray)
//                    GeometryReader { geometryProxy in AKnock7.ContentView(viewSize: geometryProxy.size) }.background(Color.gray)
//                }.background(Color.black)
                
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
