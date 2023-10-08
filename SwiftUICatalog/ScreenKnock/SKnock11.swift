//
//  SKnock.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/04.
//

import AVFoundation
import AVKit
import Combine
import SwiftUI
import UIKit

enum SKnock1 {
    enum Page: Hashable {
        case home
        case shorts
        case create
        case subscription
        case library
    }

    struct ContentView: View {
        @State var current: Page = .home
        @StateObject var viewModel: viewModel = .init()
        @State var offset: CGFloat = .zero
        @State var viewSize: CGSize = .init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        @State var currentOffset: CGFloat = .zero
        let defaultVideoHeight: CGFloat = 400
        @State var toolbarHeight: CGFloat = 50
        @State var miniVideoHeight: CGFloat = 50
        @State var safeAreaBottomHeight: CGFloat = 0
        @State var safeAreaTopHeight: CGFloat = 0
        @State var miniVideoWidth: CGFloat = 0
        @State var cancellable: AnyCancellable?
        @State var shortsTransitionContext: ShortsTransitionContext?
        @State var playbackProgress: Double = 0.0
        @State var isFull: Bool = false

        @State var mini: Bool = false
        @Namespace var full

        var isMini: Bool {
            currentOffset != 0
        }

        let pageArray: [(title: String, imageName: String, tag: Page)] = [
            ("Home", "house", .home),
            ("Shorts", "mount", .shorts),
            ("", "plus.circle", .create),
            ("Subscription", "bell", .subscription),
            ("Library", "books.vertical", .library),
        ]

        var body: some View {
            let containerHeight = viewSize.height - toolbarHeight - safeAreaBottomHeight - safeAreaTopHeight
            ZStack {
                ZStack(alignment: .topLeading) {
                    VStack {
                        headerView
                        mainTabView
                    }
                    if viewModel.video != nil {
                        playingView.onAppear {
                            mini = false
                        }
                    }
                    shortsView
                    toolbarView
                        .frame(maxWidth: viewSize.width, maxHeight: .infinity, alignment: .bottom)
                        .offset(y: (viewModel.video != nil) ? max(containerHeight - offset - toolbarHeight, 0) : 0)
                        .zIndex(2)
                }
                .ignoresSafeArea(edges: [.bottom])
                //            .ignoresSafeArea([.top])
                .onAppear(perform: {
                    let insets = getSafeAreaBottom()
                    safeAreaTopHeight = insets.top
                    safeAreaBottomHeight = insets.bottom
                    miniVideoWidth = viewSize.width * 0.4
                    mini = true
                })

                if isFull {
                    MoviePlayerView(showFullscreen: $isFull, playbackProgress: $playbackProgress)
                        .matchedGeometryEffect(id: "full", in: full, isSource: isFull)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

                        .rotationEffect(.degrees(isFull ? 90 : 0), anchor: .center)
                        .background(Color.black)
                        .ignoresSafeArea()
                }
            }
            .onChange(of: mini, perform: { value in

                if value {
                    currentOffset = viewSize.height - toolbarHeight - safeAreaBottomHeight - miniVideoHeight - safeAreaTopHeight
                    cancellable?.cancel()
                    cancellable = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink(receiveValue: { _ in
                        if offset >= currentOffset {
                            cancellable?.cancel()
                            offset = currentOffset
                        } else {
                            offset += 20
                        }

                    })
                } else {
                    currentOffset = 0
                    cancellable?.cancel()
                    cancellable = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink(receiveValue: { _ in
                        if offset <= currentOffset {
                            cancellable?.cancel()
                            offset = currentOffset
                        } else {
                            offset -= 20
                        }

                    })
                }

            })
        }

