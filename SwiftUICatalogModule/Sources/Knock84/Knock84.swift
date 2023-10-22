//
//  Knock84.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import SwiftUI

public enum Knock84 {
    public struct ContentView: View {
public init() {}
        public var body: some View {
            GeometryReader { proxy in
                ZStack {
                    ZoomImage(size: proxy.size, imageName: "kabigon2")
                }
            }
        }
    }
}

struct ZoomImage: UIViewRepresentable {
    let size: CGSize
    let imageName: String
    func makeUIView(context _: Context) -> ZoomImageView {
        ZoomImageView(size: size, image: UIImage(named: imageName)!)
    }

    func updateUIView(_: ZoomImageView, context _: Context) {}

    typealias UIViewType = ZoomImageView
}

class ZoomImageView: UIView, UIScrollViewDelegate {
    var scrollView: UIScrollView = .init()
    var uiImageView: UIImageView

    init(size: CGSize, image: UIImage) {
        uiImageView = UIImageView(image: image)
        uiImageView.contentMode = .scaleAspectFit
        super.init(frame: .init(x: 0, y: 0, width: size.width, height: size.height))

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.backgroundColor = .black

        scrollView.addSubview(uiImageView)
        addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            uiImageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            uiImageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            uiImageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            uiImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            uiImageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            uiImageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func viewForZooming(in _: UIScrollView) -> UIView? {
        uiImageView
    }
}

#Preview {
    Knock84.ContentView()
}
