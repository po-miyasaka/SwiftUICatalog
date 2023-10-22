//
//  Knock58.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import SwiftUI
import Common
public enum Knock58 {
    public struct ContentView: View {
public init() {}
        @State var show: Bool = false
        public var body: some View {
            ZStack(alignment: .center) {
                Button("Show", action: {
                    withAnimation(.easeInOut) {
                        show.toggle()
                    }
                })

                if show {
                    Popup(show: $show)
                }
            }
        }
    }

    struct Popup: View {
        @Binding var show: Bool
        public var body: some View {
            ZStack(alignment: .center) {
                Color.black.opacity(0.3)
                VStack(spacing: 8.0) {
                    Text("Title").font(.title)
                    VStack(spacing: 20.0) {
                        Image("kabigon", bundle: nil)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 150, maxHeight: 200)

                        Button("Close") {
                            withAnimation {
                                show.toggle()
                            }
                        }
                    }
                }
                .frame(maxWidth: 300)
                .padding()
                .if {
                    if #available(iOS 15.0, *) {
                        $0.background(content: { Color.white })
                    } else {
                        $0
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Knock58.ContentView()
}
