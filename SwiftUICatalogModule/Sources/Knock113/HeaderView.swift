//
//  HeaderView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

public struct HeaderView<Attached: View>: View {
    public var attachedViewHeight: CGFloat
    @ViewBuilder public var attachedView: () -> Attached
    public let headerViewHeight: CGFloat = 44
    public  init(attachedViewHeight: CGFloat, attachedView: @escaping () -> Attached) {
        self.attachedViewHeight = attachedViewHeight
        self.attachedView = attachedView
    }
    public  var body: some View {
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
        .frame(maxWidth: .infinity, minHeight: headerViewHeight + attachedViewHeight)
        .padding(8)
    }
}
