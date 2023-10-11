//
//  AKnock11.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/10.
//

import SwiftUI



struct AKnock11: View {
    
    @State var editingText: String = ""
    @StateObject var viewModel: ChatViewModel = .init()
    struct SectionData: Identifiable, Equatable {
        var id: String { date }
        let date: String
        var messages: [Message]
    }
    cters () r

    var body: some View {
        let screenSize = UIScreen.main.bounds.size
        VStack {
            ScrollViewReader { proxy in  // <-- Removed unnecessary characters from this line
                ScrollView {
                    LazyVStack(edViews: .sectionHeaders, content: {
                        ForEach(viewModel.sectionData) { section in
                            Section(
                                content:
                                    {
                                        ForEach(section.messages) { message in
                                            SpeechBubbleView(
                                                owner: message.owner,
                                                message: message.text,
                                                screenSize: screenSize
                                            ).id(message.id)
                                        }
                                        
                                    } ,header: {
                                        Text(section.date)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.3))
                                            .clipShape(Capsule())
                                    })
                            
                        }
                        
                    })
                }.flip(.vertical)
                .onChange(of: sectionData, perform: { _ in
                    withAnimation {
                        proxy.scrollTo(sectionData.last!.messages.last!.id)
                    }
                })
            }
            
            HStack {
                TextField("", text: $editingText).textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    sectionData[sectionData.count - 1].messages.append(.init(type: .text, owner: .myself, date: "10:32pm", text: editingText))
                    editingText = ""
                }, label: {
                    Image(systemName: "paperplane.fill").resizable().scaledToFit().frame(height: 25)
                })
            }.padding()
        }
        
    }
}


class AKnock11.ChatViewModel: ObservableObject {
    @Published var sectionData: [SectionData] = [
        .init(date: "10/01", messages: [
            .init(type: .text, owner: .opponent, date: "02:23am", text: "Hi"),
            .init(type: .text, owner: .myself, date: "04:39am", text: "Hello")
        ]),
        .init(date: "10/03", messages: [
            .init(type: .text, owner: .opponent, date: "10:30pm", text: "The riffs,  the drums, the vocals. Everything's so wonderful."),
            .init(type: .text, owner: .myself, date: "10:35pm", text: "Thank you")
        ]),
        .init(date: "10/11", messages: [
            .init(type: .text, owner: .opponent, date: "10:30pm", text: "Hi"),
            .init(type: .text, owner: .myself, date: "10:35pm", text: "Hello")
        ])
    ]
}


enum MessageType {
    case text
    case stamp
    case common
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let type: MessageType
    let owner: SpeechBubbleOwner
    let date: String
    let text: String
}



struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        Path({ path in
            
            let radiusSize: CGFloat = 20
            let rect = CGRect.init(origin: .init(x: radiusSize, y: 0), size: .init(width: rect.width - radiusSize, height: rect.height))
            path.addRoundedRect(in: rect, cornerSize: .init(width: radiusSize, height:  radiusSize))
            path.move(to: .init(x: 3, y: 0))
            path.addQuadCurve(to: .init(x: radiusSize * 2, y: 0), control: .init(x: radiusSize, y: radiusSize))
            path.addLine(to: .init(x: radiusSize, y: radiusSize ) )
            path.addQuadCurve(to: .init(x: 8, y: 6), control: .init(x: radiusSize, y: radiusSize))
            
            //            path.addLine(to: .init(x: radiusSize * 2, y: 0))
            //            path.addLine(to: .init(x: radiusSize, y: radiusSize ) )
            //            path.addQuadCurve(to: .zero, control: .init(x: radiusSize, y: 0))
        })
    }
}



enum SpeechBubbleOwner {
    case myself
    case opponent
    case common
}

struct SpeechBubbleView: View {
    let owner: SpeechBubbleOwner
    let message: String
    let screenSize: CGSize
    var body: some View {
        
        
        switch owner {
        case .myself:
            ZStack(alignment: .topLeading) {
                Text(message)
                    .foregroundColor(Color.white).padding(.horizontal,  20)
                    .padding(8)
                    .padding(.trailing,  20)
                    .background(SpeechBubble().flip(.horizontal))
                    .frame(maxWidth: screenSize.width * 0.6, alignment: .trailing)
            }.frame(maxWidth: screenSize.width, alignment: .trailing)
            
            
            
        case .opponent:
            ZStack(alignment: .topTrailing) {
                Text(message)
                    .foregroundColor(Color.white)
                    .padding(.horizontal,  20)
                    .padding(8)
                    .padding(.leading,  20)
                    .background(SpeechBubble())
                    .frame(maxWidth: screenSize.width * 0.6, alignment: .leading)
            }
            .frame(maxWidth: screenSize.width, alignment: .leading)
            
            
            
        case .common:
            
            ZStack(alignment: .center) {
                Text(message)
                    .foregroundColor(Color.white)
                    .padding(.horizontal,  20)
                    .background(Color.gray)
                    .padding(8)
                    .clipShape(Capsule())
                
                    .frame(maxWidth: screenSize.width * 0.6, alignment: .center)
            }
            .frame(maxWidth: screenSize.width, alignment: .center)
            
            
        }
        
    }
    
}
enum FlipDirection {
    case vertical
    case horizontal
}
extension View {

    func flip(_ direction: FlipDirection) -> some View {
        let axis = direction == .horizontal ? (x: 0.0, y: 1.0, z: 0.0) : (x: 1.0, y: 0.0, z: 0.0)
        return rotation3DEffect(
            .degrees(180),
            axis: axis
        )
    }
}

#Preview {
    AKnock11()
}
