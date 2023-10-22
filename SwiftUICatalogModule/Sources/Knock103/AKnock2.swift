//
//  AKnock2.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/28.
//

import Combine
import SwiftUI
import Common


public struct ContentView: View {
    public init() {}
    @State var isOn = false
    public var body: some View {
        ZStack {
            isOn ? Color.secondary : Color.white
            SkyButton(isOn: $isOn)
        }.ignoresSafeArea()
    }
}

#warning("@MainActorが無いと、内部のTaskから＠Stateを変更しようとしようとするとエラー。body以外はmainactorじゃないんだな")
@MainActor
struct SkyButton: View {
    @State var progress: Double = 0.0
    @State var starOffset: Double = -45
    @State var cloudOffset: Double = 0
    @Binding var isNight: Bool
    @State var isNightForBackGround: Bool
    @State var cancellable: AnyCancellable?
    @State var starScale = 1.0
    @State var starScale2 = 1.0
    @State var starScale3 = 1.0
    init(isOn: Binding<Bool>) {
        _isNight = isOn
        isNightForBackGround = isOn.wrappedValue
    }
    
    public var body: some View {
        button
    }
    
    var button: some View {
        ZStack(alignment: .center) {
            isNightForBackGround ? Color.black : Color.blue
            cloudBack.rotationEffect(.degrees(isNight ? -180.0 : 0.0), anchor: .init(x: 3, y: 0))
            cloud.rotationEffect(.degrees(isNight ? -60.0 : 0.0), anchor: .init(x: 3, y: 0))
            mainStarLight.offset(x: isNight ? 45 : -45)
            
            //                if #available(iOS 15.0, *) {
            //                    moon.offset(x: isNight ? 0 : -90).mask {
            //                        Color.white.frame(width: 46, height: 46)
            //                            .clipShape(Circle()).opacity(isNight ? 0.9 : 0.0).offset(x: isNight ? 45 : -45)
            //                    }
            //                }
            
            moon.offset(x: isNight ? 0 : -45)
                .clipShape(Circle().offset(x: isNight ? 45 : -45))
            
            stars.rotationEffect(.degrees(isNight ? 0.0 : 180.0), anchor: .init(x: 3, y: 0))
            meteo
            buttonOutLine
        }
        
        .onTapGesture {
            withAnimation(Animation.spring(duration: 0.4, bounce: 0.4, blendDuration: 0.3)) {
                isNight.toggle()
            }
            
            if !isNightForBackGround {
                isNightForBackGround = true
                
            } else {
                withAnimation(Animation.spring(duration: 0.4, bounce: 0.0, blendDuration: 0.3)) {
                    isNightForBackGround = false
                }
            }
            
            shootingProgress = 0
            Task { @MainActor in
                triggerHaptic()
                try await Task.sleep(nanoseconds: 2_000_000_000)
                if isNight {
                    withAnimation(.easeInOut(duration: 1.4)) {
                        shootingProgress = 1
                    }
                }
            }
        }
        .frame(width: 150, height: 60)
        .clipShape(Capsule().size(width: 150, height: 60))
        .contentShape(Capsule().size(width: 150, height: 60))
    }
    
    @ViewBuilder
    var cloud: some View {
        let cloudParts: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (-60, 35, 30, 30),
            (-30, 40, 30, 30),
            (-11, 35, 35, 35),
            (0, 35, 40, 40),
            (30, 45, 40, 40),
            (40, 30, 50, 50),
            (70, 5, 50, 50),
            (-75, 50, 150, 40),
            (-10, 60, 50, 50),
            (1, 60, 50, 50),
        ]
        
