//
//  Knock73.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI
import Common
public enum Knock73 {
    @available(iOS 15, *)
    @MainActor
    public struct ContentView: View {
public init() {}
        @ObservedObject var r = Repository()
        @State var repos: [Repo] = []
        @State var query = ""

        func search() {
            r.search(query: query, completion: { result in
                withAnimation(.easeOut) {
                    repos += result
                }
            })
        }

        public var body: some View {
            VStack {
                TextField("query", text: $query).onSubmit {
                    repos = []
                    search()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle()).padding()

                List {
                    Section(
                        content: {
                            ForEach(Array(zip(repos, repos.indices)), id: \.0.id) { repository, _ in
                                Text(repository.name).task {
                                    if repository == repos.last {
                                        search()
                                    }
                                }
                            }
                        }
                    )
                }
            }
            .overlay(content: {
                if r.isLoading {
                    ProgressView().progressViewStyle(.circular)
                        .padding(16)
                        .background(content: { Color.black.opacity(0.1) })
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 100, height: 100, alignment: .center)
                }
            })
        }
    }
}

@available(iOS 15, *)
#Preview {
    Knock73.ContentView()
}
