//
//  ShortsCell.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

public struct ShortData: Hashable {
    let title: String
    let imageName: String
    public init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }
}

public struct ShortsCell: View {
    let shortsData: [ShortData]
    let transition: (ShortData) -> Void
    public init(shortsData: [ShortData], transition: @escaping (ShortData) -> Void) {
        self.shortsData = shortsData
        self.transition = transition
    }
    public  var body: some View {
        VStack(alignment: .leading) {
            Text("Shorts").bold()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(shortsData, id: \.title) { shortData in
                        ZStack {
                            
                            Image(uiImage: UIImage(named: shortData.imageName)!)
                                .resizable().scaledToFill().frame(width: 200, height: 300)
                                .onTapGesture {
                                transition(shortData)
                            }
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90), anchor: .center)
                                .frame(width: 10, height: 10)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .padding()

                            VStack {
                                Text(shortData.title).foregroundColor(.white).bold().font(.body).lineLimit(2).shadow(radius: 2)
                                HStack {
                                    Text("392K views").font(.caption).bold()
                                }
                            }.padding()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                        }.clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            }
        }
    }
}
