//
//  Knock42.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/22.
//

import SwiftUI
import Combine

enum Knock42 {
    
    @available(iOS 15, *)
    @MainActor
    struct ContentView: View {
        @ObservedObject var r = Repository()
        @State var repos: Array<Repo> = []
        @State var query = ""
        
        func search() {
            r.search(query: query, completion: { result in
                withAnimation(.easeOut, {
                    repos += result
                })
            })
        }
        
        var body: some View {
            
            ScrollView(.vertical) {
                TextField("query", text: $query).onSubmit {
                    repos = []
                    search()
                }
                .textFieldStyle(RoundedBorderTextFieldStyle()).padding(.horizontal)
                .onPreferenceChange(OffsetPK.self, perform: { offset in
                    print(offset)
                    // セルの再利用のためにスクロールしてしばらくすると音沙汰がなくなる。再表示される際に
                }
                )
                
                LazyVStack {
                    
                    GeometryReader(content: {reader in
                        
                        Color.clear.preference(
                            key: OffsetPK.self,
                            
                            value: reader.frame(in: .named("offset")).minY)
                    })
                    Section(
                        content: {
                            ForEach(Array(zip(repos, repos.indices)) , id: \.0.id) { repository, index in
                                Text(repository.name).task {
                                    if repository == repos.last {
                                        search()
                                    }
                                }
                            }
                        },
                        
                        footer: {
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
            .coordinateSpace(name: "offset")
            
        }
    }
    
}



@available(iOS 15, *)
#Preview {
    Knock42.ContentView()
}


enum OffsetPK: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        
    }
    
    typealias Value = CGFloat
}
