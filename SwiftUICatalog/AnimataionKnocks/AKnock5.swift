//
//  Knock5.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/30.
//

import SwiftUI
import UIKit
struct ScrollValue<T: Identifiable & Equatable>: Identifiable, Equatable {
    var id: T.ID  { value.id }
    var value: T
}


enum AKnock5 {
    
    
    
    struct ContentView: View {
        @State var arr: [HashTag] = defaultTags

        @State var scrollViewSize: CGSize = .zero
        
        var body: some View {
            ScrollView {
                
                LazyVStack(spacing: 30) {
                    Section {
                        ForEach(arr) { tag in
                            
                            GeometryReader(
                                content: { proxy in
                                    let midY = proxy.frame(in: .named("ScrollView")).midY
                                    let x: CGFloat = {
                                        
                                        let (_x, _) = xCoordinatesForGivenY(y: abs(midY - (scrollViewSize.width / 2) ), r: scrollViewSize.width / 2)
                                        
                                        return _x
                                    }()
                                    
                                    Text(tag.tag)
                                        .offset(x: x)
                                        .opacity(x <= 0 ? 0 : 1 )
                                        .font(.system(size: max(x / 5, 10 ), weight: .bold, design: .default))
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
            }.frame(height: scrollViewSize.width)
                .coordinateSpace(name: "ScrollView")
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
        
    }
    
}

#Preview {
    AKnock5.ContentView()
}
