//
//  MainView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import Combine
import SwiftUI

struct MainView<ViewModel: ViewModelProtocol>: View {
    @StateObject var viewModel:  ViewModel
    @StateObject var layoutObject: LayoutObject = .init()
    @Environment(\.layoutValues) var layoutValues: LayoutValues
    @Namespace var fullNameSpaceID
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue:
                                    viewModel)
    }
    
    typealias PageData = (title: String, imageName: String, tag: Page)
    let pageArray: [PageData] = [
        ("Home", "house", .home),
        ("Shorts", "mount", .shorts),
        ("", "plus.circle", .create),
        ("Subscription", "bell", .subscription),
        ("Library", "books.vertical", .library),
    ]
    
    var body: some View {

        ZStack {
            ZStack(alignment: .topLeading) {
                
                mainTabView
                if viewModel.output.playingVideo != nil {
                    PlayingView(layoutObject: layoutObject, viewModel: viewModel, fullNameSpaceID: fullNameSpaceID)
                    
                }
                if viewModel.output.shortsTransitionContext != nil {
                    ShortsView(viewModel: viewModel)
                }
                toolbarView
            }
            .ignoresSafeArea(edges: [.bottom])
            .modal(shouldShow: .init(get: { viewModel.output.shouldShowCreateModal }, set: { _ in
                viewModel.input.closeModal()
            })) {
                CreateModal()
            }
            
            if viewModel.output.isFull {
                MoviePlayerView(
                    showFullscreen: .init(get: { viewModel.output.isFull }, set: { _ in viewModel.input.hideFull()}),
                    playbackProgress: .init(get: {viewModel.output.playbackProgress}, set: { _ in }),
                    showingMiniPlayer: .constant(false),
                    viewModel: viewModel
                )
                .matchedGeometryEffect(id: "full", in: fullNameSpaceID, isSource: viewModel.output.isFull)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .rotationEffect(.degrees(90), anchor: .center)
                .ignoresSafeArea()
            }
            
        }
        
    }
}
