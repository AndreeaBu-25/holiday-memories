//
//  MapView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 30.05.2025.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable
{
    let countries: [ColoredCountry]
    let redrawID: UUID
    let onTapCountry: (ColoredCountry) -> Void

    func makeUIView(context: Context) -> MKMapView
    {
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.mapType = .mutedStandard
        mapView.pointOfInterestFilter = .excludingAll
        mapView.showsBuildings = false
        mapView.showsCompass = false
        mapView.showsScale = false
        mapView.showsTraffic = false
        mapView.showsUserLocation = false
        mapView.isPitchEnabled = false
        mapView.isRotateEnabled = false
        mapView.overrideUserInterfaceStyle = .light

        let center = CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        mapView.setRegion(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30)), animated: false)

        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        mapView.addGestureRecognizer(tapRecognizer)

        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context)
    {
        mapView.removeOverlays(mapView.overlays)
        
        for country in countries
        {
            mapView.addOverlay(country.polygon)
        }
    }

    func makeCoordinator() -> Coordinator
    {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate
    {
        let parent: MapView

        init(_ parent: MapView)
        {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
        {
            guard let polygon = overlay as? MKPolygon else
            {
                return MKOverlayRenderer(overlay: overlay)
            }

            let renderer = MKPolygonRenderer(polygon: polygon)
            
            if let country = parent.countries.first(where: { $0.polygon === polygon })
            {
                renderer.fillColor = country.color//.withAlphaComponent(0.8)
            } else
            {
                renderer.fillColor = UIColor.white//.withAlphaComponent(0.8)
            }
            
            renderer.strokeColor = .black
            renderer.lineWidth = 1
            
            return renderer
        }

        @objc func handleTap(_ gesture: UITapGestureRecognizer)
        {
            guard let mapView = gesture.view as? MKMapView else { return }
            
            let point = gesture.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)

            for country in parent.countries
            {
                let renderer = MKPolygonRenderer(polygon: country.polygon)
                renderer.createPath()
                
                let mapPoint = MKMapPoint(coordinate)
                let pointInRenderer = renderer.point(for: mapPoint)

                if renderer.path.contains(pointInRenderer)
                {
                    parent.onTapCountry(country)
                    break
                }
            }
        }
    }
}
