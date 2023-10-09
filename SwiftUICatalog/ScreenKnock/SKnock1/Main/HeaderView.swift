//
//  HeaderView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct HeaderView<Attached: View>: View {
    var attachedViewHeight: CGFloat
    @ViewBuilder var attachedView: () -> Attached
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Button(action: {}, label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.square")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                        Text("YouTube")
                            .foregroundColor(.white)
                            .bold()
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)

                    }.onTapGesture {}
                })
                Image(systemName: "bell.badge")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
            }
            attachedView()
        }
        .frame(maxWidth: .infinity, minHeight: 44 + attachedViewHeight)
        .padding(8)
    }
}
