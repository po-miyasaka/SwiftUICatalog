//
//  AKnock6.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/30.
//

import SwiftUI



enum AKnock6 {
    
    
    
    struct ContentView: View {
        @State var arr: [HashTag] = Array(defaultTags)
        
        @State var scrollViewSize: CGSize = .zero
        
        var body: some View {
            ScrollView {
                
                LazyVStack(spacing: 50) {
                    Section {
                        ForEach(arr) { tag in
                            
                            GeometryReader(
                                content: { proxy in
                                    let midY = proxy.frame(in: .named("ScrollView")).midY
                                    var data: (x: CGFloat, angle: CGFloat) = {
                                        
                                        let (x, _) = xCoordinatesForGivenY(y: abs(midY - (scrollViewSize.width / 2) ), r: scrollViewSize.width / 2)
                                        
                                        let angleInRadians = angleFromOrigin(forPointX: x, y: midY)
                                        let angleInDegrees = (((angleInRadians)  * 180 / .pi) * 2) - 90
                                        
                                        print(angleInDegrees)
                                        
                                        return (
                                            x: x,
                                            angle: angleInDegrees
                                        )
                                    }()
                                    
                                    Text(tag.tag)
                                        .rotationEffect(.init(degrees: -data.angle), anchor: .leading)
                                        .offset(x: data.x)
                                        .opacity(data.x <= 0 ? 0 : 1 )
                                    
                                        .font(.system(size: max(data.x / 5, 10 ), weight: .bold, design: .default))
                                })
                            .frame(maxHeight: 60)
                        }
                    } header: {
                        Spacer()
                    } footer: {
                        Spacer()
                    }
                    
                    
                }.background(
                    GeometryReader { proxy in
                        Color.clear
                        
                        let _ = Task {
                            scrollViewSize = proxy.size
                        }
                    }
                )
            }
            .frame(height: scrollViewSize.width)
                .coordinateSpace(name: "ScrollView")
                .if {
                    if #available(iOS 17.0, *) {
                        $0.scrollClipDisabled(true)
                    } else {
                        $0
                    }
                }
        }
        func xCoordinatesForGivenY(y: Double, r: Double) -> (Double, Double) {
            let valueInsideSqrt = r * r - y * y
            if valueInsideSqrt >= 0 {
                let x1 = sqrt(valueInsideSqrt)
                let x2 = -sqrt(valueInsideSqrt)
                return (x1, x2)
            } else {
                return (0,0)
            }
        }
        
        func angleFromOrigin(forPointX x: Double, y: Double) -> Double {
            return atan2(x, y)
        }
        
        
        
    }
    
}

#Preview {
    AKnock6.ContentView()
}
