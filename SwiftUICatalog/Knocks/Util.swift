//
//  Util.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<Transform: View>(_ condition: Bool = true, @ViewBuilder transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

}

let sampleText = """
その巨体とでっぷりと肥えた腹部が特徴のポケモン。頭部には尖った耳が生え、下顎の犬歯が口を閉じていても飛び出すほどに発達している。体色は黒とクリーム色の二色で、腹部と顔まわり、3本の爪が生えた足がクリーム色、それ以外の全体が黒。

大食漢なポケモンとして有名で、一日に自分の体重の9割近くになる400kgもの食事を取る。食事を終えると寝転がり、空腹になると起き上がって食料を探すといういわゆる「食っちゃ寝」な生活サイクルを送っている。その胃袋は非常に丈夫であり、カビや腐敗した食べ物はおろか、ベトベトンの毒すらも問題なく消化できるほど。

食事と睡眠以外の事には興味がなく、昼寝の最中にお腹をトランポリン代わりにされても一切気にせずに眠り続ける。その大人しさのためか、カビゴンを遊具代わりにして遊ぶ子供もいるほど。ただ、ポケモンの笛と呼ばれる特殊な笛が奏でる音色には反応するようで、どんなに深い眠りに入っていても笛の音を聞くとすぐさま目を覚ます。

色違いは体の黒色部分が青みがかる。
"""
