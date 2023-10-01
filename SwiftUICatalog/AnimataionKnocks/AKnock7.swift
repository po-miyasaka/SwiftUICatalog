import SwiftUI
import Combine
enum AKnock7 {
    @available(iOS 17.0, *)
    struct ContentView: View {
        @State var arr: [HashTag] = Array(defaultTags)
        @State var scrollViewSize: CGSize = .zero
        @State private var scrollVelocity: CGFloat = 0.0
        @State var concurrentQueue = DispatchQueue(label: "com.example.concurrentQueue", attributes: .concurrent)
        
        let viewSize: CGSize
        @State var cancellable: AnyCancellable?
        @State var isGoingDown = false
        
        var body: some View {
            ScrollView {
                
                LazyVStack(spacing: 32) {
                    Section {
                        ForEach(arr) { tag in
                            GeometryReader { proxy in
                                let rect = proxy.frame(in: .named("ScrollView"))
                                let when = rect.minY > -500 && rect.minY < viewSize.height + 500
                                let distanceFromCenter = abs(rect.midY - viewSize.height / 2)
                                let offsetFactor = distanceFromCenter / viewSize.height
                                let offsetAbs = abs(scrollVelocity * offsetFactor)
                                let offsetSign: CGFloat = isGoingDown ? -1 : 1
                                let minMargin: CGFloat = 30
                                let maxOffset = ((viewSize.height / 2 - 20) / 2) - minMargin
                                let calculatedOffset = offsetSign * min(offsetAbs, maxOffset)
                                
                                ZStack(alignment: .center) {
                                    Color.white
                                    Text(tag.tag).foregroundStyle(.black).font(.title)
                                }
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                              
                                .padding(.horizontal)
                                .offset(y: when ? calculatedOffset : 0)
                                
                            }
                            .frame(height: 200)
                        }
                    } header: {
                        Spacer()
                    } footer: {
                        Spacer()
                    }
                }
                .modifier(ScrollViewOffsetModifier(scrollVelocity: $scrollVelocity, isGoingDown: $isGoingDown))
                .background(GeometryReader { proxy in
                    
                    Color.red.opacity(0.002).onAppear {
                        scrollViewSize = proxy.size
                    }
                })
                
            }
            .coordinateSpace(name: "ScrollView")
        }
    }
    
    struct ScrollViewOffsetModifier: ViewModifier {
        @Binding var scrollVelocity: CGFloat
        @State private var scrollY: CGFloat = 0.0
        @State private var lastScrollY: CGFloat = 0.0
        @State private var lastUpdateTime: Date = Date()
        @Binding var isGoingDown: Bool
        func body(content: Content) -> some View {
            return content
                .overlay(
                    GeometryReader { proxy in
                        Color.blue.opacity(0.0001)
                            .preference(key: ScrollViewOffsetPreferenceKey.self, value: proxy.frame(in: .named("ScrollView")).minY)
                        
                    }
                )
                .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
                    
                    let timePassed = Date().timeIntervalSince(lastUpdateTime)
                    isGoingDown = value > lastScrollY
                    let distance = abs(value - lastScrollY)
                    let new = min(distance / CGFloat(timePassed) / 20, 100)
                
                    scrollVelocity = new
                    lastScrollY = value
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
    AKnock7.ContentView(viewSize: UIScreen.main.bounds.size)
}
