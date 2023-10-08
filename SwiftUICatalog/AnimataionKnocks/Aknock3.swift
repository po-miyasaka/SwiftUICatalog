//
//  Aknock3.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/29.
//

import SwiftUI

struct ImageData: Identifiable {
    let id: UUID = .init()
    let title: String
    let image: UIImage
}
enum AKnock3 {
    struct ContentView: View {
        let images = [ImageData(title: "カビゴン1", image: UIImage(named: "kabigon")!), ImageData(title: "カビゴン2", image: UIImage(named: "kabigon2")!)]
        
        @Namespace private var namespace
        @State private var selectedImageID: UUID?
        @State var vTitle: String = "List"
        var body: some View {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    
                    ScrollView {
                        
                        VStack {
                            ForEach(images) { image in
                                
                                Image(uiImage: image.image)
                                    .resizable()
                                    .scaledToFit()
                                    .matchedGeometryEffect(id: image.id, in: namespace, properties: .frame, isSource: selectedImageID == image.id)
                                    .frame(width: 100, height: 100, alignment: .leading)
                                    .onTapGesture {
                                        vTitle = image.title
                                        withAnimation(.easeInOut) {
                                            
                                            self.selectedImageID = image.id
                                        }
                                    }
                            }
                        }.frame(maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading)
                    }
                    if let image = images.first{$0.id == selectedImageID } {
                        DetailView(selectedImageID: $selectedImageID,  selectedImage: image, vTitle: $vTitle, namespace: namespace)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(vTitle)
                
                
            }
        }
    }
    
}


struct DetailView: View {
    @Binding var selectedImageID: UUID?
    var selectedImage: ImageData
    @Binding var vTitle: String
    let namespace: Namespace.ID
    @State var opacity: Double = 1.0
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { proxy in
                    Color.clear.preference(key: OP.self, value: proxy.frame(in: .named("scrollView")).minY)
                }.frame(height: 0)
                Image(uiImage: selectedImage.image)
                    .resizable()
                    .scaledToFill()
                    .matchedGeometryEffect(id: selectedImage.id, in: namespace, properties: .frame, isSource: selectedImageID != nil)
                    .opacity(opacity)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        opacity = 0
                        
                        withAnimation(.easeInOut) {
                            self.selectedImageID = nil
                        }
                    }
                
                Text(
                """
その巨体とでっぷりと肥えた腹部が特徴のポケモン。頭部には尖った耳が生え、下顎の犬歯が口を閉じていても飛び出すほどに発達している。体色は黒とクリーム色の二色で、腹部と顔まわり、3本の爪が生えた足がクリーム色、それ以外の全体が黒。

大食漢なポケモンとして有名で、一日に自分の体重の9割近くになる400kgもの食事を取る。食事を終えると寝転がり、空腹になると起き上がって食料を探すといういわゆる「食っちゃ寝」な生活サイクルを送っている。その胃袋は非常に丈夫であり、カビや腐敗した食べ物はおろか、ベトベトンの毒すらも問題なく消化できるほど。

食事と睡眠以外の事には興味がなく、昼寝の最中にお腹をトランポリン代わりにされても一切気にせずに眠り続ける。その大人しさのためか、カビゴンを遊具代わりにして遊ぶ子供もいるほど。ただ、ポケモンの笛と呼ばれる特殊な笛が奏でる音色には反応するようで、どんなに深い眠りに入っていても笛の音を聞くとすぐさま目を覚ます。

色違いは体の黒色部分が青みがかる。
"""
                ).padding()
                Spacer()
            }
            .background(Color.black)
            
        }
        
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(OP.self, perform: { value in
            if value > 30 {
                opacity = 0
                withAnimation(.easeInOut) {
                    
                    self.selectedImageID = nil
                }
            }
        }).background(Color.black)
            .onDisappear{
                withAnimation {
                    vTitle = "List"
                }
            }
        
        
        
        
    }
    
}
struct ImageListView_Previews: PreviewProvider {
    static var previews: some View {
        AKnock3.ContentView()
    }
}


struct OP: PreferenceKey {
    static var defaultValue: Double = .zero
    
    static func reduce(value: inout Double, nextValue: () -> Double) {
        
    }
    
    typealias Value = Double
    
    
}
