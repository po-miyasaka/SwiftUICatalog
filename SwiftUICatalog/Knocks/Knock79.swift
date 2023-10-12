//
//  Knock79.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import PhotosUI
import SwiftUI
import UIKit

enum Knock79 {
    struct ContentView: View {
        @State var show: Bool = false
        @State var image: UIImage?
        @State var delegate: D?
        var body: some View {
            Toggle("Photo", isOn: $show)
                .sheet(isPresented: $show, content: {
                    PHPView(delegate: D(handler: { image in
                        if let image {
                            self.image = image
                        }
                        self.show = false
                    }))

                })
            if let image {
                Image(uiImage: image).resizable().frame(width: 200, height: 200)
            }
        }
    }

    struct PHPView: UIViewControllerRepresentable {
        var delegate: D?
        func makeUIViewController(context _: Context) -> PHPickerViewController {
            let vc = PHPickerViewController(configuration: .init(photoLibrary: .shared()))
            vc.delegate = delegate
            return vc
        }

        func updateUIViewController(_: PHPickerViewController, context _: Context) {}

        typealias UIViewControllerType = PHPickerViewController
    }

    class D: PHPickerViewControllerDelegate {
        var handler: (UIImage?) -> Void
        init(handler: @escaping (UIImage?) -> Void) {
            self.handler = handler
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let result = results.first else  {
                handler(nil)
                return
            }
            results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] content, _ in
                self?.handler(content as? UIImage)
            })
        }
    }
}

#Preview {
    Knock79.ContentView()
}
