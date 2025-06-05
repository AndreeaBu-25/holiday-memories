//
//  GeoFeature.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 30.05.2025.
//

import Foundation

struct FeatureCollection: Codable
{
    let features: [Feature]
}

struct FeatureProperties: Codable
{
    let name: String
}

struct PolygonGeometry: Codable
{
    let type: String
    let coordinates: [[[Double]]]
}

struct MultiPolygonGeometry: Codable
{
    let type: String
    let coordinates: [[[[Double]]]]
}

enum Geometry: Codable
{
    case polygon(PolygonGeometry)
    case multiPolygon(MultiPolygonGeometry)

    enum CodingKeys: String, CodingKey
    {
        case type, coordinates
    }

    enum GeometryType: String, Codable
    {
        case Polygon
        case MultiPolygon
    }

    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(GeometryType.self, forKey: .type)
        
        switch type
        {
        case .Polygon:
            let coords = try container.decode([[[Double]]].self, forKey: .coordinates)
            self = .polygon(PolygonGeometry(type: type.rawValue, coordinates: coords))
            
        case .MultiPolygon:
            let coords = try container.decode([[[[Double]]]].self, forKey: .coordinates)
            self = .multiPolygon(MultiPolygonGeometry(type: type.rawValue, coordinates: coords))
        }
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self
        {
        case .polygon(let polygon):
            try container.encode(polygon.type, forKey: .type)
            try container.encode(polygon.coordinates, forKey: .coordinates)
            
        case .multiPolygon(let multiPolygon):
            try container.encode(multiPolygon.type, forKey: .type)
            try container.encode(multiPolygon.coordinates, forKey: .coordinates)
        }
    }
}

struct Feature: Codable
{
    let properties: FeatureProperties
    let geometry: Geometry
}
