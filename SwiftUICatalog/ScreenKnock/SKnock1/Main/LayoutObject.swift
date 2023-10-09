//
//  Constants.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

class LayoutObject: ObservableObject {
    @Published var offset: CGFloat = .zero
    @Published var currentOffset: CGFloat = .zero
    @Published var showingMiniPlayer: Bool = false
    @Published var defaultVideoHeight: CGFloat = 250
}

struct LayoutValues {
    
    let safeAreaProvider: () -> UIEdgeInsets?
    let screenSize: CGSize
    let toolbarHeight: CGFloat = 50
    let miniVideoHeight: CGFloat = 50
    
    init(screenSize: CGSize, safeAreaProvider: @escaping () -> UIEdgeInsets?) {
        self.safeAreaProvider = safeAreaProvider
        self.screenSize = screenSize
    }
    
    var miniVideoWidth: CGFloat {
        screenSize.width * 0.4
    }
    
    
    var safeArea: UIEdgeInsets {
        safeAreaProvider() ?? .zero
    }
    
    var miniVideoMiniY: CGFloat {
        screenSize.height - toolbarHeight - safeArea.bottom - miniVideoHeight - safeArea.top
    }
    
    
    var containerHeight: CGFloat {
        screenSize.height - toolbarHeight - safeArea.bottom - safeArea.top
        
    }
    
    var shrinkThreshold: CGFloat {
            containerHeight / 1.4
    }
    func isOverShrinkThreshold(offset: CGFloat) -> Bool {
        shrinkThreshold < offset
    }

    func videoHeight(offset: CGFloat, defaultVideoHeight: CGFloat) ->  CGFloat {
        let s = shrinkThreshold
        let c = containerHeight
        return max(
            miniVideoHeight, defaultVideoHeight - (
                isOverShrinkThreshold(offset: offset) ? (defaultVideoHeight * ((offset - s) / (c - s))) : 0)
        )
    }
    
    func videoWidth(offset: CGFloat) ->  CGFloat {
        return max(
            miniVideoWidth,
            screenSize.width - (
                isOverShrinkThreshold(offset: offset) ? 
                screenSize.width * ((offset - shrinkThreshold) / (containerHeight - shrinkThreshold))
                : 0
            )
        )
    }

    func playViewHeight(offset: CGFloat, defaultVideoHeight: CGFloat) -> CGFloat {
        max(100.0, screenSize.height - videoHeight(offset: offset, defaultVideoHeight: defaultVideoHeight) - offset)
    }
    
    func playViewOpacity(offset: CGFloat) -> CGFloat {
        max(0, 1 - (offset / (screenSize.height - toolbarHeight)))
    }
    
    var shortsHeight: CGFloat {
        screenSize.height - safeArea.bottom - toolbarHeight
    }
}




//class layoutValues: ObservableObject {
//    @Published var offset: CGFloat = .zero
//    @Published var currentOffset: CGFloat = .zero
//    @Published var showingMiniPlayer: Bool = false
//    @Published var defaultVideoHeight: CGFloat = 250
//    
//    var _safeArea: UIEdgeInsets?
//    var safeArea: UIEdgeInsets {
//        get {
//            
//            if let result = _safeArea {
//                return result
//            }
//            
//            guard let insets = safeAreaProvider() else { return .zero }
//            _safeArea = insets
//            return insets
//        }
//        
//    }
//    
//    let safeAreaProvider: () -> UIEdgeInsets?
//    let screenSize: CGSize
//    let toolbarHeight: CGFloat = 50
//    let miniVideoHeight: CGFloat = 50
//    
//    init(screenSize: CGSize, safeAreaProvider: @escaping () -> UIEdgeInsets?) {
//        self.safeAreaProvider = safeAreaProvider
//        self.screenSize = screenSize
//    }
//    
//    lazy var miniVideoWidth: CGFloat = {
//        screenSize.width * 0.4
//    }()
//    
//    
//    var miniVideoMiniYCache: CGFloat?
//    var miniVideoMiniY: CGFloat {
//        if let miniVideoMiniYCache {
//            return miniVideoMiniYCache
//        }
//        let result = screenSize.height - toolbarHeight - safeArea.bottom - miniVideoHeight - safeArea.top
//        if _safeArea != nil {
//            miniVideoMiniYCache = result
//        }
//        return result
//    }
//    
//    var containerHeightCache: CGFloat?
//    var containerHeight: CGFloat {
//        if let containerHeightCache {
//            return containerHeightCache
//        }
//        let result = screenSize.height - toolbarHeight - safeArea.bottom - safeArea.top
//        if _safeArea != nil {
//            containerHeightCache = result
//        }
//        return result
//        
//    }
//    
//    var shrinkThreshold: CGFloat { containerHeight / 1.4 }
//    var isOverShrinkThreshold: Bool { shrinkThreshold < offset }
//
//    var videoHeight: CGFloat {
//        let s = shrinkThreshold
//        let c = containerHeight
//        return max(
//            miniVideoHeight, defaultVideoHeight - (
//                isOverShrinkThreshold ? (defaultVideoHeight * ((offset - s) / (c - s))) : 0)
//        )
//    }
//    
//    var videoWidth: CGFloat {
//        let s = shrinkThreshold
//        let c = containerHeight
//        return max(
//            miniVideoWidth,
//            screenSize.width - (isOverShrinkThreshold ? screenSize.width * ((offset - s) / (c - s)) : 0)
//        )
//    }
//
//    var playViewHeight: CGFloat {
//        max(100, screenSize.height - videoHeight - offset)
//    }
//    
//    var playViewOpacity: CGFloat {
//        max(0, 1 - (offset / (screenSize.height - toolbarHeight)))
//    }
//    
//    var shortsHeight: CGFloat {
//        screenSize.height - safeArea.bottom - toolbarHeight
//    }
//}
