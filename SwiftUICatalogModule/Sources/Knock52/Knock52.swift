//
//  Knock53.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/24.
//

import SwiftUI
@available(iOS 15.0, *)
public enum Knock52 {
    public struct ContentView: View {
public init() {}
        @StateObject var repository = Repository()

        public var body: some View {
            NavigationView {
                ZStack {
                    List(content: {
                        Section(
                            content: {
                                ForEach(repository.todos) { todo in
                                    HStack {
                                        Text(todo.title)
                                        Spacer()

                                        Text(todo.limitDate?.description ?? "")
                                    }
                                }.onDelete(perform: { offsets in
                                    repository.delete(indices: offsets)

                                })
                            },
                            footer: {}
                        )

                    }).ignoresSafeArea(edges: [.bottom])

                    NavigationLink(destination: {
                        AddView(add: { new in
                            repository.add(todo: new)
                        })

                    }, label: {
                        Text("Add")
                            .padding()
                            .background(content: { Color.yellow }).frame(alignment: .trailing)
                            .clipShape(Circle()).clipShape(Circle())
                            .foregroundStyle(.white)
                            .clipped()

                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .padding()
                }
                .navigationTitle("TODO")
            }
        }
    }

    @available(iOS 15.0, *)
    struct AddView: View {
        @Environment(\.dismiss) var dismiss
        @State var addingLimitDate: Bool = false
        let add: (TODO) -> Void
        @State var title: String = ""
        @State var date: Date = Date()
        @FocusState var isFocusing
        @ViewBuilder
        public var body: some View {
            List {
                TextField("title", text: $title).focused($isFocusing)
                Toggle(isOn: $addingLimitDate, label: { Text("Limit date") }).toggleStyle(SwitchToggleStyle())
                if addingLimitDate {
                    DatePicker("", selection: $date)
                }
            }
            .onAppear {
                isFocusing = true
            }
            .toolbar(content: {
                Button("Add", action: {
                    add(TODO(title: title, limitDate: addingLimitDate ? date : nil))
                    dismiss()
                })
            })
        }
    }

    class Repository: ObservableObject {
        @Published var todos: [TODO] = {
            let data = UserDefaults.standard.data(forKey: "todos") ?? Data()
            return (try? JSONDecoder().decode([TODO].self, from: data)) ?? []
        }()

        func add(todo: TODO) {
            todos.append(todo)
            save()
        }

        func delete(indices: IndexSet) {
            indices.sorted(by: >).forEach { todos.remove(at: $0) }
            save()
        }

        func save() {
            let data = (try? JSONEncoder().encode(todos)) ?? Data()
            UserDefaults.standard.set(data, forKey: "todos")
        }
    }

    struct TODO: Identifiable, Codable, Equatable {
        // UserDefaultにAppStorage経由で格納するためにRawRepresentableに準拠
        let id: UUID
        var title: String
        let limitDate: Date?

        init(id: UUID = .init(), title: String, limitDate: Date?) {
            self.id = id
            self.title = title
            self.limitDate = limitDate
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    Knock52.ContentView()
}