        var headerView: some View {
            HStack(spacing: 0) {
                Button(action: {}, label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.square")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.red)
                        Text("YouTube").foregroundColor(.white).bold().font(.title).frame(maxWidth: .infinity, alignment: .leading)

                    }.onTapGesture {}
                })
                Image(systemName: "bell.badge")
            }
            .frame(minHeight: 44)
            .frame(maxWidth: .infinity)
            .padding(8)
        }

        var toolbarView: some View {
            GeometryReader { _ in

                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(pageArray, id: \.title) { page in
                            Button(action: {
                                current = page.tag
                                if current == .shorts {
                                    shortsTransitionContext = .tabButton
                                } else {
                                    shortsTransitionContext = nil
                                }
                            }, label: {
                                if case .create = page.tag {
                                    Image(systemName: page.imageName)
                                        .resizable()
                                        .foregroundColor(.gray).frame(width: 33, height: 33)
                                } else {
                                    VStack {
                                        Image(systemName: page.imageName).foregroundColor(.gray)
                                        Text(page.title).foregroundColor(.gray).font(.caption)
                                    }
                                }
                            }).frame(maxWidth: .infinity)
                        }
                    }.padding(.top, 4)
                    Color.black.frame(height: safeAreaBottomHeight)
                }
            }.background(Color.black).frame(height: safeAreaBottomHeight + toolbarHeight)
        }

        @ViewBuilder
        var shortsView: some View {
            if shortsTransitionContext != nil {
                ShortsView(
                    height: viewSize.height - safeAreaBottomHeight - toolbarHeight,
                    safeAreaTopHeight: safeAreaTopHeight,
                    shortsTransitionContext: $shortsTransitionContext
                )

                .transition(.asymmetric(insertion: .backslide, removal: .slide)).zIndex(shortsTransitionContext == .tabButton ? 0 : 1)
                .ignoresSafeArea(edges: [.top])
            }
        }

        func getSafeAreaBottom() -> UIEdgeInsets {
            let keyWindow: UIWindow? = UIApplication.shared.windows
                .filter { $0.isKeyWindow }.first

            let result = (keyWindow?.safeAreaInsets) ?? .zero
            return result
        }

        #warning("こんな感じの切り出しどなの")
        var mainTabView: some View {
            TabView(selection: $current) {
                ForEach(pageArray, id: \.title) { data in
                    #warning("arrayにView含めたいけどAnyView使いたくない。")
                    Group {
                        GeometryReader { _ in
                            switch data.tag {
                            case .home:
                                HomeView(shortsTransitionContext: $shortsTransitionContext, viewModel: viewModel)

                            case .shorts:
                                Text("")
                            case .create:
                                Text("Create")
                            case .subscription:
                                Text("Subscription")
                            case .library:
                                Text("Library")
                            }
                        }
                    }
                    .tag(
                        data.tag
                    )
                }
            }
        }

        @ViewBuilder
        var playingView: some View {
            let containerHeight = viewSize.height - toolbarHeight - safeAreaBottomHeight - safeAreaTopHeight
            let shrinkThreshold: CGFloat = containerHeight / 1.4
            let overShrinkThreshold = shrinkThreshold < offset

            let videoHeight = max(
                miniVideoHeight, defaultVideoHeight - (
                    overShrinkThreshold ? (defaultVideoHeight * ((offset - shrinkThreshold) / (containerHeight - shrinkThreshold))) : 0)
            )

            let videoWidth = max(
                miniVideoWidth,
                viewSize.width - (overShrinkThreshold ? containerHeight * ((offset - shrinkThreshold) / (containerHeight - shrinkThreshold)) : 0)
            )

            let playViewHeight = max(100, viewSize.height - videoHeight - offset)
            let playViewOpacity = max(0, 1 - (offset / (viewSize.height - toolbarHeight)))

            VStack(alignment: .leading, spacing: 0) {
                videoView(videoWidth: videoWidth, videoHeight: videoHeight)
                    .offset(y: offset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                offset = currentOffset + value.translation.height
                            }
                            .onEnded { _ in
                                let previousValue = isMini
                                let threshold = isMini ? containerHeight / 1.1 : containerHeight / 10
                                let shouldMini = offset >= threshold

                                let noChange = previousValue == shouldMini

                                if noChange {
                                    offset = currentOffset
                                } else if offset <= threshold {
                                    mini = false
                                } else {
                                    mini = true
                                }
                            }
                    )

                VideoDetailView(
                    viewModel: viewModel, shortsTransitionContext: $shortsTransitionContext,
                    mini: $mini,
                    viewSize: viewSize
                )
                .offset(y: offset)
                .frame(maxHeight: max(0, playViewHeight))
                //                        .opacity(playViewOpacity)
            }
        }

        #warning("ボタンで囲むと画像のサイズに影響がある。。")
        #warning("普通にvideoWidthを設定すると隠れているときに文字がつぶれているせいかラベルにだけアニメーションがきかない")
        func videoView(videoWidth: CGFloat, videoHeight: CGFloat) -> some View {
            ZStack(alignment: .leading) {
                HStack(alignment: .center, spacing: 32) {
                    Color.black.frame(width: miniVideoWidth, height: miniVideoHeight)
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
                            UIMovieView.player.pause()
                        }

                    Image(systemName: "xmark").resizable().scaledToFit()
                        .frame(maxHeight: 24)
                        .onTapGesture {
                            viewModel.video = nil
                        }
                }
                .padding(.trailing)
                .frame(maxWidth: viewSize.width, maxHeight: videoHeight, alignment: .top)

                ZStack {
                    MoviePlayerView(showFullscreen: $isFull, playbackProgress: $playbackProgress)
                        .matchedGeometryEffect(id: "full", in: full, isSource: !isFull)
                        .frame(maxWidth: videoWidth, maxHeight: videoHeight, alignment: .center)

                        .onTapGesture {
                            if isMini {
                                mini = false
                            }
                        }
                }
            }
            .background(Color.black)
            .frame(maxWidth: viewSize.width, maxHeight: videoHeight, alignment: .top)
        }
    }

    struct VideoDetailView: View, Animatable {
        @ObservedObject var viewModel: viewModel
        @Binding var shortsTransitionContext: ShortsTransitionContext?
        @Binding var mini: Bool

        var viewSize: CGSize
        @State var offset: CGFloat = .zero
        var body: some View {
            ZStack(alignment: .top) {
                ScrollView(showsIndicators: false) {
                    GeometryReader { proxy in
                        let _ = Task {
                            offset = proxy.frame(in: .named("VideoDetail")).minY
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
                        }.padding(.horizontal)
                            .foregroundColor(.white)
                        //                        .offset(y: min(abs(offset) - nazoMarginOfScroll, -400 + abs(offset) + abs(offset)))
                    }
                }
                let threshold: CGFloat = -300

                let pointY = min(0, max(-44, threshold + abs(offset)))

                TagsView().offset(
                    y: pointY
                ).clipShape(Rectangle().size(.init(width: viewSize.width, height: 44)))
            }
            .background(Color.black)
            .frame(maxWidth: viewSize.width, alignment: .center)
            .ignoresSafeArea()
            .coordinateSpace(name: "VideoDetail")
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
                .background(Color.gray)
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
                            .background(Color.gray)
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
            .background(Color.gray)
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
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }

        var recommendedView: some View {
            LazyVStack(alignment: .leading, spacing: 32) {
                ForEach(viewModel.recommendedObjects, id: \.self) { data in
                    switch data {
                    case let .ad(data):
                        AdCell(adData: data)
                    case let .shorts(data):
                        ShortsCell(shortsData: data, transition: {
                            withAnimation {
                                shortsTransitionContext = .playingView
                                mini = true
                            }

                        })
                    case let .video(data):
                        VideoCell(videoData: data)
                    }
                }
            }
        }
    }

    class viewModel: NSObject, ObservableObject {
        @Published var video: Video?
        @Published var recommendedObjects: [RecommendedType] = [
            .ad(.init(title: "ad1", color: .purple)),
            .video(.init(title: "video1", color: .red)),
            .video(.init(title: "video2", color: .green)),
            .video(.init(title: "video3", color: .blue)),
            .video(.init(title: "video4", color: .purple)),
            .shorts(
                [
                    .init(title: "short1", color: .yellow),
                    .init(title: "short2", color: .gradient01),
                    .init(title: "short3", color: .white),
                    .init(title: "short4", color: .green),
                    .init(title: "short5", color: .orange),
                    .init(title: "short6", color: .gradient03),
                    .init(title: "short7", color: .white),
                    .init(title: "short8", color: .red),
                    .init(title: "short9", color: .yellow),
                    .init(title: "short10", color: .red),
                ]
            ),
            .video(.init(title: "video5", color: .red)),
            .video(.init(title: "video6", color: .green)),
            .video(.init(title: "video7", color: .blue)),
            .video(.init(title: "video8", color: .purple)),
            .video(.init(title: "video9", color: .white)),
            .ad(.init(title: "ad1", color: .pink)),
            .video(.init(title: "video10", color: .green)),
            .video(.init(title: "video11", color: .gray)),
            .shorts(
                [
                    .init(title: "short11", color: .yellow),
                    .init(title: "short12", color: .gradient01),
                    .init(title: "short13", color: .white),
                    .init(title: "short14", color: .green),
                    .init(title: "short15", color: .orange),
                    .init(title: "short16", color: .gradient03),
                    .init(title: "short17", color: .red),
                    .init(title: "short18", color: .blue),
                    .init(title: "short19", color: .green),
                    .init(title: "short20", color: .red),
                ]
            ),
        ]
    }

    class Video {
        var thumbnail: UIImage = .init(named: "kabigon")!
        var videoItem: AVPlayerItem = {
            var videoName: String = "movie"
            var videoType: String = "mp4"

            let url = Bundle.main.url(forResource: videoName, withExtension: videoType)!
            return AVPlayerItem(url: url)
        }()
    }

    enum RecommendedType: Hashable {
        case ad(AdData)
        case video(VideoData)
        case shorts([ShortData])
    }

    struct AdData: Hashable {
        let title: String
        let color: Color
    }

    struct VideoData: Hashable {
        let title: String
        let color: Color
    }

    struct ShortData: Hashable {
        let title: String
        let color: Color
    }

    struct VideoCell: View {
        let videoData: VideoData
        var body: some View {
            VStack {
                videoData.color.frame(height: 200)
                HStack(alignment: .top) {
                    Image("kabigon2").resizable().scaledToFit().frame(width: 25, height: 25).clipShape(Circle()).padding(.vertical, 4)
                    VStack(alignment: .leading) {
                        Text(videoData.title).bold().font(.body).lineLimit(2)
                        HStack {
                            Text("RJ Pasin - Topic・65K views・1 days ago").font(.caption)
                        }
                    }
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .topLeading)

                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90), anchor: .center)
                        .frame(maxWidth: 10, maxHeight: 10)
                        .padding(.vertical, 8)
                }
            }
        }
    }

    struct ShortsCell: View {
        //    @Binding var shortsTransitionContext: ShortsTransitionContext?
        let shortsData: [ShortData]
        let transition: () -> Void
        var body: some View {
            VStack(alignment: .leading) {
                Text("Shorts").bold()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(shortsData, id: \.title) { shortData in
                            ZStack {
                                shortData.color.frame(width: 200, height: 300).onTapGesture {
                                    transition()
                                }
                                Image(systemName: "ellipsis")
                                    .rotationEffect(.degrees(90), anchor: .center)
                                    .frame(width: 10, height: 10)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                    .padding()

                                VStack {
                                    Text(shortData.title).foregroundColor(.white).bold().font(.body).lineLimit(2).shadow(radius: 2)
                                    HStack {
                                        Text("392K views").font(.caption).bold()
                                    }
                                }.padding()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)

                            }.clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
            }
        }
    }

    struct AdCell: View {
        let adData: AdData
        var body: some View {
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
                }
            }
        }
    }

    struct HomeView: View {
        @Binding var shortsTransitionContext: ShortsTransitionContext?
        @ObservedObject var viewModel: viewModel
        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VideoCell(videoData: .init(title: "Video1", color: .red))
                    VideoCell(videoData: .init(title: "Video2", color: .green))
                    VideoCell(videoData: .init(title: "Video3", color: .blue))
                        .onTapGesture {
                            viewModel.video = .init()
                            UIMovieView.player.replaceCurrentItem(with: viewModel.video?.videoItem)
                        }
                    ShortsCell(shortsData: [
                        .init(title: "short1", color: .yellow),
                        .init(title: "short2", color: .gradient01),
                        .init(title: "short3", color: .white),
                        .init(title: "short4", color: .green),
                        .init(title: "short5", color: .orange),
                        .init(title: "short6", color: .gradient03),
                        .init(title: "short7", color: .white),
                        .init(title: "short8", color: .red),
                        .init(title: "short9", color: .yellow),
                        .init(title: "short10", color: .red),
                    ], transition: {
                        withAnimation {
                            shortsTransitionContext = .homeView
                        }
                    })
                    Color.black.frame(height: 50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
    }

    struct ShortsView: View {
        var height: CGFloat
        var safeAreaTopHeight: CGFloat
        @Binding var shortsTransitionContext: ShortsTransitionContext?

        var body: some View {
            ZStack(alignment: .topLeading) {
                ScrollView {
                    LazyVStack {
                        ZStack {
                            Color.red.frame(height: height)
                            Text("shorts")
                        }
                    }
                }
                if shortsTransitionContext != .tabButton {
                    Button(action: {
                        withAnimation(shortsTransitionContext == .tabButton ? .none : .default) {
                            shortsTransitionContext = nil
                        }
                    }, label: {
                        Image(systemName: "chevron.left")
                    }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding()
                        .padding(.top, safeAreaTopHeight)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    struct MoviePlayerView: View {
        @State private var isPlaying: Bool = true
        @Binding var playbackProgress: Double
        @State private var totalDuration: Double = 1.0
        @State var userControlledProgress: Double?
        @Binding private var showFullscreen: Bool
        init(showFullscreen: Binding<Bool>, playbackProgress: Binding<Double>) {
            _showFullscreen = showFullscreen
            _playbackProgress = playbackProgress
        }

        var body: some View {
            ZStack(alignment: .center) {
                MovieView(isPlaying: $isPlaying, playbackProgress: $playbackProgress,
                          userControlledProgress: $userControlledProgress,
                          totalDuration: $totalDuration, isFull: $showFullscreen).onLongPressGesture(perform: {
                    showFullscreen.toggle()
                })

                HStack(alignment: .bottom) {
                    Button(action: {
                        isPlaying.toggle()
                    }) {
                        ZStack {
                            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                                .contentShape(Rectangle().size(.init(width: 100, height: 100)))
                                .padding()

                        }.frame(maxWidth: 60, maxHeight: 60, alignment: .bottomLeading)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showFullscreen.toggle()
                        }
                    }) {
                        ZStack {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 16, height: 16)
                                .foregroundColor(.gray)
                                .contentShape(Rectangle().size(.init(width: 100, height: 100)))
                                .padding()

                        }.frame(maxWidth: 60, maxHeight: 60, alignment: .bottomTrailing)
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)

                Slider(value: $playbackProgress) { editing in
                    if editing {
                        isPlaying = false
                        print("editing", playbackProgress)

                    } else {
                        print("not editing", playbackProgress)
                        isPlaying = true
                        userControlledProgress = playbackProgress
                    }
                }
                .onAppear {
                    UISlider.appearance().minimumTrackTintColor = .red
                    UISlider.appearance().maximumTrackTintColor = .gray
                    UISlider.appearance().setThumbImage(UIImage(), for: .normal)
                }

                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .frame(minHeight: 60)
                .offset(y: 16)
            }
        }
    }

    struct MovieView: UIViewRepresentable {
        @Binding var isPlaying: Bool
        @Binding var playbackProgress: Double
        @Binding var userControlledProgress: Double?
        @Binding var totalDuration: Double
        @Binding var isFull: Bool

        func makeUIView(context: Context) -> UIMovieView {
            let view = UIMovieView()
            view.delegate = context.coordinator
            view.changeProgress(value: playbackProgress)
            return view
        }

        func updateUIView(_ uiView: UIMovieView, context _: Context) {
            if isPlaying {
                uiView.play()
            } else {
                uiView.pause()
            }

            uiView.full(isFull: isFull)
            if userControlledProgress != nil {
                uiView.changeProgress(value: playbackProgress)
                Task {
                    userControlledProgress = nil
                }
            }
        }

        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

        class Coordinator: NSObject, UIMovieViewDelegate {
            var parent: MovieView

            init(_ parent: MovieView) {
                self.parent = parent
            }

            func moviePlayer(didUpdatePlaybackTime time: Double) {
                parent.playbackProgress = time / parent.totalDuration
            }

            func moviePlayer(didUpdateTotalDuration duration: Double) {
                parent.totalDuration = duration
            }
        }
    }

    class UIMovieView: UIView {
        static let player = AVPlayer()
        private var playerLayer: AVPlayerLayer?
        private var isFull: Bool = false
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupPlayer()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setupPlayer()
        }

        private func setupPlayer() {
            playerLayer = AVPlayerLayer(player: UIMovieView.player)

            if let playerLayer = playerLayer {
                playerLayer.frame = bounds
                playerLayer.videoGravity = .resizeAspectFill
                layer.addSublayer(playerLayer)
            }
            setupPlayerPeriodicTimeObserver()
        }

        func play() {
            Self.player.play()
        }

        func changeProgress(value: CGFloat) {
            guard let duration = Self.player.currentItem?.duration else { return }

            let totalSeconds = CMTimeGetSeconds(duration)
            let newTimeSeconds = totalSeconds * Double(value)
            let newTime = CMTime(seconds: newTimeSeconds, preferredTimescale: 600)

            Self.player.seek(to: newTime, toleranceBefore: .zero, toleranceAfter: .zero)
        }

        func pause() {
            Self.player.pause()
        }

        weak var delegate: UIMovieViewDelegate?
        func full(isFull: Bool) {
            if isFull != self.isFull {
                self.isFull = isFull
                layoutSubviews()
            }
        }

        override func layoutSubviews() {
            if isFull {
                let x = (bounds.width / 2) - (bounds.height / 2)
                let y = (bounds.height / 2) - (bounds.width / 2)
                playerLayer?.frame = bounds
                playerLayer?.frame = CGRect(x: x, y: y, width: bounds.height, height: bounds.width)
            } else {
                playerLayer?.frame = bounds
            }
            super.layoutSubviews()
        }

        // This assumes the video is not live streaming and has a definitive end
        func setupPlayerPeriodicTimeObserver() {
            let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            Self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
                guard let self = self else { return }
                let timeNow = CMTimeGetSeconds(time)
                self.delegate?.moviePlayer(didUpdatePlaybackTime: timeNow)

                if let totalDuration = Self.player.currentItem?.duration {
                    let totalSeconds = CMTimeGetSeconds(totalDuration)
                    self.delegate?.moviePlayer(didUpdateTotalDuration: totalSeconds)
                }
            }
        }
    }

    enum ShortsTransitionContext {
        case tabButton
        case playingView
        case homeView
    }
}

protocol UIMovieViewDelegate1: AnyObject {
    func moviePlayer(didUpdatePlaybackTime time: Double)
    func moviePlayer(didUpdateTotalDuration duration: Double)
}

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading)
        )
    }
}

#Preview {
    SKnock1.ContentView()
}
