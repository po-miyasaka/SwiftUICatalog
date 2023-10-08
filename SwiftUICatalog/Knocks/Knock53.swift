//
//  Knock54.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/24.
//

import AVFoundation
import SwiftUI
enum Knock53 {
    struct ContentView: View {
        @State var player: AVAudioPlayer = {
            let asset = NSDataAsset(name: "U2a")

            return try! .init(data: asset!.data)
        }()

        var body: some View {
            Button("play", action: {
                player.play()
            })
        }
    }
}

#Preview {
    Knock53.ContentView()
}
