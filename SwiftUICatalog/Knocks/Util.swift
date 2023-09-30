//
//  Util.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Transform: View>(_ condition: Bool = true, @ViewBuilder transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

}