        ForEach(cloudParts, id: \.0) { offsetX, offsetY, width, height in
            cloudPart(color: { Color.white }, offsetX: offsetX, offsetY: offsetY, width: width, height: height)
        }
    }
    
    @ViewBuilder
    var cloudBack: some View {
        let cloudParts: [(CGFloat, CGFloat, CGFloat, CGFloat)] = [
            (-60, 25, 30, 30),
            (-30, 20, 30, 30),
            (-10, 15, 35, 35),
            (0, 25, 40, 40),
            (25, 25, 40, 40),
            (35, 20, 50, 50),
            (65, -15, 50, 50),
        ]
        
        ForEach(cloudParts, id: \.0) { offsetX, offsetY, width, height in
            
            cloudPart(color: {
                Color.init("cyan2", bundle: nil)
            }, offsetX: offsetX, offsetY: offsetY, width: width, height: height)
        }
    }
    
    @ViewBuilder
    func cloudPart(color: () -> some View, offsetX: CGFloat, offsetY: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        color()
            .frame(width: width, height: height)
            .clipShape(Circle())
            .offset(x: offsetX, y: offsetY)
    }
    
    @ViewBuilder
    var mainStarLight: some View {
        Color.white.frame(width: 300, height: 300).clipShape(Circle()).opacity(isNight ? 0.0 : 0.3)
        Color.white.frame(width: 180, height: 180).clipShape(Circle()).opacity(isNight ? 0.1 : 0.2)
        Color.white.frame(width: 135, height: 135).clipShape(Circle()).opacity(isNight ? 0.1 : 0.1)
        Color.white.frame(width: 90, height: 90).clipShape(Circle()).opacity(0.07)
        mainStar
    }
    
    @ViewBuilder
    var buttonOutLine: some View {
        //            Rectangle().clipShape(Capsule().stroke(lineWidth: 3)).frame(width: 150, height: 60).opacity(isNight ? 0.1 : 0.3).offset(x: 1, y: 1)
        /*.shadow(color: .white, radius: 2, x: 2, y: 2)*/
        Rectangle().clipShape(Capsule().stroke(lineWidth: 1)).frame(width: 150, height: 60)
            .shadow(color: .black, radius: 3, x: 0, y: 0).opacity(isNight ? 0 : 0.4)
    }
    
    var twinkle: some View {
        Image("twinkle", bundle: .main).renderingMode(.template).resizable().foregroundColor(.white)
    }
    
    @ViewBuilder
    var stars: some View {
        Group {
            twinkle.frame(width: 10 * starScale, height: 10 * starScale).offset(x: -8, y: -15)
            twinkle.frame(width: 30 * starScale2, height: 30 * starScale2)
            twinkle.frame(width: 10 * starScale3, height: 10 * starScale3).offset(x: -30, y: 5)
            twinkle.frame(width: 20 * starScale, height: 20 * starScale).offset(x: -35, y: -20)
            twinkle.frame(width: 15 * starScale2, height: 15 * starScale2).offset(x: -50, y: 15)
            twinkle.frame(width: 20 * starScale3, height: 20 * starScale3).offset(x: 10, y: 20)
            
        }.onAppear(perform: {
            withAnimation(Animation.easeIn(duration: 0.9).repeatForever(autoreverses: true)) {
                starScale = 1.6
            }
            withAnimation(Animation.easeOut(duration: 1.3).repeatForever(autoreverses: true)) {
                starScale2 = 0.8
            }
            withAnimation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                starScale3 = 1.4
            }
        })
    }
    
    @ViewBuilder
    var mainStar: some View {
        Color.yellow.frame(width: 45, height: 45).clipShape(Circle()).opacity(0.9).shadow(color: .white.opacity(0.5), radius: 0.1, x: -2, y: -2).shadow(color: .black.opacity(0.5), radius: 2, x: 2, y: 2)
        Color.white.frame(width: 43, height: 43).clipShape(Circle()).opacity(0.6).shadow(color: .white, radius: 2, x: -2, y: -2)
        Color.yellow.frame(width: 42, height: 42).clipShape(Circle()).opacity(0.9).shadow(color: .white.opacity(0.9), radius: 0.1, x: -2, y: -2).shadow(color: .black.opacity(0.3), radius: 2, x: 2, y: 2)
    }
    
    var moon: some View {
        
        ZStack { // ここGroupにすると上位のmodifierが描くそれぞれに対して作用する
            UIColor.lightGray.getColor().frame(width: 45, height: 45).clipShape(Circle()).opacity(0.99).offset(x: 45)
            Color.gray.frame(width: 10, height: 10).clipShape(Circle()).opacity(0.99).offset(x: 55, y: 5)
            Color.gray.frame(width: 15, height: 15).clipShape(Circle()).opacity(0.99).offset(x: 35, y: 0)
            Color.gray.frame(width: 4, height: 4).clipShape(Circle()).opacity(0.99).offset(x: 55, y: -10)
        }
    }
    
    @State var shootingProgress: Double = 0.1
    var meteo: some View {
        Color.white.clipShape(Capsule()).offset(y: -5).modifier(Shooting(animatableData: shootingProgress)).rotationEffect(.degrees(-40), anchor: .center).opacity(0.9)
    }
}

struct Shooting: AnimatableModifier {
    var animatableData: Double
    
    func body(content: Content) -> some View {
        content.offset(x: 60 - (120 * animatableData))
            .frame(width: max(15 - abs(15 - 30 * animatableData), 0), height: max(2 - abs(2 - 4 * animatableData), 0))
    }
}


struct Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}
