//
//  Knock78.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI
enum Knock78 {
    
    
    struct ContentView: View {
        @State var offset: Float = .zero
        @State var height: Float = .zero
        @State var viewHeight: Float = .zero
        
        var body: some View {
            VStack {
                ZStack {
                    ScrollViewReader { reader in
                        
                        ScrollView {
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(
                                        key: OffsetPreferenceKey.self,
                                        value: proxy.frame(in: .named("scrollLayer")).minY
                                    )
                                // proxy.frame(in: .named("frameLayer")).size.height　このGeometryReaderの高さ。
                            }
                            .frame(height: 0)
                            LazyVStack {
                                ForEach(0..<120, id: \.self) { _ in
                                    Color.blue.frame(height: 100).padding()
                                        .clipShape(Circle())
                                }
                            }
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.preference(
                                        key: HeightPreferenceKey.self,
                                        value: proxy.size.height
                                    )
                                }
                            )
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.red.preference(
                                    key: ViewHeightPreferenceKey.self,
                                    value: proxy.size.height
                                )
                            }
                        )
                        .coordinateSpace(name: "scrollLayer")
                        .onPreferenceChange(OffsetPreferenceKey.self, perform: { v in
                            
                            self.offset = Float(v)
                        })
                        .onPreferenceChange(HeightPreferenceKey.self, perform: { v in
                            
                            self.height = Float(v)
                        })
                        
                        .onPreferenceChange(ViewHeightPreferenceKey.self, perform: { v in
                            
                            self.viewHeight = Float(v)
                        })
                    }
                }
                
                Slider(value: Binding(get: { () -> Float in
                    print(-offset , height, viewHeight)
                    
                    return (-offset) / (height - viewHeight)
                }, set: {value in
                    #warning("make it scroll in accoding to slider value")
                }))
            }   
        }
    }
    
    #Preview {
        Knock78.ContentView()
    }
    
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}


private struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}


private struct ViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
