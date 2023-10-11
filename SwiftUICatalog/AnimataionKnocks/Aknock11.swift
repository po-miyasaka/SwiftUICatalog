//
//  AKnock11.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/10/10.
//

import SwiftUI
import Algorithms
import PhotosUI

enum AKnock11 {
    
    
    struct ContentView: View {
        @State var editingText: String = ""
        @StateObject var viewModel: ChatViewModel = ChatViewModel()
        @State var shouldShowPHPView = false
        var body: some View {
            
            let screenSize = UIScreen.main.bounds.size
            VStack {
                
                
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(pinnedViews: .sectionFooters) {
                            
                            ForEach(viewModel.sectionData) { section in
                                Section(
                                    content:
                                        {
                                            ForEach(section.messages) { message in
                                                SpeechBubbleView(
                                                    message: message,
                                                    screenSize: screenSize
                                                )
                                                .id(message.id)
                                                .transition(.move(edge: .top))
                                            }
                                            
                                        } ,footer: {
                                            Text(section.date.toDateOnlyString())
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 4)
                                                .background(Color.black.opacity(0.1))
                                                .clipShape(Capsule()).flip(.vertical)
                                        }
                                )
                                
                            }
                            
                        }
                        .padding(.horizontal, 8)
                        
                    }.flip(.vertical)
                        .onChange(of: viewModel.sectionData, perform: { _ in
                            withAnimation {
                                proxy.scrollTo(viewModel.sectionData[0].messages[0].id)
                            }
                        })
                        
                }
                
                HStack {
                    
                    Button(action: {
                        shouldShowPHPView = true
                    }, label: {
                        Image(systemName: "photo").resizable().scaledToFit().frame(height: 25)
                    })
                    .sheet(isPresented: $shouldShowPHPView, content: {
                        PHPView(delegate: Delegate(handler: { url in
                            if let url {
                                Task { @MainActor in
                                    viewModel.addMessage(url: url)
                                }
                            }
                            self.shouldShowPHPView = false
                        }))

                    })
                    
                    TextField("", text: $editingText).textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        let newText = editingText
                        editingText = ""
                        Task {
                            withAnimation {
                                viewModel.addMessage(editingText: newText)
                            }
                        }
                    }, label: {
                        Image(systemName: "paperplane.fill").resizable().scaledToFit().frame(height: 25)
                    })
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
            }
            
