//
//  Knock79.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import SwiftUI
import UIKit
import PhotosUI

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
        func makeUIViewController(context: Context) -> PHPickerViewController {
            let vc = PHPickerViewController(configuration: .init(photoLibrary: .shared()))
            vc.delegate = delegate
            return vc
            
        }
        
        
        func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
            
        }
        
        typealias UIViewControllerType =  PHPickerViewController
        
    }
    
    class D: PHPickerViewControllerDelegate {
        var handler: (UIImage?) -> ()
        init (handler: @escaping (UIImage?) -> ())  {
            self.handler = handler
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: {[weak self] content, error in
                self?.handler(content as? UIImage)
            })
        }
    }
}

#Preview {
    Knock79.ContentView()
}
