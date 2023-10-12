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
        @AppStorage("editingText") var editingText: String = ""
        @StateObject var viewModel: ChatViewModel = ChatViewModel()
        @State var shouldShowPHPView = false
        @Environment(\.screenSize) var screenSize
        @Environment(\.safeArea) var safeArea
        var body: some View {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        
                        LazyVStack(pinnedViews: .sectionFooters) {
                            
                            ForEach(viewModel.sectionDataArray, id: \.date) { section in
                                
                                Section(
                                    content:
                                        {
                                            ForEach(section.messages) { message in
                                                MessageCell(
                                                    message: message,
                                                    screenSize: screenSize
                                                )
                                                .id(message.id)
                                                .transition(.move(edge: .top))
                                            }
                                            
                                        },
                                    footer: {
                                        Text(section.date.toDateOnlyString())
                                            .foregroundColor(Color.gray)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 4)
                                            .background(Color.black.opacity(0.1))
                                            .clipShape(Capsule()).flip(.vertical)
                                            .padding(.bottom, 32)
                                    }
                                )
                                
                            }
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                ProgressView().hidden()
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        GeometryReader { proxy in
                            // flipの影響を受けて反転する。
                            let _ = print(proxy.frame(in: .global).minY - safeArea().top)
                            Color.clear.preference(key: ScrollOffsetKey.self, value: proxy.frame(in: .global).minY - safeArea().top)
                            
                            
                        }.frame(height: 0)
                        
                    }
                    .flip(.vertical)
                    .onChange(of: viewModel.shouldScrollToLatestOne, perform: { _ in
                        withAnimation {
                            proxy.scrollTo(viewModel.sectionDataArray[0].messages[0].id)
                        }
                    })
                    .onPreferenceChange(ScrollOffsetKey.self, perform: { value in
                        if value > 0 {
                            Task {
                                await viewModel.load()
                            }
                        }
                        
                    })
                    
                }
                
                HStack(spacing: 8) {
                    
                    Button(action: {
                        shouldShowPHPView = true
                    }, label: {
                        Image(systemName: "photo").resizable().scaledToFit().frame(height: 25)
                    })
                    .sheet(isPresented: $shouldShowPHPView, content: {
                        PHPView(handler: { url in
                            if let url {
                                Task { @MainActor in
                                    viewModel.addMessage(url: url)
                                }
                            }
                            self.shouldShowPHPView = false
                        })
                        
                    })
                    
                    TextField("message", text: $editingText).textFieldStyle(RoundedBorderTextFieldStyle())
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
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
            }
            .background(Color.chatBackground.ignoresSafeArea())
            
            //            .padding(.horizontal, 8) ScrollViewより上位にパディングをつけるとインジケーターの表示場所がいけてないことになる。
            //            .onAppear {
            //                Task {
            //                    await viewModel.load()
            //                }
            //            }
            //
            
        }
        
        
    }
    
    struct MessageCell: View {
        let message: Message
        let screenSize: CGSize
        var isRight: Bool { message.user.type.isMe }
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
            HStack(alignment: .top, spacing: 8) {
#warning("verticalflipしてるけど、ここでのbottomTrailingしたときに反転せずbottomTrailingが適用されている。")
                timeStamp
                messageContent
            }
            .flip(.vertical)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        
        var forOpponent: some View {
            HStack(alignment: .top, spacing: 8) {
                userImage
                VStack(alignment: .leading) {
                    userName
                    messageContent
                }
                timeStamp
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
        @ViewBuilder
        var messageContent: some View {
            switch message.type {
            case .text(let text):
                Text(text).onBubble(isRight, screenSize: screenSize).layoutPriority(1)
            case .stamp(let image):
                Image(uiImage: image.image ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .imageForMessage(isRight, screenSize: screenSize)
                
            }
        }
        
        @ViewBuilder
        var userImage: some View {
            if let image = UIImage(named: message.user.imageName)  {
                SwiftUI.Group {
                    Image(uiImage: image).resizable().scaledToFill().frame(width: 33, height: 33).frame(maxWidth: 33).frame(alignment: .bottom).clipShape(Circle()).shadow(radius: 1)
                }
            }
            
        }
        
        var userName: some View {
            Text(message.user.name).foregroundColor(.gray).font(.caption2).bold().frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
        
        @ViewBuilder
        var timeStamp: some View {
            Text(message.date.toTimeString()).foregroundColor(.gray).font(.caption).frame(minWidth: screenSize.width * 0.2, maxHeight: .infinity, alignment: isRight ? .bottomTrailing : .bottomLeading).offset(x: isRight ? 16 : -16)
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
        @Published var sectionDataArray: [AKnock11.SectionData] = []
        @Published var isLoading: Bool = false
        @Published var shouldScrollToLatestOne: Int = 0
        var messages: [Message] = []
        let group: Group = Group()
        var current: Int = 0
        
        func load() async {
            
            // TODO: actorに逃がす。
            if isLoading {
                return
            }
            isLoading = true
            
            
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            if demoDataArray.count <= current {
                isLoading = false
                return
            }
            var new = demoDataArray[current].chunked(by: { $0.date.toDateOnlyString() == $1.date.toDateOnlyString() })
            if new.first?.first?.date.toDateOnlyString() == sectionDataArray.last?.date.toDateOnlyString() {
                // 同じ日付であればマージ
                sectionDataArray[sectionDataArray.count - 1].messages += new.removeFirst()
            }
            
            sectionDataArray += new.compactMap { newMessages in
                (newMessages.first?.date).map { d in
                    SectionData(date: d, messages: Array(newMessages))
                }
            }
            sectionDataArray.forEach { print($0.date) }
            current += 1
            isLoading = false
        }
        
        func addMessage(editingText: String) {
            if sectionDataArray.isEmpty {
                sectionDataArray = [SectionData(date: Date(), messages: [
                    .init(type: .text(editingText), date: Date(), user: group.me)
                ])]
            } else {
                sectionDataArray[0].messages.insert(.init(type: .text(editingText), date: Date(), user: group.me), at: 0)
            }
            shouldScrollToLatestOne += 1
            
        }
        
        func addMessage(url: URL) {
            if sectionDataArray.isEmpty {
                sectionDataArray = [SectionData(date: Date(), messages: [
                    .init(type: .stamp(.file(url)), date: Date(), user: group.me)
                ])]
            } else {
                sectionDataArray[0].messages.insert(.init(type: .stamp(.file(url)), date: Date(), user: group.me), at: 0)
            }
            shouldScrollToLatestOne += 1
        }
        
        var demoDataArray: [[Message]] {
            [
                [
                    .init(type: .stamp(.string("short1")), date: "2023/10/10 23:00:01".toDate, user: group.user[1]),
                    .init(type: .text("hello"), date: "2023/10/10 22:00:01".toDate, user: group.user[1]),
                    .init(type: .text("DALL-E3 is not available yet."), date: "2023/10/10 10:00:01".toDate, user: group.user[0]),
                    .init(type: .text("wooooooooooooooooooooooooooooooooooooooooo"), date: "2023/10/10 10:00:00".toDate, user: group.user[0]),
                    .init(type: .text("New Comer!!!! pikachu"), date: "2023/10/10 09:00:01".toDate, user: User.common),
                    .init(type: .stamp(.string("kabigon2")), date: "2023/10/10 09:00:01".toDate, user: group.user[0]),
                    .init(type: .text("hello"), date: "2023/10/10 08:45:01".toDate, user: group.me),
                    .init(type: .text("It has to be one of my favorite songs, I just can't stop listening to it since the french release of the movie. It's just too good. Thank you King Gnu"), date: "2023/10/10 08:42:01".toDate, user: group.me),
                    .init(type: .text("nobody is here, so it's best time to drink tea."), date: "2023/10/10 08:38:01".toDate, user: group.user[0]),
                    .init(type: .stamp(.string("kabigon3")), date: "2023/10/10 07:00:01".toDate, user: group.user[1])
                ],
                [
                    
                    .init(type: .text("hi"), date: "2023/10/10 6:00:01".toDate, user: group.user[1]),
                    .init(type: .text("nantoka nare"), date: "2023/09/10 10:00:01".toDate, user: group.user[0]),
                    .init(type: .text("nooo"), date: "2023/09/10 10:00:00".toDate, user: group.user[0]),
                    
                        .init(type: .text("thank you"), date: "2023/09/10 08:38:01".toDate, user: group.user[0]),
                    .init(type: .text("yes we can"), date: "2023/09/10 06:00:01".toDate, user: group.user[0]),
                    .init(type: .text("nooo"), date: "2023/09/10 05:00:30".toDate, user: group.user[0]),
                    
                        .init(type: .text("thank you"), date: "2023/09/10 04:38:01".toDate, user: group.user[0])
                ],
                [
                    .init(type: .stamp(.string("short5")), date: "2023/09/10 02:00:01".toDate, user: group.user[1]),
                    .init(type: .text("hi"), date: "2023/02/10 6:00:01".toDate, user: group.user[1]),
                    .init(type: .text("nantoka nare"), date: "2023/02/10 10:00:01".toDate, user: group.user[0]),
                    .init(type: .text("nooo"), date: "2023/02/10 10:00:00".toDate, user: group.user[0]),
                    
                        .init(type: .text("thank you"), date: "2023/02/10 08:38:01".toDate, user: group.user[0]),
                    .init(type: .text("yes we can"), date: "2023/02/10 06:00:01".toDate, user: group.user[0]),
                    .init(type: .text("nooo"), date: "2023/01/10 05:00:30".toDate, user: group.user[0]),
                    
                        .init(type: .text("thank you"), date: "2023/01/10 04:38:01".toDate, user: group.user[0]),
                    .init(type: .text("New Comer!!!! satoshi"), date: "2023/01/09 10:00:01".toDate, user: User.common)
                ]
            ]
        }
    }
    
    enum FlipDirection {
        case vertical
        case horizontal
    }
    
    struct ScrollOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    struct PHPView: UIViewControllerRepresentable {
        
        
        var handler:  (URL?) -> Void
        //        var delegate: Delegate? // coodinator使うのがよい。
        func makeUIViewController(context : Context) -> PHPickerViewController {
            var configuration = PHPickerConfiguration.init(photoLibrary: .shared())
            configuration.filter = .images
            let vc = PHPickerViewController(configuration: configuration)
            vc.delegate = context.coordinator
            return vc
        }
        
        func updateUIViewController(_: PHPickerViewController, context _: Context) {}
        
        typealias UIViewControllerType = PHPickerViewController
        
        func makeCoordinator() -> Coordinator {
            Coordinator(handler: handler)
        }
        
        @MainActor
        class Coordinator: NSObject, PHPickerViewControllerDelegate {
            
            var handler:  (URL?) -> Void
            init(handler: @escaping (URL?) -> Void) {
                self.handler = handler
            }
            
            func picker(_: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
                guard let result = results.first else  {
                    handler(nil)
                    return
                }
                
                result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { [weak self] content, _ in
                    
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
    
}



extension View {
    
    func flip(_ direction: AKnock11.FlipDirection) -> some View {
        let axis: (x: CGFloat, y: CGFloat, z: CGFloat) = direction == .horizontal ? (x: 0.0, y: 1.0, z: 0.0) : (x: 1.0, y: 0.0, z: 0.0)
        return rotation3DEffect(
            .degrees(180),
            axis: axis
        )
    }
    
    
    
    func onBubble(_ isRight: Bool, screenSize: CGSize) -> some View {
        ZStack(alignment: isRight ? .topTrailing : .topLeading) {
            foregroundColor(Color.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 24)
                .background(
                    Group {
                        if isRight { AKnock11.SpeechBubble().fill(Color.white).flip(.horizontal) } else { AKnock11.SpeechBubble().fill(Color.white)}
                    }
                )
        }
        .frame(alignment: isRight ? .trailing : .leading)
    }
    
    func imageForMessage(_ isRight: Bool, screenSize: CGSize) -> some View {
        frame(width: screenSize.width * 0.5, alignment: isRight ? .trailing : .leading)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(isRight ? .trailing : .leading, AKnock11.SpeechBubble.xOffset)
            .padding(isRight ? .leading: .trailing, 8)
    }
    
}


#Preview {
    AKnock11.ContentView()
}


