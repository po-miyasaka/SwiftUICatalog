//
//  Knock1.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import Combine
import SwiftUI

enum AKnock1 {
    struct ContentView: View {
        @State private var completedLongPress = false
        var body: some View {
            VStack {
                Spacer()
                LongTapButton(title: "Submit", time: 2.0, completedLongPress: $completedLongPress)
                Button(action: {
                    completedLongPress = false
                }, label: {
                    Text("Reset")
                }).frame(maxHeight: .infinity)
            }
        }
    }

    struct LongTapButton: View {
        let title: String
        let time: Double
        @Binding var completedLongPress: Bool
        @State private var progress: Double = 0.0
        @State var startTime: Date?
        @State var finishTime: Date?
        @State var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
        @State var cancellable: AnyCancellable?
        @State var buttonScaleForCompletion: Double = 1
        @GestureState var pressing = false

        var longPress: some Gesture {
            LongPressGesture(minimumDuration: time)
                .updating($pressing, body: { value, gestureState, _ in
                    gestureState = value
                })
                .onEnded { finished in

                    if finished {
                        self.completedLongPress = true
                        buttonScaleForCompletion = 0.7
                        Task { @MainActor in
                            triggerHaptic()
                        }

                        withAnimation(Animation.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 4)) {
                            buttonScaleForCompletion = 1
                        }
                    }
                }
        }

        var body: some View {
            Circle()
                .fill(self.completedLongPress ? Color.green : Color.blue)
                .frame(width: 100, height: 100, alignment: .center)
                .gesture(longPress)
                .modifier(DrawingCircleModifier(complete: completedLongPress, animatableData: progress))
                .onChange(of: pressing, perform: { pressing in

                    if pressing, !completedLongPress {
                        startTime = Date()
                        timer = Timer.publish(every: 0.01, on: .main, in: .default).autoconnect()
                        cancellable = timer?.sink(receiveValue: { date in
                            self.progress = date.timeIntervalSince(startTime ?? Date()) / time
                        })
                    } else {
                        withAnimation {
                            progress = 0
                        }
                        cancellable?.cancel()
                        timer = nil
                    }
                })
                .scaleEffect(buttonScaleForCompletion)
                .overlay(
                    ZStack {
                        if !pressing && !completedLongPress {
                            Text(title).fontWeight(.bold).foregroundColor(.white)
                        }
                        Image(systemName: "checkmark")
                            .resizable()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.white)
                            .opacity(completedLongPress ? 1 : 0)
                            .scaleEffect(completedLongPress ? 1 : 0.1)
                            .animation(Animation.spring(response: 0.4, dampingFraction: 0.4, blendDuration: 4), value: completedLongPress)
                    }
                )
        }

        struct DrawingCircleModifier: AnimatableModifier {
            var complete: Bool
            var animatableData: Double
            var color: Color {
                if complete {
                    Color.green
                } else {
                    Color.blue
                }
            }

            var baseScale: Double {
                if isPressing {
                    return 1.0
                } else {
                    return 1.0
                }
            }

            var isPressing: Bool {
                animatableData != 0
            }

            func body(content: Content) -> some View {
                content.scaleEffect(
                    CGSize(
                        width: max(baseScale - (animatableData * 10), 0.85),
                        height: max(baseScale - (animatableData * 10), 0.85)
                    )
                )
                .overlay(
//                    complete ? nil :
                    GeometryReader {
                        geometry in
                        Path { path in
                            path.addArc(
                                center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                                radius: geometry.size.width / 2,
                                startAngle: Angle(degrees: -90),
                                endAngle: Angle(degrees: -90 + 365 * animatableData),
                                clockwise: false
                            )
                        }
                        .stroke(color, lineWidth: 5)
                    }
                )
            }
        }
    }
}
