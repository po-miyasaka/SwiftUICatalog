//
//  SUtil.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/08.
//

import SwiftUI

struct AnimationModalModifier<V: View>: ViewModifier {
    @Binding var shouldShow: Bool
    let v: () -> V
    @State var prepare: Bool = false
    @State var isShowing: Bool = false
    
    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                if prepare {
                    Color.black.opacity(0.3).ignoresSafeArea().onTapGesture {
                        withAnimation {
                            prepare = false
                            isShowing = false
                            shouldShow = false
                        }
                    }
                    if isShowing {
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
        .onChange(of: shouldShow, perform: { value in
            if value {
                prepare = true
                withAnimation {
                    isShowing = true
                }
            }
        })
    }
}

extension View {
    func modal<V: View>(shouldShow: Binding<Bool>, _ v: @escaping () -> V) -> some View {
        modifier(AnimationModalModifier(shouldShow: shouldShow, v: v))
    }
}
