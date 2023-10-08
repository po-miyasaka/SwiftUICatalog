//
//  TagsView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/08.
//

import SwiftUI

struct TagsView: View {
    @ViewBuilder
    var body: some View {
        let arr = ["Beatbox", "Cat", "DBD", "Watched", "Recently uploaded"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8) {
                ForEach (arr, id: \.self) {
                    Text($0)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.gray) .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 4)
                    
                }
            }.padding(.horizontal, 8)
        }
        .background(Color.black)
        .frame(maxHeight: 36)
    }
}

#Preview {
    TagsView()
}
