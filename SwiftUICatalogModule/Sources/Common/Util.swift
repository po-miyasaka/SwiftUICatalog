//
//  Util.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
import UIKit

public extension View {
    @ViewBuilder func `if`<Transform: View>(_ condition: Bool = true, @ViewBuilder transform: (Self) -> Transform) -> some View {
        if condition {
            let v = transform(self)
            if v is EmptyView {
                self
            } else {
                v
            }
        } else {
            self
        }
    }
}

public extension View {
    @ViewBuilder
    func _alert<T>(isPresented: Binding<Bool>, title: String, message: String = "", data: T, @ViewBuilder action: (T) -> some View) -> some View {
        if #available(iOS 15.0, *) {
            alert(title, isPresented: isPresented, presenting: data, actions: { data in
                action(data)
            }, message: { _ in
                Text(message)
            })
        } else {
            alert(
                isPresented: isPresented,
                content: {
                    .init(title: Text(title),
                          message: Text(message),
                          primaryButton: .default(Text("OK"),
                                                  action: {
                                                      print("ok")
                    }),
                          secondaryButton: .cancel())
                }
            )
        }
    }
}

let sampleText = """
その巨体とでっぷりと肥えた腹部が特徴のポケモン。頭部には尖った耳が生え、下顎の犬歯が口を閉じていても飛び出すほどに発達している。体色は黒とクリーム色の二色で、腹部と顔まわり、3本の爪が生えた足がクリーム色、それ以外の全体が黒。

大食漢なポケモンとして有名で、一日に自分の体重の9割近くになる400kgもの食事を取る。食事を終えると寝転がり、空腹になると起き上がって食料を探すといういわゆる「食っちゃ寝」な生活サイクルを送っている。その胃袋は非常に丈夫であり、カビや腐敗した食べ物はおろか、ベトベトンの毒すらも問題なく消化できるほど。

食事と睡眠以外の事には興味がなく、昼寝の最中にお腹をトランポリン代わりにされても一切気にせずに眠り続ける。その大人しさのためか、カビゴンを遊具代わりにして遊ぶ子供もいるほど。ただ、ポケモンの笛と呼ばれる特殊な笛が奏でる音色には反応するようで、どんなに深い眠りに入っていても笛の音を聞くとすぐさま目を覚ます。

色違いは体の黒色部分が青みがかる。
"""


@MainActor
public func triggerHaptic() {
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .medium)
    impactFeedbackgenerator.prepare()
    impactFeedbackgenerator.impactOccurred()
}

public struct HashTag: Identifiable, Equatable, Sendable {
    public let id = UUID()
    public var tag: String
    
    init(tag: String) {
        self.tag = tag
    }
}

public let defaultTags: [HashTag] = [
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
public struct TouchLocatingView: UIViewRepresentable {
    // The types of touches users want to be notified about
    @MainActor struct TouchType: OptionSet {
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

    public func makeUIView(context _: Context) -> TouchLocatingUIView {
        // Create the underlying UIView, passing in our configuration
        let view = TouchLocatingUIView()
        view.onUpdate = onUpdate
        view.touchTypes = types
        view.limitToBounds = limitToBounds
        return view
    }

    public func updateUIView(_: TouchLocatingUIView, context _: Context) {}

    // The internal UIView responsible for catching taps
    public class TouchLocatingUIView: UIView {
        // Internal copies of our settings
        var onUpdate: ((CGPoint) -> Void)?
        var touchTypes: TouchLocatingView.TouchType = .all
        var limitToBounds = true

        // Our main initializer, making sure interaction is enabled.
        public override init(frame: CGRect) {
            super.init(frame: frame)
            isUserInteractionEnabled = true
        }

        // Just in case you're using storyboards!
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            isUserInteractionEnabled = true
        }

        // Triggered when a touch starts.
        public override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .started)
        }

        // Triggered when an existing touch moves.
        public override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .moved)
        }

        // Triggered when the user lifts a finger.
        public override func touchesEnded(_ touches: Set<UITouch>, with _: UIEvent?) {
            guard let touch = touches.first else { return }
            let location = touch.location(in: self)
            send(location, forEvent: .ended)
        }

        // Triggered when the user's touch is interrupted, e.g. by a low battery alert.
        public override func touchesCancelled(_ touches: Set<UITouch>, with _: UIEvent?) {
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
        modifier(TouchLocater(type: type, limitToBounds: limitToBounds, perform: perform))
    }
}

extension DateFormatter {
    public static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy / MM / dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    public static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        return formatter
    }()
}

public extension String {
    var toDate: Date {
        return DateFormatter.customFormatter.date(from: self) ?? DateFormatter.dateOnlyFormatter.date(from: self)!
    }
}

public extension Date {
    func toString() -> String {
        return DateFormatter.customFormatter.string(from: self)
    }
    
    func toDateOnlyString() -> String {
        return DateFormatter.dateOnlyFormatter.string(from: self)
    }
    
    func toTimeString() -> String {
        return DateFormatter.timeFormatter.string(from: self)
    }
}


import SwiftUI
public extension UIColor {
    func getColor() -> Color {
        let color = self
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let redValue = red * 255
        let greenValue = green * 255
        let blueValue = blue * 255
        
        return Color(red: redValue, green: greenValue, blue: blueValue)
    }
}

public struct ScreenSizeKey: EnvironmentKey {
    public static var defaultValue: CGSize = .zero
    
    public typealias Value = CGSize
}

public extension EnvironmentValues {
    public var screenSize: CGSize {
        get { self[ScreenSizeKey.self] }
        set { self[ScreenSizeKey.self] = newValue }
    }
}

public struct SafeAreaKey: EnvironmentKey {
    public static var defaultValue: () -> UIEdgeInsets = { .zero }
}

public extension EnvironmentValues {
    var safeArea: () -> UIEdgeInsets {
        get { self[SafeAreaKey.self] }
        set { self[SafeAreaKey.self] = newValue }
    }
}


public func image() -> UIImage {
    let image = UIImage(named: "svg")!
    let aspectScale = image.size.height / image.size.width

    let resizedSize = CGSize(width: 30, height: 30 * Double(aspectScale))

    UIGraphicsBeginImageContext(resizedSize)
    image.draw(in: CGRect(x: 0, y: 0, width: resizedSize.width, height: resizedSize.height))
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return resizedImage!
}
