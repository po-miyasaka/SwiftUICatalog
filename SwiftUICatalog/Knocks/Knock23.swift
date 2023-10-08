//
//  Knock23.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI

struct Knock23: View {
    var body: some View {
        Image("kabigon2", bundle: nil)
            .resizable()
            .scaledToFill()
            .frame(maxWidth: 50, maxHeight: 50)
            .clipShape(Circle())
            ._overlay()
            .shadow(radius: 3, x: 2, y: 2)
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
    Knock23()
}
