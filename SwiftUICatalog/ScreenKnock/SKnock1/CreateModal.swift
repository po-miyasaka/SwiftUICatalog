//
//  CreateModal.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct CreateModal: View {
    var body: some View {
        let array: [(String, String)] = [
            ("folder.circle.fill", "Create a Short"),
            ("paperplane", "Upload a video"),
            ("studentdesk", "Go live"),
            ("person.2.crop.square.stack.fill", "Create a post"),
        ]

        VStack(spacing: 16) {
            ForEach(array, id: \.0) { data in
                HStack {
                    Image(systemName: data.0).resizable().renderingMode(.template).scaledToFit().frame(height: 25).foregroundColor(.gray)

                    Text(data.1).foregroundColor(.gray).padding().frame(maxWidth: .infinity, alignment: .leading)
                }
            }

        }
        .padding()
        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}
