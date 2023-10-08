//
//  Knock101.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import SwiftUI
enum Knock101 {
    struct ContentView: View {
        @GestureState private var isDetectingLongPress = false
        @State private var totalNumberOfTaps = 0
        @State private var doneCounting = false

        var body: some View {
            let press = LongPressGesture(minimumDuration: 5)
                .updating($isDetectingLongPress) { currentState, gestureState, _ in
                    gestureState = currentState // this update isDetectingLongPress only during long tapping.
                }.onChanged { _ in
                    self.totalNumberOfTaps += 1
                }
                .onEnded { _ in
                    self.doneCounting = true
                }

            return VStack {
                Text("\(totalNumberOfTaps)")
                    .font(.largeTitle)

                Text("\(isDetectingLongPress ? "true" : "false")")
                    .font(.largeTitle)

                Circle()
                    .fill(doneCounting ? Color.red : isDetectingLongPress ? Color.yellow : Color.green)
                    .frame(width: 100, height: 100, alignment: .center)
                    .gesture(doneCounting ? nil : press)
            }
        }
    }
}

#Preview {
    Knock101.ContentView()
}
