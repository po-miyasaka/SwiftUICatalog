//
//  Knock50.swift
//  SwiftUICatalog
//
//  Created by po_miyasaka on 2023/09/23.
//

import MapKit
import SwiftUI
enum Knock50 {
    @available(iOS 17.0, *)
    struct ContentView: View {
        @AppStorage("lati") var latitude = 135.0
        @AppStorage("longi") var longitude = 135.0
        @State private var markerCoordinate: CLLocationCoordinate2D = .init(latitude: 135, longitude: 40)

        var body: some View {
            MapReader { proxy in
                Map(initialPosition: .region(.init(center: .init(latitude: latitude, longitude: longitude), latitudinalMeters: .leastNormalMagnitude, longitudinalMeters: .greatestFiniteMagnitude))) {
                    Marker("Marker", coordinate: markerCoordinate)
                    Marker("Marker2", coordinate: .init(latitude: markerCoordinate.latitude + 4, longitude: markerCoordinate.longitude + 4))
                }
                .onTapGesture { location in
                    if let coordinate = proxy.convert(location, from: .local) {
                        markerCoordinate = coordinate
                        latitude = markerCoordinate.latitude
                        longitude = markerCoordinate.longitude
                    }
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    Knock50.ContentView()
}
