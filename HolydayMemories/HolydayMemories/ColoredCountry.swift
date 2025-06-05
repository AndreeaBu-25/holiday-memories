//
//  ColoredCountry.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 30.05.2025.
//

import Foundation
import MapKit

class ColoredCountry: NSObject, Identifiable
{
    let id = UUID()
    let polygon: MKPolygon
    let name: String
    var color: UIColor

    init(polygon: MKPolygon, name: String, color: UIColor = .white)
    {
        self.polygon = polygon
        self.name = name
        self.color = color
    }
}

