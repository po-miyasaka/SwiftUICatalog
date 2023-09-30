//
//  AKnock4.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/29.
//

import SwiftUI

struct HashTag: Identifiable, Equatable, Sendable {
    let id = UUID()
    var tag: String
}

enum AKnock4 {
    struct ContentView: View, Sendable {
        
        @Namespace var namespace
        
        @State var hashTags: [HashTag] = [  .init(tag: "love"),
                                            .init(tag: "instagood"),
                                            .init(tag: "fashion"),
                                            .init(tag: "instagram"),
                                            .init(tag: "photooftheday"),
                                            .init(tag: "art"),
                                            .init(tag: "photography"),
                                            .init(tag: "beautiful"),
                                            .init(tag: "nature"),
                                            .init(tag: "picoftheday"),
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
                                            
        ]
        @State var selected: HashTag?
        @State var selection: [HashTag] = []
        @State var selectionHeight: CGFloat = .zero
        @State var sourceHeight: CGFloat = .zero
        var paddingValue: CGFloat = 16
        var body: some View {
            
            VStack(alignment: .leading) {
               
                
                ScrollView {
                    GeometryReader { geometry in
                        tags(data: $hashTags, proxy: geometry) {
                            !selection.contains($0)
                        }
                    }
                    .frame(minHeight: sourceHeight)
                    .zIndex(1)
                    
                    
                    GeometryReader { geometry in
                        selectedTags(data: $selection,  proxy: geometry)
                    }
                    .frame(height: selectionHeight)
                        
 
                    
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                

            }
            
        }
        
        @ViewBuilder
        func selectedTags(data: Binding<[HashTag]>, proxy: GeometryProxy) -> some View {
            var width: CGFloat = 0
            var height: CGFloat = 0
            
            
            
            ZStack(alignment: .topLeading) {
                // .topLeadingが無いとalignmentGuideが呼ばれない。
                ForEach(data) { $hashtag in
                    Button("#\(hashtag.tag)") {}
                    .matchedGeometryEffect(id: hashtag.id, in: namespace)
                                        .opacity(0)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                    
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        
                        if hashtag == data.wrappedValue.last! {
                            let _ = Task {[h = d.height] in
                                self.selectionHeight = -(result - h  - paddingValue )
                            }
                            
                            height = 0
                        }
                        return result
                    })
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > proxy.size.width - (2 * paddingValue) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if hashtag == data.wrappedValue.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                }
            }.padding(paddingValue)
                .background(Color.gray.opacity(0.5))
                .cornerRadius(paddingValue)
        }
        
        @ViewBuilder
        func tags(data: Binding<[HashTag]>, proxy: GeometryProxy, isSource: @escaping (HashTag) -> Bool) -> some View {
            var width: CGFloat = 0
            var height: CGFloat = 0
            
            ZStack(alignment: .topLeading) {
                // .topLeadingが無いとalignmentGuideが呼ばれない。
                ForEach(data) { $hashtag in
                    Button("#\(hashtag.tag)") {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if !selection.contains(hashtag) {
                                selection.append(hashtag)
                            } else if let index = selection.firstIndex(of: hashtag) {
                                selection.remove(at: index)
                            }
                        }
                    }
                    .matchedGeometryEffect(id: hashtag.id, in: namespace, isSource: isSource(hashtag))
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .zIndex(1.1)
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if hashtag == data.wrappedValue.last! {
                            let _ = Task {[h = d.height] in
                                self.sourceHeight = -(result - h - paddingValue)
                            }
                            height = 0
                        }
                        return result
                    })
                    .alignmentGuide(.leading, computeValue: { d in
                        if abs(width - d.width) > proxy.size.width - paddingValue {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if hashtag == data.wrappedValue.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    
                    // modifier の順番は関係なく　.leadingが先に実行されるような感じっぽい
                }.padding(paddingValue)
            }
            
        }
        
        
        
        
    }
}


#Preview {
    AKnock4.ContentView()
}