//            .padding(.horizontal, 8) ScrollViewより上位にパディングをつけるとインジケーターの表示場所がいけてないことになる。
            .onAppear {
                Task {
                    await viewModel.load()
                }
            }
            
            
        }
            
        
    }
    
    struct SpeechBubbleView: View {
        let message: Message
        let screenSize: CGSize
        var body: some View {
            switch message.user.type {
            case .common:
                forCommon
            case .me:
                forMe
            case .opponent:
                forOpponent
            }
        }
        
        var forMe: some View {
            HStack(alignment: .top, spacing: 4) {
                #warning("verticalflipしてるけど、ここでのbottomTrailingしたときに判定せずbottomTrailingが適用されている。")
                Text(message.date.toTimeString()).foregroundColor(.gray).font(.caption).frame(maxHeight: .infinity, alignment: .bottomTrailing)
                switch message.type {
                case .text(let text):
                    Text(text).onBubble(position: .right, screenSize: screenSize)
                case .stamp(let image):
                    Image(uiImage: image.image ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .imageForMessage(position: .right, screenSize: screenSize)
                }
                
            }
            .flip(.vertical)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        var forOpponent: some View {
            HStack(alignment: .top, spacing: 4) {
                if !message.user.imageName.isEmpty {
                    Image(uiImage: UIImage(named: message.user.imageName)!).resizable().scaledToFill().frame(width: 33, height: 33).frame(maxWidth: 33).frame(alignment: .bottom).clipShape(Circle()).shadow(radius: 1)
                }
                switch message.type {
                case .text(let text):
                    Text(text).onBubble(position: .left, screenSize: screenSize)
                case .stamp(let image):
                    Image(uiImage: image.image ?? UIImage())
                        .resizable()
                        .scaledToFill()
                        .imageForMessage(position: .left, screenSize: screenSize)
                        
                }
                Text(message.date.toTimeString()).foregroundColor(.gray).font(.caption).frame( maxHeight: .infinity, alignment: .bottomLeading)
            }
            .flip(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var forCommon: some View {
            HStack(alignment: .top) {
                switch message.type {
                case .text(let text):
                    Text(text).foregroundColor(.gray).font(.caption)
                        .frame(maxWidth: .infinity, alignment: .center).padding()
                    
                case .stamp(let image):
                    Image(uiImage: image.image!).resizable().scaledToFill()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .flip(.vertical)
        }
        
    }
    
    
    
    struct SpeechBubble: Shape {
        static let cornerRadius: CGFloat = 20
        static let xOffset: CGFloat = 10
        func path(in rect: CGRect) -> Path {
            Path({ path in
                let radiusSize: CGFloat = Self.cornerRadius
                let rect = CGRect.init(origin: .init(x: Self.xOffset, y: 0), size: .init(width: rect.width - radiusSize, height: rect.height))
                path.addRoundedRect(in: rect, cornerSize: .init(width: radiusSize, height:  radiusSize))
                
                path.move(to: .init(x: 0, y: 0))
                path.addQuadCurve(to: .init(x: radiusSize * 2, y: 0), control: .init(x: radiusSize, y: radiusSize / 3))
                path.addLine(to: .init(x: radiusSize, y: radiusSize ) )
                path.addQuadCurve(to: .init(x: 5, y: 6), control: .init(x: radiusSize, y: radiusSize))
            })
        }
    }
    
    enum ImageType: Hashable {
        case string(String)
        case file(URL)
        case url(URL)
        
        var image: UIImage? {
            switch self {
            case .string(let name):
                return UIImage(named: name)!
            case .file(let url):
                return UIImage(contentsOfFile: url.path)!
            case .url:
                // TODO: handle here
                return nil
            }
        }
    }
    
    enum MessageType: Hashable {
        case text(String)
        case stamp(ImageType)
    }
    
    struct Message: Identifiable, Equatable {
        let id = UUID()
        let type: MessageType
        let date: Date
        let user: User
    }
    
    struct Group {
        let user: [User] = [
            .init(name: "kabi", imageName: "kabigon", type: .opponent),
            .init(name: "pikachu", imageName: "pikachu", type: .opponent)
        ]
        let me: User = .init(name: "satoshi", imageName: "short3", type: .me)
    }
    
    struct User: Identifiable, Hashable {
        enum `UserType` {
            case me
            case opponent
            case common
            
            var isMe: Bool {
                self == .me
            }
        }
        let id: UUID = .init()
        let name: String
        let imageName: String
        let type: UserType
        
        static let common: User = .init(name: "", imageName: "", type: .common)
    }
    
    /// This should be sorted in descending order by date.
    struct SectionData: Identifiable, Equatable {
        var id: String { date.toDateOnlyString() }
        let date: Date
        var messages: [Message]
    }
    
    @MainActor
    class ChatViewModel: ObservableObject {
        @Published var sectionData: [AKnock11.SectionData] = []
        var messages: [Message] = []
        let group: Group = Group()
        var current: Int = 0
        
        func load() async {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            
            var new = demoDataArray[current].chunked(by: { $0.date.toDateOnlyString() == $1.date.toDateOnlyString() })
            
            if new.first?.first?.date.toDateOnlyString().toDate == sectionData.last?.date {
                sectionData[sectionData.count - 1].messages += new.removeFirst()
            }
            sectionData += new.compactMap { newMessages in
                (newMessages.first?.date).map { d in
                    SectionData(date: d, messages: Array(newMessages))
                }
            }
            
        }
        
        func addMessage(editingText: String) {
            if sectionData.isEmpty {
                sectionData = [SectionData(date: Date(), messages: [
                    .init(type: .text(editingText), date: Date(), user: group.me)
                ])]
            } else {
                sectionData[0].messages.insert(.init(type: .text(editingText), date: Date(), user: group.me), at: 0)
            }
            
        }
        
        func addMessage(url: URL) {
            if sectionData.isEmpty {
                sectionData = [SectionData(date: Date(), messages: [
                    .init(type: .stamp(.file(url)), date: Date(), user: group.me)
                ])]
            } else {
                sectionData[0].messages.insert(.init(type: .stamp(.file(url)), date: Date(), user: group.me), at: 0)
            }
            
        }
        
        var demoDataArray: [[Message]] {
            [
                [
                    Message(type: .stamp(.string("short1")), date: "2023/10/10 23:00:01".toDate, user: group.user[1]),
                    Message(type: .text("hello"), date: "2023/10/10 22:00:01".toDate, user: group.user[1]),
                    Message.init(type: .text("DALL-E3 is not available yet."), date: "2023/10/10 10:00:01".toDate, user: group.user[0]),
                    Message.init(type: .text("wooooooooooooooooooooooooooooooooooooooooo"), date: "2023/10/10 10:00:00".toDate, user: group.user[0]),
                    Message.init(type: .text("New Comer!!!! pikachu"), date: "2023/10/10 09:00:01".toDate, user: User.common),
                    Message.init(type: .stamp(.string("kabigon2")), date: "2023/10/10 09:00:01".toDate, user: group.user[0]),
                    
                    Message.init(type: .text("nobody is here, so it's best time to drink tea."), date: "2023/10/10 08:38:01".toDate, user: group.user[0]),
                    Message.init(type: .stamp(.string("kabigon3")), date: "2023/10/10 07:00:01".toDate, user: group.user[1])
                ],
                [

                    Message.init(type: .text("hi"), date: "2023/10/10 6:00:01".toDate, user: group.user[1]),
                    Message.init(type: .text("nantoka nare"), date: "2023/09/10 10:00:01".toDate, user: group.user[0]),
                    Message.init(type: .text("nooo"), date: "2023/09/10 10:00:00".toDate, user: group.user[0]),
                    
                    Message.init(type: .text("thank you"), date: "2023/09/10 08:38:01".toDate, user: group.user[0]),
                    Message.init(type: .text("yes we can"), date: "2023/09/10 06:00:01".toDate, user: group.user[0]),
                    Message.init(type: .text("nooo"), date: "2023/09/10 05:00:30".toDate, user: group.user[0]),
                    
                    Message.init(type: .text("thank you"), date: "2023/09/10 04:38:01".toDate, user: group.user[0])
                ],
                [
                    Message.init(type: .stamp(.string("short5")), date: "2023/09/10 02:00:01".toDate, user: group.user[1]),
                    Message.init(type: .text("hi"), date: "2023/02/10 6:00:01".toDate, user: group.user[1]),
                    Message.init(type: .text("New Comer!!!! pikachu"), date: "2023/02/10 10:00:01".toDate, user: User.common),
                    Message.init(type: .text("nantoka nare"), date: "2023/02/10 10:00:01".toDate, user: group.user[0]),
                    Message.init(type: .text("nooo"), date: "2023/02/10 10:00:00".toDate, user: group.user[0]),
                    
                    Message.init(type: .text("thank you"), date: "2023/02/10 08:38:01".toDate, user: group.user[0]),
                    Message.init(type: .text("yes we can"), date: "2023/02/10 06:00:01".toDate, user: group.user[0]),
                    Message.init(type: .text("nooo"), date: "2023/01/10 05:00:30".toDate, user: group.user[0]),
                    
                    Message.init(type: .text("thank you"), date: "2023/01/10 04:38:01".toDate, user: group.user[0]),
                    Message.init(type: .text("New Comer!!!! satoshi"), date: "2023/01/09 10:00:01".toDate, user: User.common)
                ]
            ]
        }
    }
    
    enum FlipDirection {
        case vertical
        case horizontal
    }
    
    enum Position: Equatable {
        case right
        case left
    }
    
    
    struct PHPView: UIViewControllerRepresentable {
        
        var delegate: Delegate? // coodinator使うのがよい。
        func makeUIViewController(context _: Context) -> PHPickerViewController {
            var configuration = PHPickerConfiguration.init(photoLibrary: .shared())
            configuration.filter = .images
            let vc = PHPickerViewController(configuration: configuration)
            vc.delegate = delegate
            return vc
        }

        func updateUIViewController(_: PHPickerViewController, context _: Context) {}

        typealias UIViewControllerType = PHPickerViewController
    }

    class Delegate: PHPickerViewControllerDelegate {
        
        var handler: (URL?) -> Void
        init(handler: @escaping (URL?) -> Void) {
            self.handler = handler
        }

        func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] content, _ in
                
                guard let data = (content as? UIImage)?.pngData() else {
                    self?.handler(nil)
                    return
                }
                let dir = FileManager.default.temporaryDirectory
                let fileURL = dir.appendingPathComponent(UUID().uuidString + ".png")
                do {
                    try data.write(to: fileURL)
                    self?.handler(fileURL)
                } catch {
                    print("Error saving image: \(error)")
                    self?.handler(nil)
                }
                
                
            }
            )
        }
    }
}


extension View {
    
    func flip(_ direction: AKnock11.FlipDirection) -> some View {
        let axis: (x: CGFloat, y: CGFloat, z: CGFloat) = direction == .horizontal ? (x: 0.0, y: 1.0, z: 0.0) : (x: 1.0, y: 0.0, z: 0.0)
        return rotation3DEffect(
            .degrees(180),
            axis: axis
        )
    }
    
    
    
    func onBubble(position: AKnock11.Position, screenSize: CGSize) -> some View {
        let isRight = position == .right
        return ZStack(alignment: isRight ? .topTrailing : .topLeading) {
            
            
//            frame(maxWidth: screenSize.width * 0.5, alignment: .leading)
                foregroundColor(Color.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .padding(isRight ? .trailing : .leading,  AKnock11.SpeechBubble.xOffset - 8)
                .background(
                    Group {
                        if isRight { AKnock11.SpeechBubble().flip(.horizontal) } else { AKnock11.SpeechBubble()}
                    }
                )
        }
        .frame(alignment: isRight ? .trailing : .leading)
    }
    
    func imageForMessage(position: AKnock11.Position, screenSize: CGSize) -> some View {
        let isRight = position == .right
        return
            frame(width: screenSize.width * 0.6, alignment: isRight ? .trailing : .leading)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(isRight ? .trailing : .leading, AKnock11.SpeechBubble.xOffset)
    }
    
}


#Preview {
    AKnock11.ContentView()
}


