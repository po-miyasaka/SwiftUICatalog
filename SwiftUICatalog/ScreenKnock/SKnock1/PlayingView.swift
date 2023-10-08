//
//  PlayingView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI
import Combine
struct PlayingView: View {
    @Environment(\.safeArea) var safeArea
    @Environment(\.screenSize) var screenSize
    @State var defaultVideoHeight: CGFloat = 250
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var offsetObject: OffsetObject
    @State var cancellable: AnyCancellable?
    let fullNameSpaceID: Namespace.ID
    let playingVideoNameSpaceID: Namespace.ID
    @State var shouldShowThumbnail: Bool = true
    @ViewBuilder
    
    var body: some View {
        let containerHeight = screenSize.height - toolbarHeight - safeArea().bottom - safeArea().top
        let shrinkThreshold: CGFloat = containerHeight / 1.4
        let overShrinkThreshold = shrinkThreshold < offsetObject.offset
        
        
        let videoHeight = max(
            miniVideoHeight, defaultVideoHeight - (
                overShrinkThreshold ? (defaultVideoHeight * ((offsetObject.offset - shrinkThreshold) / (containerHeight - shrinkThreshold) )) : 0)
        )
        
        let videoWidth = max(
            miniVideoWidth(screenWidth: screenSize.width) ,
            screenSize.width - (overShrinkThreshold ? containerHeight * ((offsetObject.offset - shrinkThreshold) / (containerHeight  - shrinkThreshold) ) : 0)
        )
        
        let playViewHeight = max(100, screenSize.height - videoHeight - offsetObject.offset)
        let playViewOpacity = max(0, 1 - (offsetObject.offset / (screenSize.height  - toolbarHeight)))
        
        VStack(alignment: .leading, spacing: 0) {
            
            videoView(videoWidth: videoWidth, videoHeight: videoHeight)
                
                .offset(y: offsetObject.offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            offsetObject.offset = offsetObject.currentOffset + value.translation.height
                        }
                        .onEnded { _ in
                            let previousValue = offsetObject.showingMiniPlayer
                            let threshold = offsetObject.showingMiniPlayer ? containerHeight / 1.1 : containerHeight / 10
                            let shouldMini = offsetObject.offset >= threshold
                            
                            let noChange = previousValue == shouldMini
                            
                            if noChange {
                                offsetObject.offset  = offsetObject.currentOffset
                            } else if  offsetObject.offset <= threshold {
                                offsetObject.showingMiniPlayer = false
                            } else {
                                offsetObject.showingMiniPlayer = true
                            }
                        }
                )
            VideoDetailView(viewModel: viewModel, offsetObject: offsetObject)
                .offset(y: offsetObject.offset)
            .frame(maxHeight: max(0, playViewHeight))
            
        }
        .onChange(of: offsetObject.showingMiniPlayer, perform: { value in
            
            if value {
                offsetObject.currentOffset = screenSize.height - toolbarHeight - safeArea().bottom - miniVideoHeight - safeArea().top
                cancellable?.cancel()
                cancellable =  Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink(receiveValue: { _ in
                    if offsetObject.offset >= offsetObject.currentOffset {
                        cancellable?.cancel()
                        offsetObject.offset = offsetObject.currentOffset
                    } else {
                        offsetObject.offset += 20
                    }
                    
                })
            } else {
                offsetObject.currentOffset = 0
                cancellable?.cancel()
                cancellable =  Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink(receiveValue: { _ in
                    if offsetObject.offset <= offsetObject.currentOffset {
                        
                        cancellable?.cancel()
                        offsetObject.offset = offsetObject.currentOffset
                    } else {
                        offsetObject.offset -= 20
                    }
                    
                })
            }
            
        })
    }
    
    func videoView(videoWidth: CGFloat, videoHeight: CGFloat) -> some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 32) {
                
                Color.black.frame(width: miniVideoWidth(screenWidth: screenSize.width), height: miniVideoHeight)
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
                        viewModel.pause()
                    }
                
                
                Image(systemName: "xmark").resizable().scaledToFit()
                    .frame(maxHeight: 24)
                    .onTapGesture {
                        viewModel.playingVideo = nil
                    }
                
            }
            .padding(.trailing)
            .frame(maxWidth: screenSize.width, maxHeight: videoHeight, alignment: .top)
            
            
            ZStack {
                MoviePlayerView(showFullscreen: $viewModel.isFull, playbackProgress: $viewModel.playbackProgress, showingMiniPlayer: $offsetObject.showingMiniPlayer, viewModel: viewModel)
                    .matchedGeometryEffect(id: "full", in: fullNameSpaceID, isSource: !viewModel.isFull)
                
                    .frame(maxWidth: videoWidth, maxHeight: videoHeight, alignment: .center)
                
                    .onTapGesture {
                        if offsetObject.showingMiniPlayer {
                            offsetObject.showingMiniPlayer = false
                        }
                    }
                    .onChange(of: viewModel.shouldReloadVideoIncrement, perform: { _ in
                        shouldShowThumbnail = true
                    })
                if let image = viewModel.playingVideo?.thumbnail, shouldShowThumbnail {
                    Image(uiImage: image).resizable().scaledToFill()
                        .frame(maxWidth: videoWidth, maxHeight: videoHeight, alignment: .center).clipped().allowsHitTesting(false)
                        .onAppear {
                            Task {
                                try await Task.sleep(nanoseconds:800_000_000)
                                    shouldShowThumbnail = false
                            }
                        }
                }
                
                
            }
        }
        .background(Color.black)
        .frame(maxWidth: screenSize.width, maxHeight: videoHeight, alignment: .top)
        
    }
    
    
}

struct VideoDetailView: View, Animatable {
    @Environment(\.screenSize) var screenSize
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var offsetObject: OffsetObject
    
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
            
            let pointY = min(0, max(-44, threshold + abs(scrollOffset)  ))
            
            tagsView.offset(
                y: pointY
            ).clipShape(Rectangle().size(.init(width: screenSize.width, height: 44)))
        }
        .background(Color.black)
        .frame(maxWidth: screenSize.width, alignment: .center)
        .ignoresSafeArea()
        .coordinateSpace(name: "VideoDetail")
        
        
        
    }
    
    @ViewBuilder
    var tagsView: some View {
        let arr = ["Beatbox", "Cat", "DBD", "Watched", "Recently uploaded"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 8) {
                ForEach (arr, id: \.self) {
                    Text($0)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.white.opacity(0.2)) .clipShape(RoundedRectangle(cornerRadius: 8))
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
            
        }.padding(.top, 8)
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
                    
                    
                    Button(action: {
                        
                    }, label: {
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
    
    var recommendedView: some View {
        LazyVStack(alignment: .leading, spacing: 32) {
            ForEach(viewModel.recommendedObjects, id: \.self) { data in
                switch data {
                case .ad(let data):
                    AdCell(adData: data)
                case .shorts(let data):
                    ShortsCell(shortsData: data, transition: { data in
                        withAnimation
                        {
                            viewModel.shortsTransitionContext = .init(source: .playingView, data: data)
                            offsetObject.showingMiniPlayer = true
                        }
                        
                    })
                case .video(let data):
                    VideoCell(videoData: data, playingVideoNameSpaceID: nil) { video, _ in
                        viewModel.select(video: video, rect: .zero)
                    }
                }
            }
        }
    }
}
