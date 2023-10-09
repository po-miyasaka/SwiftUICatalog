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
            MainView(viewModel: ViewModel())
                .environment(\.layoutValues, 
                    LayoutValues(
                        screenSize: UIScreen.main.bounds.size ,
                        safeAreaProvider: {
                            UIApplication.shared.windows
                                .filter { $0.isKeyWindow }.first?.safeAreaInsets
                        }
                    )
                )
        }
    }
}

private struct LayoutValuesKey: EnvironmentKey {
    static var defaultValue: LayoutValues = {
        LayoutValues(screenSize: .zero,
                     safeAreaProvider: {.zero})
    }()
    
    typealias Value = LayoutValues
}

extension EnvironmentValues {
    var layoutValues: LayoutValues {
        get { self[LayoutValuesKey.self] }
        set { self[LayoutValuesKey.self] = newValue }
    }
}

private struct ScreenSizeKey: EnvironmentKey {
    static var defaultValue: CGSize = .zero
    
    typealias Value = CGSize
}

extension EnvironmentValues {
    var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}
