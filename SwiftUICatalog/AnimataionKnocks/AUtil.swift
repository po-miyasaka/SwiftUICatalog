//
//  Util.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/29.
//

import SwiftUI
import UIKit

@MainActor func triggerHaptic() {
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    impactFeedbackgenerator.prepare()
    impactFeedbackgenerator.impactOccurred()
}


let defaultTags: [HashTag] = [
    .init(tag: "love"),
    .init(tag: "instagood"),
    .init(tag: "fashion"),

    .init(tag: "travel"),
    .init(tag: "happy"),
    .init(tag: "cute"),
    .init(tag: "instadaily"),
    .init(tag: "style"),
    .init(tag: "tbt"),
    .init(tag: "repost"),
    .init(tag: "followme"),
    .init(tag: "summer"),
    .init(tag: "reels"),
    .init(tag: "like"),
    .init(tag: "beauty"),
    .init(tag: "fitness"),
    .init(tag: "food"),
    .init(tag: "instalike"),
    .init(tag: "explore"),
    .init(tag: "photo"),
    .init(tag: "me"),
    .init(tag: "selfie"),
    .init(tag: "music"),
    .init(tag: "viral"),
    .init(tag: "friends"),
    .init(tag: "life"),
    .init(tag: "fun"),
    .init(tag: "smile"),
    .init(tag: "family"),
    .init(tag: "ootd"),
    .init(tag: "girl"),
    .init(tag: "makeup"),
    .init(tag: "likeforlikes"),
    .init(tag: "dog"),
    .init(tag: "model"),
    .init(tag: "design"),
    .init(tag: "motivation"),
    .init(tag: "handmade"),
    .init(tag: "lifestyle"),
    .init(tag: "likeforlike"),
    .init(tag: "sunset"),
    .init(tag: "artist"),
    .init(tag: "dogsofinstagram"),
    .init(tag: "foodporn"),
    .init(tag: "followforfollowback"),
    .init(tag: "beach"),
    .init(tag: "drawing"),
    .init(tag: "amazing"),
    .init(tag: "nofilter"),
    .init(tag: "cat"),
    .init(tag: "instamood"),
    .init(tag: "igers"),
    
    .init(tag: "sun"),
    .init(tag: "flowers"),
    .init(tag: "sky"),
    .init(tag: "gym"),
    .init(tag: "wedding"),
    .init(tag: "moda"),
    .init(tag: "photographer"),
    .init(tag: "follow"),
    .init(tag: "hair"),
    .init(tag: "foodie"),
    .init(tag: "inspiration"),
    .init(tag: "funny"),
    .init(tag: "instafood"),
    .init(tag: "memes"),
    .init(tag: "baby"),
    .init(tag: "naturephotography"),
    .init(tag: "l"),
    .init(tag: "nails"),
    .init(tag: "f"),
    .init(tag: "likeforfollow"),
    .init(tag: "workout"),
    .init(tag: "followforfollow"),
    .init(tag: "illustration"),
    .init(tag: "home"),
    .init(tag: "instapic"),
    .init(tag: "yummy"),
    .init(tag: "vsco"),
    .init(tag: "bestoftheday"),
    .init(tag: "landscape"),
    .init(tag: "catsofinstagram"),
    .init(tag: "vscocam"),
    .init(tag: "puppy"),
    .init(tag: "fit"),
    .init(tag: "party"),
    .init(tag: "tagsforlikes"),
    .init(tag: "girls"),
    .init(tag: "tattoo"),
    .init(tag: "healthy"),
    .init(tag: "instafashion"),
    .init(tag: "blackandwhite"),
]


// https://www.hackingwithswift.com/quick-start/swiftui/how-to-detect-the-location-of-a-tap-inside-a-view
struct TouchLocatingView: UIViewRepresentable {
    // The types of touches users want to be notified about
    struct TouchType: OptionSet {
        let rawValue: Int

        static let started = TouchType(rawValue: 1 << 0)
        static let moved = TouchType(rawValue: 1 << 1)
        static let ended = TouchType(rawValue: 1 << 2)
        static let all: TouchType = [.started, .moved, .ended]
    }

    // A closure to call when touch data has arrived
    var onUpdate: (CGPoint) -> Void

    // The list of touch types to be notified of
    var types = TouchType.all

    // Whether touch information should continue after the user's finger has left the view
    var limitToBounds = true

    func makeUIView(context: Context) -> TouchLocatingUIView {
        // Create the underlying UIView, passing in our configuration
        let view = TouchLocatingUIView()
        view.onUpdate = onUpdate
        view.touchTypes = types
        view.limitToBounds = limitToBounds
        return view
    }

    func updateUIView(_ uiView: TouchLocatingUIView, context: Context) {
    }

    // The internal UIView responsible for catching taps
    class TouchLocatingUIView: UIView {
        // Internal copies of our settings
        var onUpdate: ((CGPoint) -> Void)?
        var touchTypes: TouchLocatingView.TouchType = .all
        var limitToBounds = true

        // Our main initializer, making sure interaction is enabled.
        override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        // Just in case you're using storyboards!
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        // Triggered when a touch starts.
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .started)
        }

        // Triggered when an existing touch moves.
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .moved)
        }

        // Triggered when the user lifts a finger.
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Triggered when the user's touch is interrupted, e.g. by a low battery alert.
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Send a touch location only if the user asked for it
        func send(_ location: CGPoint, forEvent event: TouchLocatingView.TouchType) {
            guard touchTypes.contains(event) else {
                return
            }

            if limitToBounds == false || bounds.contains(location) {
                onUpdate?(CGPoint(x: round(location.x), y: round(location.y)))
            }
        }
    }
}

// A custom SwiftUI view modifier that overlays a view with our UIView subclass.
struct TouchLocater: ViewModifier {
    var type: TouchLocatingView.TouchType = .all
    var limitToBounds = true
    let perform: (CGPoint) -> Void

    func body(content: Content) -> some View {
        content
            .overlay(
                TouchLocatingView(onUpdate: perform, types: type, limitToBounds: limitToBounds)
            )
    }
}

// A new method on View that makes it easier to apply our touch locater view.
extension View {
    func onTouch(type: TouchLocatingView.TouchType = .all, limitToBounds: Bool = true, perform: @escaping (CGPoint) -> Void) -> some View {
        self.modifier(TouchLocater(type: type, limitToBounds: limitToBounds, perform: perform))
    }
}

