//
//  SUtil.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/08.
//

import SwiftUI

struct AnimationShowModifier<V: View>: ViewModifier {
    @Binding var showing: Bool
    @State var prepare: Bool = false
    @State var isShow: Bool = false
    let v: () -> V
    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if prepare {
                    Color.black.opacity(0.3).ignoresSafeArea().onTapGesture {
                        withAnimation {
                            prepare = false
                            isShow = false
                            showing = false
                        }
                    }
                    if isShow {
                        v().frame(
                            maxWidth: .infinity,
                            maxHeight: .infinity,
                            alignment: .bottom
                        ).transition(
                            .asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom))
                        )
                        .zIndex(3)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        )
        .onChange(of: showing, perform: { value in
            if value {
                prepare = true
                withAnimation {
                    isShow = true
                }
            }
        })
    }
}
