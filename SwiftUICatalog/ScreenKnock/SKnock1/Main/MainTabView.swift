//
//  MainTabView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

extension MainView {
    enum Page: Hashable {
        case home
        case shorts
        case create
        case subscription
        case library
    }
    
    @ViewBuilder
    var mainTabView: some View {
        
        TabView(selection: $viewModel.current) {
            ForEach(pageArray, id: \.title) { data in

                Group {
                    GeometryReader  { proxy in
                        switch data.tag {
                        case .home:
                            HomeView(viewModel: viewModel, offsetObject: offsetObject,  playingVideoNameSpaceID: playingNameSpaceID)
                        case .shorts:
                            Text("")
                        case .create:
                            Text("")
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
        }.overlay(Color.black.frame(height: safeArea().top).ignoresSafeArea(), alignment: .top)
    }
}

#Preview {
    MainView()
}
