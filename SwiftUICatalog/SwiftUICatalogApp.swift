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
            if #available(iOS 17.0, *) {
//                AKnock5.ContentView().frame(height: 200)
                MainView()
                    .environment(\.screenSize, UIScreen.main.bounds.size)
                    .environment(\.safeArea) { UIApplication.shared.windows
                        .filter { $0.isKeyWindow }.first?.safeAreaInsets ?? .zero
                    }

            } else {
                // Fallback on earlier versions
            }
        }
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

private struct SafeAreaKey: EnvironmentKey {
    static var defaultValue: () -> UIEdgeInsets = { .zero }

    typealias Value = () -> UIEdgeInsets
}

extension EnvironmentValues {
    var safeArea: () -> UIEdgeInsets {
        get { self[SafeAreaKey.self] }
        set { self[SafeAreaKey.self] = newValue }
    }
}
