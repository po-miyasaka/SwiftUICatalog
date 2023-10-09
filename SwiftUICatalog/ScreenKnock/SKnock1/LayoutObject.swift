//
//  Constants.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI
import Combine
class LayoutObject: ObservableObject {
    @Published var offset: CGFloat = .zero
    @Published var metaViewOffset: CGFloat
    
    var currentOffset: CGFloat = .zero
    var currentMetaViewOffset: CGFloat
    var originVideoHeight: CGFloat = 250
    var showingMiniPlayer: Bool {
        currentOffset != 0
    }
    
    
    let safeAreaProvider: () -> UIEdgeInsets?
    let screenSize: CGSize
    let miniVideoHeight: CGFloat = 50
    
    init(screenSize: CGSize, safeAreaProvider: @escaping () -> UIEdgeInsets?) {
        self.safeAreaProvider = safeAreaProvider
        self.screenSize = screenSize
        metaViewOffset = screenSize.height
        currentMetaViewOffset = screenSize.height
    }
    
    var miniVideoWidth: CGFloat {
        screenSize.width * 0.4
    }
    
    var _safeArea: UIEdgeInsets?
    var safeArea: UIEdgeInsets {
        if let _safeArea {
            return _safeArea
        }
        if let safeArea = safeAreaProvider() {
            _safeArea = safeArea
            return safeArea
        }
        return .zero
    }
    
    var miniVideoMiniY: CGFloat {
        return screenSize.height - miniVideoHeight - toolbarHeight - safeArea.top
    }
    
    var toolbarHeight: CGFloat {
        44 + safeArea.bottom
    }
    
    var toolbarMinY: CGFloat {
        max(containerHeight - toolbarHeight  - offset, 0)
    }
    
    var containerHeight: CGFloat {
        screenSize.height - toolbarHeight - safeArea.top
    }
    
    var shrinkThreshold: CGFloat {
        containerHeight / 1.4
    }
    var isOverShrinkThreshold:  Bool {
        shrinkThreshold < offset
    }
    
    var videoHeight: CGFloat {
        return max(
            miniVideoHeight, originVideoHeight - (
                isOverShrinkThreshold ? (originVideoHeight * ((offset - shrinkThreshold) / (containerHeight - shrinkThreshold))) : 0)
        )
    }
    
    var videoWidth: CGFloat {
        return max(
            miniVideoWidth,
            screenSize.width - (
                isOverShrinkThreshold ?
                screenSize.width * ((offset - shrinkThreshold) / (containerHeight - shrinkThreshold))
                : 0
            )
        )
    }
    
    var playViewHeight: CGFloat {
        max(100.0, screenSize.height - videoHeight - offset)
    }
    
    var playViewOpacity: CGFloat {
        max(0, 1 - (offset / (screenSize.height - toolbarHeight)))
    }
    
    var shortsHeight: CGFloat {
        screenSize.height - toolbarHeight
    }
    
    func updateVideoViewOffset(transition: CGSize) {
        offset = currentOffset + transition.height
    }
    
    func updateMetaViewOffset(transition: CGSize) {
        metaViewOffset = currentMetaViewOffset + transition.height
    }
    
    var metaMinY: CGFloat {
        videoHeight + offset
    }
    
    func showFullMeta() {
        currentMetaViewOffset = 0
        withAnimation {
            metaViewOffset = currentMetaViewOffset
        }
        
    }
    
    func showMeta() {
        currentMetaViewOffset = metaMinY
        withAnimation {
            metaViewOffset = currentMetaViewOffset
        }
    }
    
    func hideMeta() {
        currentMetaViewOffset = screenSize.height
        withAnimation {
            metaViewOffset = currentMetaViewOffset
        }
    }
    
    func metaDragEnd() {
        let gap = metaMinY - metaViewOffset
        if gap > 100 {
            showFullMeta()
        } else if gap < 100 && gap > -100 {
            showMeta()
        } else {
            hideMeta()
        }
    }
    
    func showMini() {
        updatePlayingVideoLayout(shouldMinify: true)
    }
    
    var cancellable: AnyCancellable?
    func videoViewDragEnd() {
        let previousValue = showingMiniPlayer
        let threshold = showingMiniPlayer ? containerHeight / 1.1 : containerHeight / 10
        let shouldMini = offset >= threshold
        
        let noChange = previousValue == shouldMini
        
        if noChange {
            offset = currentOffset
            return
        }
        let shouldMinify = offset >= threshold
        updatePlayingVideoLayout(shouldMinify: shouldMinify)
    }
    
    func showVideo(with imageRect: CGRect) {
        offset = imageRect.minY - safeArea.top
        updatePlayingVideoLayout(shouldMinify: false)
    }
    
    func updatePlayingVideoLayout(shouldMinify: Bool) {
        currentOffset = shouldMinify ? miniVideoMiniY : 0
        
#warning("アニメーション使うとMovieViewの描画が追いつかない。")
        //        withAnimation() {
        //            offset = currentOffset
        //        }
        
        cancellable?.cancel()
        cancellable = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect().sink(receiveValue: { [weak self] _ in
            self?.update(shouldMinify: shouldMinify)
        })
        
    }
    
    private func update(shouldMinify: Bool) {
        let judge = shouldMinify ? offset >= currentOffset :  offset <= currentOffset
        if judge {
            cancellable?.cancel()
            offset = currentOffset
        } else {
            offset += shouldMinify ? 20 : -20
        }
    }
    
}
