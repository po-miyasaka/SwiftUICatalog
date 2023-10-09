//
//  PlayingView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import Combine
import SwiftUI
struct PlayingView<ViewModel: ViewModelProtocol>: View {
    @ObservedObject var layoutObject: LayoutObject
    @ObservedObject var viewModel: ViewModel
    @State var shouldShowThumbnail: Bool = true
    let fullNameSpaceID: Namespace.ID
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                videoView()
                    .offset(y: layoutObject.offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                layoutObject.updateOffset(transition: value.translation)
                            }
                            .onEnded { _ in
                                layoutObject.dragEnd()
                            }
                    )
                
                VideoDetailView(viewModel: viewModel, layoutObject: layoutObject)
                    .offset(y: layoutObject.offset)
                    .frame(maxHeight: max(0, layoutObject.playViewHeight))
            }
        }
    }
    
    func videoView() -> some View {
        
        ZStack(alignment: .leading) {
            
            HStack(alignment: .center, spacing: 32) {
                Color.black
                    .frame(
                        width: layoutObject.miniVideoWidth,
                        height: layoutObject.miniVideoHeight)
                VStack(alignment: .leading) {
                    Text("Video title").font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                    Text("User name").font(.caption).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(alignment: .leading)
                .frame(maxWidth: .infinity)
                
                Image(systemName: "play.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 24)
                    .onTapGesture {
                        viewModel.input.pause()
                    }
                
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 24)
                    .onTapGesture {
                        viewModel.input.closeVideo()
                    }
            }
            .padding(.trailing)
            .frame(maxWidth: layoutObject.screenSize.width,
                   maxHeight: layoutObject.videoHeight, alignment: .top)
            
            ZStack {
                MoviePlayerView(
                    showFullscreen: .init(
                        get: { viewModel.output.isFull },
                        set: { _ in  viewModel.input.showFull()}),
                    playbackProgress: .init(
                        get: { viewModel.output.playbackProgress },
                        set: { viewModel.input.updateProgress($0) }),
                    showingMiniPlayer: .init(get: { layoutObject.showingMiniPlayer },
                                             set: { _ in }),
                    viewModel: viewModel
                )
                .onTapGesture {
                    if layoutObject.showingMiniPlayer {
                        layoutObject.updatePlayingVideoLayout(shouldMinify: false)
                    }
                }
                .matchedGeometryEffect(id: "full",
                                       in: fullNameSpaceID,
                                       isSource: !viewModel.output.isFull)
                
                .frame(maxWidth: layoutObject.videoWidth,
                       maxHeight: layoutObject.videoHeight,
                       alignment: .center)
                .onChange(of: viewModel.output.shouldReloadVideoIncrement) { _ in
                    shouldShowThumbnail = true
                }
                
                if let image = viewModel.output.playingVideo?.thumbnail, shouldShowThumbnail {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(maxWidth: layoutObject.videoWidth, maxHeight: layoutObject.videoHeight, alignment: .center).clipped().allowsHitTesting(false)
                        .onAppear {
                            Task {
                                try await Task.sleep(nanoseconds: 800_000_000)
                                shouldShowThumbnail = false
                            }
                        }
                }
            }
        }
        .background(Color.black)
        .frame(maxWidth: layoutObject.screenSize.width, maxHeight: layoutObject.videoHeight, alignment: .top)
        
        
        
    }
}

