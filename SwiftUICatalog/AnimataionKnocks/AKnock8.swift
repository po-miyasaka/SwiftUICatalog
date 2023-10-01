// 参照
// https://gist.github.com/KSJP9/2d1ceb2a1f1eb8083d8538185623b31e

import SwiftUI
import Combine
enum AKnock8 {
    @available(iOS 17.0, *)
    struct ContentView: View {
        @State var offset: CGFloat = 0
        @State var isLoading: Bool = false
        var body: some View {
            ZStack (alignment: .topLeading){
                
                List {
                    Section(content: {
                        ForEach(defaultTags) { data in
                            Text(data.tag)
                        }
                    }, header:
                                {
                        GeometryReader { content in
                            let offset = content.frame(in: .named("ListView")).minY
                            let _ = Task {
                                self.offset = offset
                                if offset > 130 {
                                    if !isLoading {
                                        isLoading = true
                                        Task {
                                            try await Task.sleep(nanoseconds:5_000_000_000)
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                            Text("")
//                            Color.red.preference(key: OffsetPK.self, value: offset)
//                             preferencekeyはviewの閭里中に出てきた値をロジックに受け渡すときにつかう。viewレンダリング中に強引にStateを更新するとエラーになる。はずだったのだが、ちゃんと伝搬しない。
                            
                        }.frame(height: 1)
                    }
                    )
                    
                }
                
                Canvas{ context, size in
                    var imageContext = context
                    
                    context.addFilter(.alphaThreshold(min: 0.4, color: .white))
                    context.addFilter(.blur(radius: 10))
                    
                    context.drawLayer(content: { graphicsContext in
                        
                        let ball = CGPoint(x: size.width / 2, y: -70)
                        graphicsContext.draw(context.resolveSymbol(id: ID.refreshBall)!, at: ball)
                        let ceil = CGPoint(x: size.width / 2, y: 0)
                        graphicsContext.draw(context.resolveSymbol(id: ID.ceil)!, at: ceil)
                        
                    })
                    
                    
                    imageContext.addFilter(.alphaThreshold(min: 0.4, color: .black))
                    imageContext.drawLayer(content: { graphicsContext in
                        let image = CGPoint(x: size.width / 2, y: -70)
                        graphicsContext.draw(context.resolveSymbol(id: ID.image)!, at: image)
                        
                    })
                    
                } symbols: {
                    RefreshBall(offset: $offset).tag(ID.refreshBall)
                    RefreshImage(offset: $offset, isLoading: $isLoading).tag(ID.image)
                    Ceil().tag(ID.ceil)
                }
                .frame(height: max(offset, 0))
                //                Color.red
                .onPreferenceChange(OffsetPK.self, perform: { value in
                    // 利用していない
                    offset = value
                })
                
            }.coordinateSpace(name: "ListView")
        }
        
        struct RefreshBall: View {
            @Binding var offset: CGFloat
            var body: some View {
                
                
                Circle()
                    .frame(width: 58, height: 58)
                    .offset(y: offset)
            }
        }
        
        struct RefreshImage: View {
            @Binding var offset: CGFloat
            @Binding var isLoading: Bool
            @State var angle: Int = 0
            var body: some View {
                Image(systemName: "volleyball")
                
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .rotationEffect(.degrees(CGFloat(angle)))
                    .frame(width: 48, height: 48)
                    .offset(y: offset)
                    .onChange(of: isLoading, perform: { newValue in

                        animateLoad()
                    })
                
            }
            
            func animateLoad() {
                angle = 0
                if isLoading {
                    withAnimation(.linear(duration: 1.0)) {
                        angle = -360
                    } completion: {
                        if isLoading {
                                animateLoad()
                            
                        }
                    }
                }
            }
        }
        
        
        struct Ceil: View {
            var body: some View {
                Color.red.frame(height: 10)
            }
        }
        
    }
    
    
}

enum ID: CaseIterable, Hashable {
    case ceil
    case refreshBall
    case image
}
@available(iOS 17.0, *)
#Preview {
    AKnock8.ContentView()
}