//
//  VideoCell.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct VideoCell: View {
    let videoData: VideoData
    @State var rect: CGRect = .zero
    let onTap: (VideoData, CGRect) -> Void
    var body: some View {
        VStack {
            GeometryReader { proxy in
                let _ = Task {
                    rect = proxy.frame(in: .global)
                }
                Image(uiImage: videoData.thumbnail).resizable().scaledToFill().frame(maxHeight: 200)
            }
            .onTapGesture {
                onTap(videoData, rect)
            }
            .frame(minHeight: 200).clipped()

            HStack(alignment: .top) {
                Image(uiImage: videoData.user.thumbnail).resizable().scaledToFit().frame(width: 25, height: 25).clipShape(Circle()).padding(.vertical, 4)
                VStack(alignment: .leading) {
                    Text(videoData.title).bold().font(.body).lineLimit(2)
                    HStack {
                        Text("\(videoData.user.name) - \(videoData.user.note)").font(.caption)
                    }
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .topLeading)

                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90), anchor: .center)
                    .frame(maxWidth: 10, maxHeight: 10)
                    .padding(.vertical, 8)

            }.padding(.horizontal)
        }
    }
}
