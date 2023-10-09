//
//  VideoView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import AVFoundation
import AVKit
import SwiftUI

struct MoviePlayerView<ViewModel: ViewModelProtocol>: View {
    @State private var isPlaying: Bool = true
    @State private var totalDuration: Double = 1.0
    @State var userControlledProgress: Double?
    
#warning("直接つなぐとパフォーマンス悪いので修正")
    @Binding var playbackProgress: Double
    @Binding private var showFullscreen: Bool
    @Binding var showingMiniPlayer: Bool
    @ObservedObject var viewModel: ViewModel
    
    init(showFullscreen: Binding<Bool>, playbackProgress: Binding<Double>, showingMiniPlayer: Binding<Bool>,
         viewModel: ViewModel) {
        _showFullscreen = showFullscreen
        _playbackProgress = playbackProgress
        _showingMiniPlayer = showingMiniPlayer
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            MovieView(isPlaying: $isPlaying,
                      playbackProgress: $playbackProgress,
                      userControlledProgress: $userControlledProgress,
                      totalDuration: $totalDuration,
                      isFull: $showFullscreen,
                      video: .init(get: {viewModel.output.playingVideo}, set: { _ in }))
            
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .opacity(showingMiniPlayer ? 0 : 1)
            
            Slider(value: $playbackProgress) { editing in
                if editing {
                    isPlaying = false
                } else {
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
    @Binding var video: VideoData?
    
    func makeUIView(context: Context) -> UIMovieView {
        let view = UIMovieView()
        view.delegate = context.coordinator
        view.changeProgress(value: playbackProgress)
        return view
    }
    
    func updateUIView(_ uiView: UIMovieView, context _: Context) {
        if UIMovieView.player.currentItem != video?.videoItem {
            UIMovieView.player.replaceCurrentItem(with: video?.videoItem)
        }
        
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
    
    class Coordinator: NSObject, UIMovieViewDelegate, @unchecked Sendable {
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
    static var player: AVPlayer = AVPlayer()
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
        playerLayer = AVPlayerLayer(player: Self.player)
        
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
    
    weak var delegate: (UIMovieViewDelegate & Sendable)?
    func full(isFull: Bool) {
        if isFull != self.isFull {
            self.isFull = isFull
            setNeedsLayout()
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
    
    func setupPlayerPeriodicTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        Self.player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let timeNow = CMTimeGetSeconds(time)
            Task { @MainActor in
                self.delegate?.moviePlayer(didUpdatePlaybackTime: timeNow)
                
                if let totalDuration = Self.player.currentItem?.duration {
                    let totalSeconds = CMTimeGetSeconds(totalDuration)
                    
                    self.delegate?.moviePlayer(didUpdateTotalDuration: totalSeconds)
                }
                
            }
        }
    }
}

enum ShortsTransitionContext {
    case tabButton
    case playingView
    case homeView
}

protocol UIMovieViewDelegate: AnyObject {
    func moviePlayer(didUpdatePlaybackTime time: Double)
    func moviePlayer(didUpdateTotalDuration duration: Double)
}

