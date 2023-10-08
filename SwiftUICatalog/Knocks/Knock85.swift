//
//  Knock85.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import SwiftUI
enum Knock85 {
    struct ContentView: View {
        @State var url: URL?
        @State var show: Bool = false
        var body: some View {
            Button(action: {
                show = true
            }, label: {
                Text("choose")
            }).sheet(isPresented: $show, content: {
                DocVC(url: $url)
            }).sheet(item: $url, content: { url in
                let _ = url.startAccessingSecurityScopedResource()
                if let data = try? String(contentsOf: url, encoding: .utf8) {
                    Text(data)
                }

                let _ = url.stopAccessingSecurityScopedResource()
            })
        }
    }

    struct DocVC: UIViewControllerRepresentable {
        @Binding var url: URL?
        func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
            // add permission with NSDocumentsFolderUsageDescription in info.plist
            let vc = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: false)
            vc.delegate = context.coordinator
            return vc
        }

        func makeCoordinator() -> UIDocumentPickerDelegate {
            Delegate(completion: { url in
                self.url = url
            })
        }

        func updateUIViewController(_: UIDocumentPickerViewController, context _: Context) {}

        typealias UIViewControllerType = UIDocumentPickerViewController
    }

    class Delegate: NSObject, UIDocumentPickerDelegate {
        let completion: (URL?) -> Void
        init(completion: @escaping (URL?) -> Void) {
            self.completion = completion
        }

        func documentPicker(_: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completion(urls.first)
        }

        func documentPickerWasCancelled(_: UIDocumentPickerViewController) {
            completion(nil)
        }
    }
}

extension URL: Identifiable {
    public var id: String {
        absoluteString
    }
}

#Preview {
    Knock85.ContentView()
}
