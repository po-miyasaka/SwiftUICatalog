//
//  MainView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import Combine
import SwiftUI

struct MainView: View {
    @StateObject var viewModel: ViewModel = .init()
    @StateObject var offsetObject: OffsetObject = .init()
    @Environment(\.safeArea) var safeArea
    @Environment(\.screenSize) var screenSize
    @State var cancellable: AnyCancellable?
    @Namespace var fullNameSpaceID
    @Namespace var playingNameSpaceID
    @State var animationFlag = false
    @State var animationID: UUID?
    let pageArray: [(title: String, imageName: String, tag: Page)] = [
        ("Home", "house", .home),
        ("Shorts", "mount", .shorts),
        ("", "plus.circle", .create),
        ("Subscription", "bell", .subscription),
        ("Library", "books.vertical", .library),
    ]

    var body: some View {
        let containerHeight = screenSize.height - toolbarHeight - safeArea().bottom - safeArea().top
        ZStack {
            ZStack(alignment: .topLeading) {
                VStack {
                    mainTabView
                }
                if let video = viewModel.playingVideo {
                    PlayingView(viewModel: viewModel, offsetObject: offsetObject, fullNameSpaceID: fullNameSpaceID, playingVideoNameSpaceID: playingNameSpaceID)
                        .onAppear {
                            if viewModel.shouldReloadVideoIncrement > 1 {
                                offsetObject.offset = viewModel.rect.minY - safeArea().top
                                offsetObject.showingMiniPlayer = false
                            } else {
                                offsetObject.offset = 0
                                offsetObject.currentOffset = 0
                            }
                        }
                        .onChange(of: viewModel.shouldReloadVideoIncrement, perform: { _ in
                            // onAppearのときはよばれない。
                            offsetObject.offset = viewModel.rect.minY - safeArea().top
                            offsetObject.showingMiniPlayer = false
                        })
                }
                if viewModel.shortsTransitionContext != nil {
                    ShortsView(
                        transitionContext: $viewModel.shortsTransitionContext
                    )
                    .transition(.asymmetric(insertion: .backslide, removal: .slide)).zIndex(viewModel.shortsTransitionContext?.source == .tabButton ? 0 : 1)
                    .ignoresSafeArea(edges: [.top])
                }
                toolbarView
                    .frame(maxWidth: screenSize.width,
                           maxHeight: .infinity, alignment: .bottom)
                    .offset(y: (viewModel.playingVideo != nil) ? max(containerHeight - offsetObject.offset - toolbarHeight, 0) : 0)
                    .zIndex(2)
            }
            .ignoresSafeArea(edges: [.bottom])
            .modifier(AnimationShowModifier(showing: $viewModel.shouldShowCreateModal, v: {
                CreateModal()
            }))

            if viewModel.isFull {
                MoviePlayerView(showFullscreen: $viewModel.isFull, playbackProgress: $viewModel.playbackProgress, showingMiniPlayer: .constant(false), viewModel: viewModel)
                    .matchedGeometryEffect(id: "full", in: fullNameSpaceID, isSource: viewModel.isFull)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                    .rotationEffect(.degrees(viewModel.isFull ? 90 : 0), anchor: .center)
                    .background(Color.black)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    MainView()
}
