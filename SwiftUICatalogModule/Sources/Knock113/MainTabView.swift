//
//  MainTabView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

extension MainView {
    
    
    @ViewBuilder
    var mainTabView: some View {
        
        TabView(selection: .init(get: {
            viewModel.output.current
        }, set: {
            viewModel.input.showPage(page: $0)
        })) {
            ForEach(pageArray, id: \.title) { data in

                Group {
                    GeometryReader { _ in
                        switch data.tag {
                        case .home:
                            HomeView(viewModel: viewModel ,layoutObject: layoutObject)
                        case .shorts, .create:
                            EmptyView()
                        case .subscription:
                            Text("")
                        case .library:
                            Text("")
                        }
                    }
                }
                .tag(
                    data.tag
                )
            }
        }.overlay(Color.black.frame(height: layoutObject.safeArea.top)
            .ignoresSafeArea(), alignment: .top)
    }
}
