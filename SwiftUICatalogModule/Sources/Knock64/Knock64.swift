//
//  Knock64.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI

class Object: ObservableObject {
    @Published var isActve = false
}

public enum Knock64 {
    public struct ContentView: View {
public init() {}
        @StateObject var object = Object()
        @State var isActive: Bool = false

        public var body: some View {
            NavigationView {
                NavigationLink("1", destination:
                    View2().environmentObject(object), isActive: $object.isActve)
            }
        }
    }

    #warning("bug?")
    struct View2: View {
        @EnvironmentObject var object: Object
        public var body: some View {
            NavigationLink("2", destination: {
                View3()
                    .environmentObject(object) //
            })
        }
    }

    struct View3: View {
        @EnvironmentObject var object: Object
        public var body: some View {
            Button("pop", action: {
                object.isActve = false
            })
        }
    }
}

#Preview {
    Knock64.ContentView()
}
