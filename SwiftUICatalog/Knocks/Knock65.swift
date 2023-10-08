//
//  Knock65.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//
import SwiftUI

private struct DismissModalKey: EnvironmentKey {
    static var defaultValue: (Bool) -> Void = { _ in }
}

extension EnvironmentValues {
    var dismissModal: (Bool) -> Void {
        get { self[DismissModalKey.self] }
        set { self[DismissModalKey.self] = newValue }
    }
}

enum Knock65 {
    struct ContentView: View {
        @State var showSheet: Bool = false

        var body: some View {
            Toggle(isOn: $showSheet, label: {
                Text("sheet")
            }).sheet(isPresented: $showSheet, content: {
                View2().environment(\.dismissModal) { _ in showSheet = false }
            }).padding()
        }
    }

    struct View2: View {
        var body: some View {
            NavigationView {
                NavigationLink("2", destination: {
                    View3()
                }).navigationTitle("2")
            }
        }
    }

    struct View3: View {
        @Environment(\.dismissModal) var dismissModal
        var body: some View {
            Button("pop", action: {
                dismissModal(false)
            }).navigationTitle("3")
        }
    }
}

#Preview {
    Knock65.ContentView()
}
