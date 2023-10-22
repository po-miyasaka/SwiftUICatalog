//
//  Knock71.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI
import UIKit
public enum Knock71 {
    public struct ContentView: View {
public init() {}
        @State var showActivity: Bool = false
        public var body: some View {
            Toggle(isOn: $showActivity, label: { Text("Show Activity") })
                .sheet(isPresented: $showActivity, content: {
                    UIActivityViewControllerRepresentable()
                })
        }
    }
}

struct UIActivityViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context _: Context) -> UIActivityViewController {
        let items: [Any] = ["Hello, World!", URL(string: "https://www.example.com/")!]

        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_: UIActivityViewController, context _: Context) {}

    typealias UIViewControllerType = UIActivityViewController
}

#Preview {
    Knock71.ContentView()
}
