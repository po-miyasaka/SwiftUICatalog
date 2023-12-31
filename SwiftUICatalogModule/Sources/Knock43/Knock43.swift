//
//  Knock43.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import Combine
import SwiftUI
import Common
public enum Knock43 {
    @available(iOS 15, *)
    @MainActor
    public struct ContentView: View {
public init() {}
        @ObservedObject var r = Repository()
        @State var repos: [Repo] = []
        @State var query = ""
        @State var cancellables: [AnyCancellable] = []
        func search() {
            r.search(query: query)
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
            .task {
                r.reposPublisher.sink(receiveValue: { value in
                    self.repos += value
                }).store(in: &cancellables)
            }
        }
    }
}

@available(iOS 15, *)
#Preview {
    Knock43.ContentView()
}
