//
//  Knock54.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/24.
//

import AVFoundation
import SwiftUI
public enum Knock53 {
    public struct ContentView: View {
public init() {}
        @State var player: AVAudioPlayer = {
            let asset = NSDataAsset(name: "U2a", bundle: .main)

            return try! .init(data: asset!.data)
        }()

        public var body: some View {
            Button("play", action: {
                player.play()
            })
        }
    }
}

#Preview {
    Knock53.ContentView()
}
