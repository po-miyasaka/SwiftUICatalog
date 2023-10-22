//
//  SwiftUIView.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import Combine
import SwiftUI
public enum Knock47 {
    public struct ContentView: View {
public init() {}
        @State var str: String = ""
        @State var keyboardState: String = ""
        @State var cancellable: Set<AnyCancellable> = []

        @MainActor func listen() {
            NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification).sink(receiveValue: { _ in
                keyboardState = "hide"
            })
                .store(in: &cancellable)

            NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification).sink(receiveValue: { _ in

                keyboardState = "show"
            }).store(in: &cancellable)
        }

        public var body: some View {
            VStack {
                TextField("text", text: $str)
                    .onAppear {
                        listen()
                    }
                Text(keyboardState)
            }
        }
    }
}

#Preview {
    Knock47.ContentView()
}
