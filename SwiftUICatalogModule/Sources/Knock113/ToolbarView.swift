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
        
        VStack {
            
            HStack(alignment: .top, spacing: 0) {
                ForEach(pageArray, id: \.title) { page in
                    Button(action: {
                        tapAction(page: page)
                    }, label: {
                        if case .create = page.tag {
                            Image(systemName: page.imageName)
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 33, height: 33)
                        } else {
                            VStack {
                                Image(systemName: page.imageName).resizable()
                                    .scaledToFit()
                                    .frame(height: 22)
                                    .foregroundColor(.gray)
                                Text(page.title)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    })
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                }
            }
            Color.black.frame(height: layoutObject.safeArea.bottom)
        }
        
        .background(Color.black)
        .frame(height: layoutObject.toolbarHeight)
        .frame(maxWidth: layoutObject.screenSize.width,
               maxHeight: .infinity,
               alignment: .bottom)
        .offset(y: (viewModel.output.playingVideo != nil) ? layoutObject.toolbarMinY : 0)
        .zIndex(2)
    }
    
    func tapAction(page: PageData) {
        if page.tag == .create {
            viewModel.input.showCreateModal()
            
        } else if page.tag == .shorts {
            viewModel.input.showPage(page: page.tag)
            viewModel.input.showShort(.init(source: .tabButton, data: .init(title: "Shorts", imageName: "short1")))
        } else {
            viewModel.input.showPage(page: page.tag)
            viewModel.input.hideShort()
        }
        
    }
}
