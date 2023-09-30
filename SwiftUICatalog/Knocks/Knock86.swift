//
//  Knock86.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import SwiftUI
import Combine
enum Knock86 {
    
    @available(iOS 15, *)
    @MainActor
    struct ContentView: View {
        @ObservedObject var r = Repository()
        @State var repos: Array<Repo> = []
        @State var query = ""
        
        var body: some View {
            ScrollView {
                LazyVStack(spacing: 1, pinnedViews: .sectionHeaders) {
                    
                    Section(content: {
                        
                        ForEach(Array(zip(repos, repos.indices)) , id: \.0.id) { repository, index in
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(repository.name).task {
                                        if repository == repos.last {
                                            await r.next()
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                            }
                            .frame(minHeight: 60)
                            
                            
                        }
                        .background(content: { Color.white })
                        .padding(.horizontal)
                        
                    }, header: {
                        ZStack {
                            Color(uiColor: .groupTableViewBackground)
                            TextField("query", text: $query)
                                .onSubmit {
                                    repos = []
                                    Task {
                                        await r.search(query: query)
                                    }
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
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
            .clipped()
            .task {
                for await result in r.stream {
                    withAnimation {
                        repos += result
                    }
                    
                }
            }
            
        }
    }
    
}



@available(iOS 15, *)
#Preview {
    Knock86.ContentView()
}
