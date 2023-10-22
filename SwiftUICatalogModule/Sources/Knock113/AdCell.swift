//
//  AdCell.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

public struct AdData: Hashable {
    public let title: String
    public let color: Color
    public init(title: String, color: Color) {
        self.title = title
        self.color = color
    }
}

public struct AdCell: View {
    let adData: AdData
    public init(adData: AdData) {
        self.adData = adData
    }
    public var body: some View {
        VStack {
            adData.color.frame(height: 300)
            HStack {
                Text("詳細").font(.caption).bold().frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "rectangle.portrait.and.arrow.forward")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(height: 14)
                    .foregroundColor(.blue)
            }.background(Color.black)
                .padding(.horizontal)

            HStack {
                Image("kabigon3").resizable().scaledToFit().frame(maxWidth: 20, maxHeight: 20).clipShape(Circle())
                VStack(alignment: .leading) {
                    Text("Ad Title").bold().font(.body).lineLimit(1)
                    Text("Firebase is an app development platform that helps you build and grow apps and games users love. Backed by Google and trusted by millions of businesses around the world.").font(.caption).lineLimit(2)
                    HStack {
                        Text("Sponserd・").font(.caption).bold()
                        Text("Firebase").font(.caption)
                    }
                }
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                Image(systemName: "chevron.down").frame(maxWidth: 10, maxHeight: 10)
            }.padding(.horizontal)
        }
    }
}
