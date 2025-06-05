//
//  ContentView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI
import MapKit
import SwiftData

struct ContentView: View
{
    @Environment(\.modelContext) var modelContext
    @Query var savedColors: [Country]
    
    @State private var countries: [ColoredCountry] = []
    @State private var selectedCountry: ColoredCountry?
    
    @State private var redrawTrigger = UUID()
    
    init()
    {
        if let url = Bundle.main.url(forResource: "all", withExtension: "json")
        {
            do
            {
                let data = try Data(contentsOf: url)
                let decoded = try JSONDecoder().decode(FeatureCollection.self, from: data)
                self._countries = State(initialValue: ContentView.createCountries(from: decoded.features))
            } catch
            {
                print("Decoding error: \(error)")
            }
        } else
        {
            print("The file was not found in bundle.")
        }
    }
    
    var body: some View
    {
        ZStack
        {
            Color.white.ignoresSafeArea()
            
            MapView(countries: countries, redrawID: redrawTrigger)
            { tappedCountry in
                
                selectedCountry = tappedCountry
            }
            .edgesIgnoringSafeArea(.all)
            
            if countries.isEmpty
            {
                Text("Map cannot be loaded loaded")
                    .font(.title)
                    .foregroundStyle(.red)
                    .padding()
            }
        }
        .sheet(item: $selectedCountry)
        { selected in
            
            CountryView(countryName: selected.name)
            { newColor in
                
                if let index = countries.firstIndex(where: { $0.name == selected.name })
                {
                    countries[index].color = newColor
                    redrawTrigger = UUID()
                    countries = countries.map { $0 }

                    let duplicates = savedColors.filter { $0.name == selected.name }
                    for entry in duplicates
                    {
                        modelContext.delete(entry)
                    }

                    let colorModel = Country(name: selected.name, color: newColor)
                    modelContext.insert(colorModel)
                }
            }
        }

        .onAppear
        {
            for index in countries.indices
            {
                let name = countries[index].name
                if let saved = savedColors.first(where: { $0.name == name })
                {
                    countries[index].color = UIColor.fromHex(saved.colorHex)
                }
            }
            countries = countries.map { $0 } // redraw the map
            
            print("\(savedColors.count)")
        }

    }
    
    static func createCountries(from features: [Feature]) -> [ColoredCountry]
    {
        var result: [ColoredCountry] = []

        for feature in features
        {
            let name = feature.properties.name
            
            switch feature.geometry
            {
            case .polygon(let polygon):
                if let mkPolygon = createMKPolygon(from: polygon.coordinates)
                {
                    mkPolygon.title = name
                    result.append(ColoredCountry(polygon: mkPolygon, name: name))
                }
            case .multiPolygon(let multiPolygon):
                for coords in multiPolygon.coordinates
                {
                    if let mkPolygon = createMKPolygon(from: coords)
                    {
                        mkPolygon.title = name
                        result.append(ColoredCountry(polygon: mkPolygon, name: name))
                    }
                }
            }
        }

        return result
    }

    private static func createMKPolygon(from rings: [[[Double]]]) -> MKPolygon?
    {
        guard let exteriorRing = rings.first else { return nil }

        let exteriorCoords = exteriorRing.map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }

        var interiorPolygons: [MKPolygon] = []

        if rings.count > 1
        {
            for i in 1..<rings.count
            {
                let holeCoords = rings[i].map { CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0]) }
                
                let holePolygon = MKPolygon(coordinates: holeCoords, count: holeCoords.count)
                interiorPolygons.append(holePolygon)
            }
        }

        return MKPolygon(coordinates: exteriorCoords, count: exteriorCoords.count, interiorPolygons: interiorPolygons)
    }
}


/*#Preview {
    ContentView()
}*/
