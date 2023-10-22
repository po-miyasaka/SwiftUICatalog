//
//  Knock28.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/21.
//

import SwiftUI
import Common
public enum Knock28 {
    struct SectionData: Identifiable {
        let id: String
        let rows: [Row]
    }

    struct Row: Identifiable {
        let distination: Dist
        let title: String
        let id = UUID()
    }

    enum Dist {
        case thunder
        case normal
        case trainer
    }

    public struct ContentView: View {
public init() {}
        @State var selected: Row?
        @State var isSelected: Bool = false
        @State var sections: [SectionData] = [
            .init(
                id: "Pokemon",
                rows: [
                    .init(distination: .thunder, title: "Pikachu"),
                    .init(distination: .normal, title: "Kabigon"),
                ]
            ),
            .init(id: "Trainer",
                  rows: [
                      .init(distination: .trainer, title: "takeshi"),
                  ]),
        ]
        @State var isPresentingAlert: Bool = false
        public var body: some View {
            NavigationView {
                List(sections) { section in
                    ForEach(section.rows) { row in
                        switch row.distination {
                        case .normal:
                            NavigationLink(row.title, destination: {
                                Text("normal \(row.title)")
                            })

                        case .thunder:
                            NavigationLink(row.title, destination: {
                                Text("thunder \(row.title)")
                            })
                        case .trainer:
                            NavigationLink(row.title, destination: {
                                Text("trainer \(row.title)")
                            })
                        }
                    }.if { forEach in // 構造がわかりにくくてよくない。

                        if #available(iOS 15.0, *) {
                            Section(section.id) {
                                forEach
                            }
                        } else {
                            Section(header: Text(section.id)) {
                                forEach
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Knock28.ContentView()
}
