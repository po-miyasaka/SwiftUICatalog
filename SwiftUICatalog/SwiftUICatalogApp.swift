//
//  SwiftUICatalogApp.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/20.
//

import LookingGlassUI
import SwiftUI

@main
struct SwiftUICatalogApp: App {
    var body: some Scene {
        WindowGroup {
//            MainView(viewModel: ViewModel(),
//                     layoutObject: .init(
//                        screenSize: UIScreen.main.bounds.size,
//                        safeAreaProvider: {
//                            UIApplication.shared.windows
//                                .filter { $0.isKeyWindow }.first?.safeAreaInsets
//                        }))
            AKnock11()
        }
    }
}
