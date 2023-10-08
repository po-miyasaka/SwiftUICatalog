//
//  ShortsView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct ShortsView: View {
    @Environment(\.safeArea) var safeArea
    @Environment(\.screenSize) var screenSize
    struct TransitionContext {
        enum Source {
            case tabButton
            case playingView
            case homeView
        }

        let source: Source
        let data: ShortData
    }

    @Binding var transitionContext: TransitionContext?

    var body: some View {
        let height = screenSize.height - safeArea().bottom - toolbarHeight
        ZStack(alignment: .topLeading) {
            ScrollView {
                LazyVStack {
                    ZStack {
                        transitionContext?.data.color.frame(height: height)
                        Text("shorts")
                    }
                }
            }
            if transitionContext?.source != .tabButton {
                Button(action: {
                    withAnimation(transitionContext?.source == .tabButton ? .none : .default) {
                        transitionContext = nil
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.top, safeArea().top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}
