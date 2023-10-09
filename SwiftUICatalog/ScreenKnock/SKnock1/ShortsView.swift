//
//  ShortsView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

struct TransitionContext {
    enum Source {
        case tabButton
        case playingView
        case homeView
    }

    let source: Source
    let data: ShortData
}

struct ShortsView<ViewModel: ViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var layoutObject: LayoutObject

    var body: some View {
        let context = viewModel.output.shortsTransitionContext
        ZStack(alignment: .topLeading) {
            ScrollView {
                LazyVStack {
                    ZStack {
                        let data = context?.data
                        Image(uiImage: UIImage(named: data?.imageName ?? "short1")!)
                            .resizable().scaledToFill().frame(height: layoutObject.shortsHeight)
                        Text(data?.title ?? "short")
                    }
                }
            }
            if context?.source != .tabButton {
                Button(action: {
                    withAnimation(context?.source == .tabButton ? .none : .default) {
                        viewModel.input.hideShort()
                    }
                }, label: {
                    Image(systemName: "chevron.left").resizable().frame(height: 25).foregroundColor(.white)
                }).frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.top, layoutObject.safeArea.top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .transition(
            .asymmetric(insertion: .backslide,
                                removal: .slide))
        .zIndex(context?.source == .tabButton ? 0 : 1)
        .ignoresSafeArea(edges: [.top])
    }
}
