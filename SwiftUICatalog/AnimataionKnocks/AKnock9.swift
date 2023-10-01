
import SwiftUI
import Combine

enum AKnock9 {
    @available(iOS 17.0, *)
    struct ContentView: View {
        @State var arr: [HashTag] = Array(defaultTags)
        @State private var scrollVelocity: CGFloat = 0.0
        @State var isGoingRight = false
        let viewSize: CGSize
        var body: some View {
            ScrollView(.horizontal) { // Change direction to horizontal
                
                LazyHStack(spacing: 8) {
                    // Use LazyHStack
                    ForEach(arr) { tag in
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("ScrollView"))
                            let when = rect.minX > -500 && rect.minX < viewSize.width + 500 // Change minY to minX
                            let distanceFromCenter = abs(rect.midX - viewSize.width / 2) // Change midY to midX
                            let offsetFactor = distanceFromCenter / viewSize.width // Adjust for width
                            let offsetAbs = abs(scrollVelocity * offsetFactor)
                            let offsetSign: CGFloat = isGoingRight ? -1 : 1
                            let minMargin: CGFloat = 32
                            let maxOffset = minMargin // Adjust for width
                            
                            let calculatedOffset: CGFloat = offsetSign * min(offsetAbs, maxOffset)
                            
                            
                            ZStack(alignment: .center) {
                                Color.white
                                Text(tag.tag).foregroundStyle(.black).font(.title)
                            }
                            .frame(width: 180) // Adjust frame for width
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(.vertical) // Change padding to vertical
                            .offset(x: when ? calculatedOffset : 0) // Offset x instead of y
                        }
                        .frame(width: 200) // Adjust frame for width
                        
                    }
                }
                .modifier(ScrollViewOffsetModifier(scrollVelocity: $scrollVelocity, isGoingRight: $isGoingRight))
            }
            .coordinateSpace(name: "ScrollView")
        }
    }

    struct ScrollViewOffsetModifier: ViewModifier {
        @Binding var scrollVelocity: CGFloat
        @State private var scrollX: CGFloat = 0.0 // Change Y to X
        @State private var lastScrollX: CGFloat = 0.0 // Change Y to X
        @State private var lastUpdateTime: Date = Date()
        @Binding var isGoingRight: Bool

        func body(content: Content) -> some View {
            return content
                .overlay(
                    GeometryReader { proxy in
                        Color.blue.opacity(0.0001)
                            .preference(key: ScrollViewOffsetPreferenceKey.self, value: proxy.frame(in: .named("ScrollView")).minX) // Change minY to minX
                    }.allowsHitTesting(false)
                )
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    let timePassed = Date().timeIntervalSince(lastUpdateTime)
                    isGoingRight = value > lastScrollX // Change lastScrollY to lastScrollX
                    let distance = abs(value - lastScrollX) // Change lastScrollY to lastScrollX
                    let new = min(distance / CGFloat(timePassed) / 20, 100)

                    scrollVelocity = new
                    lastScrollX = value // Change lastScrollY to lastScrollX
                    lastUpdateTime = Date()
                }
        }
    }

    struct ScrollViewOffsetPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    GeometryReader { geometryProxy in AKnock7.ContentView(viewSize: geometryProxy.size) }
}
