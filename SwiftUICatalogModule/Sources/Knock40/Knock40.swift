//
//  Knock40.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI

public enum Knock40 {
    public struct ContentView: View {
public init() {}
        @State var isPresentSheet = false
        @State var shouldShowFullModal = false
        public var body: some View {
            Button("show", action: {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isPresentSheet = true
                }

            }).sheet(isPresented: $isPresentSheet, content: {
                NavigationView {
                    VStack {
                        Button("modal", action: {
                            var transaction = Transaction()
                            transaction.disablesAnimations = true
                            withTransaction(transaction) {
                                shouldShowFullModal = true
                            }

                        }).animation(.none).fullScreenCover(isPresented: $shouldShowFullModal, content: {
                            Text("Full Modal").animation(nil)
                        })
                    }
                }.animation(.none)

            }).animation(nil)
        }
    }
}

#Preview {
    Knock40.ContentView()
}
