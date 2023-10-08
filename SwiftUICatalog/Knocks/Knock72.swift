//
//  Knock72.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/26.
//

import SwiftUI

enum Knock72 {
    @available(iOS 15, *)
    @MainActor
    struct ContentView: View {
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

        var body: some View {
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
                        }, footer: {
                            if r.isLoading {
                                ProgressView().progressViewStyle(.circular)
                                    .frame(maxWidth: .infinity, minHeight: 50)
                            } else {
                                ProgressView().hidden()
                            }
                        }
                    )
                }
            }
        }
    }
}

@available(iOS 15, *)
#Preview {
    Knock72.ContentView()
}
