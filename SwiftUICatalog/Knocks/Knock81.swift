//
//  Knock81.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/27.
//

import MapKit
import SwiftUI

enum Knock81 {
    struct ContentView: View {
        @State private var latitude: Double = 0
        @State private var longitude: Double = 0
        @State private var annotations: [MKAnnotation] = []
        @State private var action: MView.Action?
        @State private var showSheet: Bool = false
        func updatLocation(location: CLLocationCoordinate2D) {
            latitude = location.latitude
            longitude = location.longitude
        }

        var body: some View {
            NavigationView {
                ZStack(alignment: .topLeading) {
                    ZStack(alignment: .center) {
                        MView(latitude: $latitude, longitude: $longitude, action: $action, annotations: $annotations)
                        Rectangle().frame(width: 3, height: 50)
                        Rectangle().frame(width: 50, height: 3)
                    }
                    VStack(alignment: .leading) {
                        Text("latitutde 緯度: \(latitude)")
                        Text("longitude 経度: \(longitude)")
                    }
                    .padding(.leading, 16)
                }
                .sheet(isPresented: $showSheet, content: {
                    AnnotationsList(annotations: $annotations)
                })
                .toolbar(content: {
                    Button("add", action: {
                        let mv = MKPointAnnotation()
                        mv.coordinate = .init(latitude: latitude, longitude: longitude)
                        annotations.append(mv)
                    })

                    Button("list", action: {
                        showSheet = true
                    })
                })
            }
        }
    }

    struct AnnotationsList: View {
        // こんな感じで別Viewに切り出さないと何故か最新のannotaionが反映されない。
        @Binding var annotations: [MKAnnotation]
        var body: some View {
            List(annotations, id: \.hash) { annotation in

                VStack {
                    if let title = annotation.title, let title {
                        Text(title)
                    }
                    Text("latitutde: \(annotation.coordinate.latitude)").font(.caption)
                    Text("longitude: \(annotation.coordinate.longitude)").font(.caption)
                }
            }
        }
    }

    struct MView: UIViewRepresentable, Equatable {
        enum Action {
            case addingAnnotation(MKAnnotation)
        }

        @Binding var latitude: Double
        @Binding var longitude: Double
        @Binding var action: Action?
        @Binding var annotations: [MKAnnotation]

        init(latitude: Binding<Double>, longitude: Binding<Double>, action: Binding<Action?>, annotations: Binding<[MKAnnotation]>) {
            print("init")
            _latitude = latitude
            _longitude = longitude
            _action = action
            _annotations = annotations
        }

        func makeUIView(context: Context) -> MKMapView {
            print("makeUIView")
            let mv = MKMapView(frame: .init(origin: .zero, size: .zero))
            mv.delegate = context.coordinator
            return mv
        }

        func makeCoordinator() -> Delegate {
            // 一回しかよばれないところがよい
            Delegate(location: { location in
                latitude = location.latitude
                longitude = location.longitude
            })
        }

        func updateUIView(_ uiView: MKMapView, context _: Context) {
            //            if let action {
            //                switch action {
            //                case .addingAnnotation(let annotation):
            //                    uiView.addAnnotation(annotation)
            //                }
            //            }

            uiView.removeAnnotations(uiView.annotations)
            annotations.forEach(uiView.addAnnotation)
            action = nil
        }

        typealias UIViewType = MKMapView
        static func == (_: Self, _: Self) -> Bool {
            true
        }
    }

    class Delegate: NSObject, MKMapViewDelegate {
        var location: (CLLocationCoordinate2D) -> Void
        init(location: @escaping (CLLocationCoordinate2D) -> Void) {
            print("init delegate")
            self.location = location
        }

        @MainActor func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            location(mapView.region.center)
        }
    }
}

#Preview {
    Knock81.ContentView()
}
