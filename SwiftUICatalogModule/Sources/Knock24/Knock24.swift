//
//  Knock24.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

public struct ContentView: View {
    public init() {}
    public var body: some View {
        Image("kabigon2", bundle: nil)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(Circle())
            ._overlay()
            .modifier(ShadowModifier())
    }
}

struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.shadow(radius: 3, x: 2, y: 2)
    }
}

private extension View {
    @ViewBuilder
    func _overlay() -> some View {
        if #available(iOS 15.0, *) {
            overlay {
                Circle().strokeBorder(.white, lineWidth: 2)
            }
        } else {
            ZStack {
                self
                Circle().strokeBorder(.red, lineWidth: 5)
            }
        }
    }
}

#Preview {
    Knock24.ContentView()
}
