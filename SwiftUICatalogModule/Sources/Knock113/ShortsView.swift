//
//  ShortsView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/07.
//

import SwiftUI

public struct TransitionContext {
    public enum Source {
        case tabButton
        case playingView
        case homeView
    }

    public let source: Source
    public let data: ShortData
    public init(source: Source, data: ShortData) {
        self.source = source
        self.data = data
    }
    
}

public struct ShortsView<ViewModel: ViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel
    @ObservedObject var layoutObject: LayoutObject
    public init(viewModel: ViewModel, layoutObject: LayoutObject) {
        self.viewModel = viewModel
        self.layoutObject = layoutObject
    }
    public  var body: some View {
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
