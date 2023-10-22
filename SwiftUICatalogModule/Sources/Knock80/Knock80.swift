//
//  Knock80.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import MapKit
import SwiftUI
public enum Knock80 {
    public struct ContentView: View {
public init() {}
        @State private var latitude: Double = 0
        @State private var longitude: Double = 0

        func updatLocation(location: CLLocationCoordinate2D) {
            latitude = location.latitude
            longitude = location.longitude
        }

        public var body: some View {
            ZStack(alignment: .topLeading) {
                GeometryReader { _ in
                    MView(latitude: $latitude, longitude: $longitude)
                    VStack(alignment: .leading) {
                        Text("latitutde 緯度: \(latitude)")
                        Text("longitude 経度: \(longitude)")
                    }
                    .padding(.top, 48)
                    .padding(.leading, 16)
                }
            }
            .ignoresSafeArea(.all, edges: .all)
        }
    }
}

#Preview {
    Knock80.ContentView()
}

// struct MView: UIViewRepresentable, Equatable  {
//    let size: CGSize
//    let delegate: Delegate
//    init(size: CGSize, delegate: Delegate) {
//        print("init")
//        self.size = size
//        self.delegate = delegate
//    }
//    func makeUIView(context: Context) -> MKMapView {
//        print("makeUIView")
//        let mv = MKMapView(frame: .init(origin: .zero, size: size))
//        mv.delegate = delegate
//        return mv
//    }
//
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        #warning("why is this needed")
////        uiView.delegate = delegate // Equatableを実装するかこれを実装するかしないと値がデリゲートが呼ばれなくなる。
//    }
//
//    typealias UIViewType = MKMapView
//    static func == (lhs: Self, rhs: Self) -> Bool {
//        true
//    }
// }

struct MView: UIViewRepresentable, Equatable {
//    let size: CGSize
    @Binding var latitude: Double
    @Binding var longitude: Double
    init(latitude: Binding<Double>, longitude: Binding<Double>) {
        print("init")
        _latitude = latitude
        _longitude = longitude
    }

    func makeUIView(context: Context) -> MKMapView {
        print("makeUIView")
        let mv = MKMapView(frame: .init(origin: .zero, size: .zero))
        mv.delegate = context.coordinator
        return mv
    }

    func makeCoordinator() -> Delegate {
        Delegate(location: { location in
            latitude = location.latitude
            longitude = location.longitude
        })
    }

    func updateUIView(_: MKMapView, context _: Context) {
        #warning("why is this needed")
        //        uiView.delegate = delegate // Equatableを実装するかこれを実装するかしないと値がデリゲートが呼ばれなくなる。
        // クロージャを受け取っている場合。こうなる。
    }

    typealias UIViewType = MKMapView
    static func == (_: Self, _: Self) -> Bool {
        true
    }
}

class Delegate: NSObject, MKMapViewDelegate, @unchecked Sendable {
    var location: (CLLocationCoordinate2D) -> Void
    init(location: @escaping (CLLocationCoordinate2D) -> Void) {
        print("init delegate")
        self.location = location
    }

    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        Task { @MainActor in
            
            location(mapView.region.center)
        }
        
    }
}

//
//
// public enum Knock80 {
//    public struct ContentView: View {
//public init() {}
//        @State private var latitude: Double = 0
//           @State private var longitude: Double = 0
//
//           public var body: some View {
//               ZStack(alignment: .topLeading) {
//                   LocationSelecterView() { location in
//                       latitude = location.latitude
//                       longitude = location.longitude
//                   }
//                   VStack(alignment: .leading) {
//                       Text("lat: \(latitude)")
//                       Text("long: \(longitude)")
//                   }
//                   .padding(.top, 48)
//                   .padding(.leading, 16)
//               }
//               .ignoresSafeArea(.all, edges: .all)
//           }
//    }
// }
//
// public struct LocationSelecterView: UIViewRepresentable {
//    let locationDidSet: (_ location: CLLocationCoordinate2D) -> Void
//
//
//    public func makeUIView(context: Context) -> UILocationSelecterView {
//        let locationsSelectView = UILocationSelecterView()
//        locationsSelectView.locationDidSet = locationDidSet
//        return locationsSelectView
//    }
//
//    public func updateUIView(_ uiView: UILocationSelecterView, context: Context) {}
// }
//
// public class UILocationSelecterView: UIView {
//
//
//    public var locationLimit: Int?
//    private lazy var mapView = MKMapView()
//
//    private let verticalLine = CAShapeLayer()
//    private let horizontalLine = CAShapeLayer()
//    var locationDidSet: ((_ location: CLLocationCoordinate2D) -> Void)?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        mapView.delegate = self
//        addSubview(mapView)
//
//        verticalLine.fillColor = nil
//        verticalLine.opacity = 1.0
//        verticalLine.strokeColor = UIColor.black.cgColor
//        layer.addSublayer(verticalLine)
//
//        horizontalLine.fillColor = nil
//        horizontalLine.opacity = 1.0
//        horizontalLine.strokeColor = UIColor.black.cgColor
//        layer.addSublayer(horizontalLine)
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//
//        mapView.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
//
//        let verticalLinePath = UIBezierPath()
//        verticalLinePath.move(to: CGPoint(x: (bounds.width / 2) - 50, y: bounds.height / 2))
//        verticalLinePath.addLine(to: CGPoint(x: (bounds.width / 2) + 50, y: bounds.height / 2))
//        verticalLine.path = verticalLinePath.cgPath
//
//        let horizontalLinePath = UIBezierPath()
//        horizontalLinePath.move(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) - 50))
//        horizontalLinePath.addLine(to: CGPoint(x: bounds.width / 2, y: (bounds.height / 2) + 50))
//        horizontalLine.path = horizontalLinePath.cgPath
//    }
// }
//
// extension UILocationSelecterView: MKMapViewDelegate {
//    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        let location = CLLocationCoordinate2D(latitude: mapView.region.center.latitude, longitude: mapView.region.center.longitude)
//        locationDidSet?(location)
//    }
// }
