//
//  Location.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import Foundation
import SwiftData
import UIKit

@Model
class Country
{
    var name: String
    var colorHex: String
    
    init(name: String, color: UIColor)
    {
        self.name = name
        self.colorHex = color.toHexString()
    }
}

@Model
class Location
{
    var name: String
    var startDate: Date
    var endDate: Date
    var nrPers: Int
    var persons: String
    var rating: Int
    var vehicle: String
    var notes: String
    
    var imageData: [Data] = []
    
    //var country: Country
    var countryName: String
    
    init(name: String, startDate: Date, endDate: Date, nrPers: Int, persons: String, rating: Int, vehicle: String, notes: String, imageData: [Data], countryName: String /*country: Country*/)
    {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.nrPers = nrPers
        self.persons = persons
        self.rating = rating
        self.vehicle = vehicle
        self.notes = notes
        self.imageData = imageData
        //self.country = country
        self.countryName = countryName
    }
}
