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

@MainActor
protocol ViewModelOutput {
    var playingVideo: VideoData? { get }
    var shouldReloadVideoIncrement: Int { get }
    var tappedImageRect: CGRect { get }
    var shortsTransitionContext: TransitionContext? { get }
    var current: Page { get }
    var playbackProgress: Double { get }

    var isFull: Bool { get }
    var shouldShowCreateModal: Bool { get }
    var recommendedObjects: [RecommendedType] { get }
    var shouldShowVideoMetaView: Bool { get }
}

@MainActor
protocol ViewModelInput {
    func closeVideo()
    func pause()
    func showFull()
    func hideFull()
    func updateProgress(_ value: CGFloat)
    func showShort(_ context: TransitionContext)
    func hideShort()
    func closeModal()
    func showPage(page: Page)
    func showCreateModal()
    func select(video: VideoData, tappedImageRect: CGRect)
    
}
@MainActor
protocol ViewModelProtocol: AnyObject, ObservableObject {
    var input: ViewModelInput { get }
    var output: ViewModelOutput { get }
}

@MainActor
final class ViewModel: NSObject, ViewModelProtocol {
    
    @Published private(set) var _playingVideo: VideoData?
    @Published private(set) var _shouldReloadVideoIncrement: Int = 0
    private var _pauseSubject: PassthroughSubject<Void, Never> = .init()
    private(set) var tappedImageRect: CGRect = .zero
    @Published private(set) var _shortsTransitionContext: TransitionContext?
    @Published private(set) var _shouldShowVideoMetaView: Bool = false
    @Published private(set) var _current: Page = .home
    @Published private(set) var _playbackProgress: Double = 0.0
    @Published private(set) var _isFull: Bool = false
    @Published private(set) var _shouldShowCreateModal: Bool = false
    @Published private(set) var _recommendedObjects: [RecommendedType] = [
        .video(.init(title: "video1", imageName: "thumb1")),
        .video(.init(title: "video2", imageName: "thumb2")),
        .ad(.init(title: "ad1", color: .pink)),
        .video(.init(title: "video3", imageName: "thumb3")),
        .shorts(
            [
                .init(title: "short1", imageName: "short1"),
                .init(title: "short2", imageName: "short2"),
                .init(title: "short3", imageName: "short3"),
                .init(title: "short4", imageName: "short4")
            ]
        ),
        .video(.init(title: "video4", imageName: "thumb4")),
        .video(.init(title: "video5", imageName: "thumb5")),
        .ad(.init(title: "ad2", color: .pink)),
        .video(.init(title: "video6", imageName: "thumb6")),
        .video(.init(title: "video7", imageName: "thumb7")),
        
        .shorts(
            [
                .init(title: "short5", imageName: "short5"),
                .init(title: "short6", imageName: "short6"),
                .init(title: "short7", imageName: "short7"),
                .init(title: "short8", imageName: "short8"),
                .init(title: "short9", imageName: "short9")
            ]
        ),
    ]
    
    var input: ViewModelInput { self }
    var output: ViewModelOutput { self }
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

extension ViewModel: ViewModelInput {

    func pause() {
        _pauseSubject.send(())
    }

    func select(video: VideoData, tappedImageRect: CGRect) {
        self.tappedImageRect = tappedImageRect

        _playingVideo = video
        _shouldReloadVideoIncrement += 1
    }
    
    func hideFull() {
        _isFull = false
    }
    
    func hideShort() {
        _shortsTransitionContext = nil
    }
    
    func showPage(page: Page) {
        _current = page
    }
    
    func showCreateModal() {
        _shouldShowCreateModal = true
    }
    
    func closeModal() {
        _shouldShowCreateModal = false
    }
    
    func closeVideo() {
        _playingVideo = nil
    }
    
    func showFull() {
        _isFull = true
    }
    
    func updateProgress(_ value: CGFloat) {
        _playbackProgress = value
    }
    
    func showShort(_ context: TransitionContext) {
        _shortsTransitionContext = context
    }
    
    func showMetaView() {
        _shouldShowVideoMetaView = true
    }
    
    func hideMetaView() {
        _shouldShowVideoMetaView = false
    }
    
    
}

extension ViewModel: ViewModelOutput {
    var recommendedObjects: [RecommendedType] {
        _recommendedObjects
    }
    
    var playingVideo: VideoData? {
        _playingVideo
    }
    
    var shouldReloadVideoIncrement: Int {
        _shouldReloadVideoIncrement
    }
    
    var pausePublisher: AnyPublisher<Void, Never> {
        _pauseSubject.eraseToAnyPublisher()
    }
    
    var shortsTransitionContext: TransitionContext? {
        _shortsTransitionContext
    }
    
    var current: Page {
        _current
    }
    
    var playbackProgress: Double {
        _playbackProgress
    }

    
    var isFull: Bool {
        _isFull
    }
    
    var shouldShowCreateModal: Bool {
        _shouldShowCreateModal
    }
    
    var shouldShowVideoMetaView: Bool {
        _shouldShowVideoMetaView
    }
    
}

class OffsetObject: ObservableObject {
    @Published var offset: CGFloat = .zero
    @Published var currentOffset: CGFloat = .zero
}

struct User: Hashable {
    let name: String
    let note: String
    var thumbnail: UIImage {
        UIImage(named: "kabigon2")!
    }
}
