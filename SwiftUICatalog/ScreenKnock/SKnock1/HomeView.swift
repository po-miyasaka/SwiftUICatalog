//
//  HomeView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var offsetObject: OffsetObject
    let playingVideoNameSpaceID: Namespace.ID
    @State var scrollOffset: CGFloat = .zero
    @ViewBuilder
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                GeometryReader { proxy in
                    ZStack(alignment: .bottom) {
                        ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom).padding()
                    }
                    let _ = Task {
                        scrollOffset = proxy.frame(in: .named("HomeView_ScrollView")).minY
                    }
                }
                .frame(height: 88)
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 32) {
                        ForEach(viewModel.recommendedObjects, id: \.self) { data in
                            switch data {
                            case let .ad(data):
                                AdCell(adData: data)
                            case let .shorts(data):
                                ShortsCell(shortsData: data, transition: { data in
                                    withAnimation {
                                        viewModel.shortsTransitionContext = .init(source: .homeView, data: data)
                                        offsetObject.showingMiniPlayer = true
                                    }

                                })
                            case let .video(data):
                                VideoCell(videoData: data, playingVideoNameSpaceID: nil) { video, rect in
                                    viewModel.select(video: video, rect: rect)
                                }
                            }
                        }
                    }

                    Color.black.frame(height: 50)
                }

            }.coordinateSpace(name: "HomeView_ScrollView")
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            HeaderView(attachedViewHeight: 44, attachedView: { TagsView() })
                .background(Color.black)
                .offset(y: min(0, scrollOffset))
        }
    }
}
