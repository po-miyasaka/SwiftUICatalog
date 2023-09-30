//
//  Knock83.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import SwiftUI
import PDFKit
enum Knock83 {
    struct ContentView: View {
        
        var body: some View {
            PDFV()
        }
    }

}

struct PDFV: UIViewRepresentable {
    func makeUIView(context: Context) -> PDFView {
        let v = PDFView()
        let document = PDFDocument.init()
        let imagePDF = PDFPage.init(image: UIImage(named: "kabigon2")!)
        document.insert(imagePDF!, at: 0)
        v.document = document
        return v
    }
    
    func makeCoordinator() -> Delegate {
        Delegate()
    }
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
    
    typealias UIViewType = PDFView
    
    class Delegate: NSObject, PDFViewDelegate {
        
    }
}



#Preview {
    Knock83.ContentView()
}
