//
//  Knock57.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/25.
//

import Combine
import SwiftUI
public enum Knock57 {
    public struct ContentView: View {
public init() {}
        @State var showResult: Bool = false
        @StateObject var vm: VM = .init()

        public var body: some View {
            VStack(spacing: 8) {
                TextField("Height", text: vm.bindingHeightString.projectedValue).keyboardType(.numberPad)
                TextField("Weigh", text: $vm.weighString).keyboardType(.numberPad)
                Button("calc", action: {
                    showResult.toggle()
                }).disabled(vm.canShowResult)

            }.sheet(isPresented: $showResult, content: {
                if let result = vm.result {
                    Text(String(result))
                }

            })
                .onAppear {
                    vm.setUp()
                }
        }
    }
}

#warning("donano")
class VM: ObservableObject {
    var heightString: CurrentValueSubject<String, Never> = .init("") // これも行ける

    lazy var bindingHeightString: Binding<String> = .init(get: { [weak self] in
        self?.heightString.value ?? ""
    }, set: { [weak self] in
        self?.heightString.send($0)
    })
    @Published var weighString: String = ""
    @Published var result: Int?
    var canShowResult: Bool { // これも行ける。
        result == nil
    }

    var cancellables: Set<AnyCancellable> = []
    func setUp() {
        heightString.combineLatest($weighString).sink { [weak self] h, m in
            print(h, m)
            if let h = Int(h), let m = Int(m) {
                self?.result = h / m
            } else {
                self?.result = nil
            }

        }.store(in: &cancellables)
    }
}

#Preview {
    Knock57.ContentView()
}
