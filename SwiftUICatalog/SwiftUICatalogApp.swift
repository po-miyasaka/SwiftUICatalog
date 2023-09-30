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
//                AKnock1.ContentView()
//                AKnock2.ContentView()
                AKnock4.ContentView()
            } else {
                // Fallback on earlier versions
            }
        }
    }
}
