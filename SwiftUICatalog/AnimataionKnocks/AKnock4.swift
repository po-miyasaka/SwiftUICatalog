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
    struct ContentView: View {
        @Namespace var namespace

        @State var hashTags: [HashTag] = Array(defaultTags.prefix(30))
        @State var selected: HashTag?
        @State var selection: [HashTag] = []
        @State var selectionHeight: CGFloat = .zero
        @State var sourceHeight: CGFloat = .zero
        var paddingValue: CGFloat = 16
        var body: some View {
            ScrollView {
                VStack(alignment: .center, spacing: 200) {
                    GeometryReader { geometry in
                        tags(data: $hashTags, proxy: geometry) {
                            !selection.contains($0)
                        }
                    }
                    .frame(minHeight: sourceHeight)
                    .zIndex(1)

                    GeometryReader { geometry in
                        selectedTags(data: $selection, proxy: geometry)
                    }
                    .frame(height: selectionHeight)
                    .padding()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onPreferenceChange(SelectionPreferenceKey.self, perform: { value in
                selectionHeight = value
                })
            .onPreferenceChange(SourcePreferenceKey.self, perform: { value in
                sourceHeight = value
                })
        }

        @ViewBuilder
        func selectedTags(data: Binding<[HashTag]>, proxy: GeometryProxy) -> some View {
            var width: CGFloat = 0
            var height: CGFloat = 0
            var selectionHeight: CGFloat = 0.0

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
                                selectionHeight = -(result - d.height - paddingValue)

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
                        .preference(key: SelectionPreferenceKey.self, value: selectionHeight)
                }
            }
            .padding(paddingValue)
            .background(Color.gray.opacity(0.5))
            .cornerRadius(paddingValue)
        }

        @ViewBuilder
        func tags(data: Binding<[HashTag]>, proxy: GeometryProxy, isSource: @escaping (HashTag) -> Bool) -> some View {
            var width: CGFloat = 0
            var height: CGFloat = 0
            var sourceHeight: CGFloat = 0

            ZStack(alignment: .topLeading) {
                // .topLeadingが無いとalignmentGuideが呼ばれない。
                ForEach(data, id: \.id) { $hashtag in
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
                            sourceHeight = -(result - d.height - paddingValue)

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
                    }).preference(key: SourcePreferenceKey.self, value: sourceHeight)

                    // modifier の順番は関係なく　.leadingが先に実行されるような感じっぽい
                }.padding(paddingValue)
            }
        }
    }
}

struct SelectionPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}

struct SourcePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}

#Preview {
    AKnock4.ContentView()
}
