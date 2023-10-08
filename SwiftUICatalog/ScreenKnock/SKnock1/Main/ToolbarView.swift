//
//  ToolbarView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

extension MainView {
    @ViewBuilder
    var toolbarView: some View {
        GeometryReader { _ in
            VStack {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(pageArray, id: \.title) { page in
                        Button(action: {
                            if page.tag == .create {
                                viewModel.shouldShowCreateModal = true

                            } else if page.tag == .shorts {
                                viewModel.current = page.tag
                                viewModel.shortsTransitionContext = .init(source: .tabButton, data: .init(title: "Shorts", color: .red))
                            } else {
                                viewModel.current = page.tag
                                viewModel.shortsTransitionContext = nil
                            }
                        }, label: {
                            if case .create = page.tag {
                                Image(systemName: page.imageName)
                                    .resizable()
                                    .foregroundColor(.gray).frame(width: 33, height: 33)
                            } else {
                                VStack {
                                    Image(systemName: page.imageName).resizable().scaledToFit().frame(height: 22).foregroundColor(.gray)
                                    Text(page.title).foregroundColor(.gray).font(.caption)
                                }
                            }
                        }).frame(maxWidth: .infinity)
                            .padding(.top, 8)
                    }
                }
                Color.black.frame(height: safeArea().bottom)
            }
        }.background(Color.black).frame(height: safeArea().bottom + toolbarHeight)
    }
}
