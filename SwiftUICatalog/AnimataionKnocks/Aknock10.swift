// Using this library
// https://github.com/ryanlintott/LookingGlassUI

import Combine
import CoreMotion
import GameplayKit
import LookingGlassUI
import Metal
import SwiftUI
enum AKnock10 {
    @available(iOS 17.0, *)
    struct ContentView: View {
        @State var isLoading: Bool = false
        @State private var pitch: Double = 0
        @State private var roll: Double = 0
        @State private var yaw: Double = 0
        @State var image: Image = {
            let image = UIImage(named: "glass")
            let cgImage = image!.cgImage
            return Image(cgImage!, scale: 1, label: Text(""))
        }()

        let motionManager = CMMotionManager()

        var body: some View {
            VStack(alignment: .leading) {
//                Text("Pitch: \(pitch)")
//                Text("Roll: \(roll)")
//                Text("Yaw: \(yaw)")

                VStack {
                    Image("kabigon3").resizable()
                        .frame(width: 200, height: 200)
                        .shimmer(color: .yellow)
                    LookingGlass(.reflection, distance: 100, perspective: 0, pitch: .degrees(45), yaw: .zero, localRoll: .zero, isShowingInFourDirections: false) {
                        Image("kabigon3").resizable()
                            .frame(width: 200, height: 200)
                    }
                    Image("kabigon3").resizable()
                        .frame(width: 200, height: 200)
                        .parallax(multiplier: 40, maxOffset: 100)
                }

//                Canvas{ context, size in
//                    var imageContext = context
//
//                    //                    imageContext.addFilter(.alphaThreshold(min: 0.4, color: .black))
//
//                    imageContext.addFilter(
//                          .colorShader(
//                            ShaderLibrary.holographic(.image(image), .float(pitch))
//                          )
//                      )
//                    imageContext.drawLayer(content: { graphicsContext in
//                        let image = CGPoint(x: size.width / 2, y: size.height / 2)
//                        graphicsContext.draw(context.resolveSymbol(id: ID.image)!, at: image)
//                    })
//
//                } symbols: {
//                    RefreshImage(image: UIImage(systemName: "pencil.circle.fill")!).tag(ID.image)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
//                        startMotionUpdates()
                }
                .onDisappear {
                    motionManager.stopDeviceMotionUpdates()
                }
            }
        }

        func startMotionUpdates() {
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.1
                motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, _ in
                    if let attitude = motion?.attitude {
                        self.pitch = attitude.pitch
                        self.roll = attitude.roll
                        self.yaw = attitude.yaw
                    }
                }
            }
        }

        struct RefreshImage: View {
            @State var image: UIImage
            @State var angle: Int = 0
            var body: some View {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
    }

    enum ID: CaseIterable, Hashable {
        case image
    }
}

@available(iOS 17.0, *)
#Preview {
    AKnock10.ContentView()
}
