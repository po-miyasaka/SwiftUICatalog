//
//  viewModel.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import AVFoundation
import AVKit
import Combine
import SwiftUI

enum RecommendedType: Hashable {
    case ad(AdData)
    case video(VideoData)
    case shorts([ShortData])
}

class ViewModel: NSObject, ObservableObject {
    @Published var playingVideo: VideoData?
    @Published var shouldReloadVideoIncrement: Int = 0
    private var pauseSubject: PassthroughSubject<Void, Never> = .init()
    var rect: CGRect = .zero
    @Published var shortsTransitionContext: ShortsView.TransitionContext?
    @Published var current: MainView.Page = .home
    @Published var playbackProgress: Double = 0.0
    @Published var isFull: Bool = false
    @Published var shouldShowCreateModal: Bool = false
    @Published var recommendedObjects: [RecommendedType] = [
        .video(.init(title: "video1", imageName: "thumb1")),
        .video(.init(title: "video2", imageName: "thumb2")),
        .ad(.init(title: "ad1", color: .purple)),
        .video(.init(title: "video3", imageName: "thumb3")),
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
        .video(.init(title: "video4", imageName: "thumb4")),
        .video(.init(title: "video5", imageName: "thumb5")),
        .ad(.init(title: "ad1", color: .pink)),
        .video(.init(title: "video6", imageName: "thumb6")),
        .video(.init(title: "video7", imageName: "thumb7")),
        
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

    var pausePublisher: AnyPublisher<Void, Never> {
        pauseSubject.eraseToAnyPublisher()
    }

    func pause() {
        pauseSubject.send(())
    }

    func select(video: VideoData, rect: CGRect) {
        self.rect = rect

        playingVideo = video
        shouldReloadVideoIncrement += 1
    }
}

struct VideoData: Identifiable, Hashable {
    let title: String
    let imageName: String
    let id = UUID()
    let user = User(name: "Hoge User", note: "Topic・65K views・1 days ago")
    init(title: String, imageName: String) {
        self.title = title
        self.imageName = imageName
    }

    var thumbnail: UIImage {
        UIImage(named: imageName)!
    }

    var videoItem: AVPlayerItem = {
        var videoName: String = "movie"
        var videoType: String = "mp4"

        let url = Bundle.main.url(forResource: videoName, withExtension: videoType)!
        return AVPlayerItem(url: url)
    }()

    static func == (lhs: VideoData, rhs: VideoData) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#warning("viewModelにまとめるとカクつくので分ける。")
class OffsetObject: ObservableObject {
    @Published var offset: CGFloat = .zero
    @Published var currentOffset: CGFloat = .zero
    @Published var showingMiniPlayer: Bool = false
}

struct User: Hashable {
    let name: String
    let note: String
    var thumbnail: UIImage {
        UIImage(named: "kabigon2")!
    }
}