struct VideoDetailView<ViewModel: ViewModelProtocol>: View, Animatable {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var layoutObject: LayoutObject
    @State var scrollOffset: CGFloat = .zero
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(showsIndicators: false) {
                GeometryReader { proxy in
                    let _ = Task {
                        scrollOffset = proxy.frame(in: .named("VideoDetail")).minY
                    }
                    Color.clear
                }.frame(height: .zero)
                
                ZStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 16) {
                        titleView
                        userView
                        buttonsView
                        commentView
                        recommendedView
                        Color.black.frame(height: 50)
                    }
                    .foregroundColor(.white)
                }
            }
            let threshold: CGFloat = -300
            
            let pointY = min(0, max(-44, threshold + abs(scrollOffset)))
            
            tagsView.offset(
                y: pointY
            ).clipShape(Rectangle().size(.init(width: layoutObject.screenSize.width, height: 44)))
        }
        .background(Color.black)
        .frame(maxWidth: layoutObject.screenSize.width, alignment: .center)
        .ignoresSafeArea()
        .coordinateSpace(name: "VideoDetail")
    }
    
    @ViewBuilder
    var tagsView: some View {
        let arr = ["Beatbox", "Cat", "DBD", "Watched", "Recently uploaded"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8) {
                ForEach(arr, id: \.self) {
                    Text($0)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.white.opacity(0.2)).clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.vertical, 8)
                }
            }.padding(.horizontal, 8)
        }
        .background(Color.black)
        .frame(maxHeight: 44)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Text("Video Title").font(.headline).bold()
            HStack {
                Text("1.4M views").font(.caption)
                Text("10 mo ago").font(.caption)
                Text("...more").font(.caption).bold()
            }
            
        }
        .padding(.top, 8)
            .onTapGesture {
                
            }
    }
    
    var userView: some View {
        HStack {
            Image("kabigon2").resizable().scaledToFit().frame(maxWidth: 33, maxHeight: 33).clipShape(Circle())
            Text("Youtuber Name").font(.body).frame(maxWidth: .infinity, alignment: .leading)
            Text("1.45M").font(.caption).bold()
            
            HStack {
                Image(systemName: "bell").resizable().scaledToFit().frame(maxWidth: 14, maxHeight: 14)
                Image(systemName: "chevron.down").resizable().scaledToFit().frame(maxWidth: 14, maxHeight: 14)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
        }
    }
    
    @ViewBuilder
    var buttonsView: some View {
        let dataArray: [(imageName: String, text: String)] = [
            ("arrowshape.turn.up.right", "Share"),
            ("pencil.tip.crop.circle.badge.plus", "Remix"),
            ("arrow.down.circle", "Download"),
            ("scissors", "Clip"),
            ("plus.square.on.square", "Save"),
        ]
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                rateButton
                
                ForEach(dataArray, id: \.text) { data in
                    
                    Button(action: {}, label: {
                        HStack(spacing: 4) {
                            Image(systemName: data.imageName)
                                .resizable().scaledToFit()
                                .frame(maxWidth: 14, maxHeight: 14)
                            Text(data.text).font(.caption).bold().frame(maxWidth: .infinity).layoutPriority(1)
                        }
                    })
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Capsule())
                }
            }
            
        }.frame(maxHeight: 30)
    }
    
    var rateButton: some View {
        HStack(spacing: 8) {
            Button(action: {}, label: {
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .resizable().scaledToFit().frame(maxWidth: 14, maxHeight: 14)
                    Text("25K").font(.caption).bold().frame(maxWidth: .infinity).layoutPriority(1)
                }
            })
            
            Divider()
            Button(action: {}, label: {
                Image(systemName: "hand.thumbsdown").resizable().scaledToFit().frame(maxWidth: 14, maxHeight: 14)
            })
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(Color.white.opacity(0.2))
        .clipShape(Capsule())
    }
    
    var commentView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                Text("Comments").bold()
                Text("1.2K").font(.caption)
            }
            HStack {
                Image("kabigon3").resizable().scaledToFit().frame(maxWidth: 20, maxHeight: 20).clipShape(Circle())
                Text("I think this is my favourite set yet, there's a certain energy in every song that really brings the entire thing together.  Love it, as always.").lineLimit(2)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                Image(systemName: "chevron.down").frame(maxWidth: 10, maxHeight: 10)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    var recommendedView: some View {
        LazyVStack(alignment: .leading, spacing: 32) {
            ForEach(viewModel.output.recommendedObjects, id: \.self) { data in
                switch data {
                case let .ad(adData):
                    AdCell(adData: adData)
                case let .shorts(data):
                    ShortsCell(shortsData: data, transition: { data in
                        withAnimation {
                            viewModel.input.showShort(.init(source: .playingView, data: data))
                            layoutObject.updatePlayingVideoLayout(shouldMinify: true)
                        }
                        
                    })
                case let .video(data):
                    VideoCell(videoData: data) { video, _ in
                        viewModel.input.select(video: video, tappedImageRect: .zero)
                    }
                }
            }
        }
    }
}
