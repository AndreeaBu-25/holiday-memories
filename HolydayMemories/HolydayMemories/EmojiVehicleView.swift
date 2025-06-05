//
//  EmojiVehicleView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI

struct EmojiVehicleView: View
{
    let vehicle: String
    
    var body: some View
    {
        switch vehicle
        {
        case "Airplane":
            Text("🛩️")
        case "Car":
            Text("🚘")
        case "Train":
            Text("🚆")
        case "Bus":
            Text("🚌")
        case "Bike":
            Text("🚲")
        case "Motorbike":
            Text("🏍️")
        case "Helicopter":
            Text("🚁")
        case "Boat":
            Text("🛥️")
        case "Ship":
            Text("🚢")
        default:
            Text("🚀")
        }
    }
}

#Preview {
    EmojiVehicleView(vehicle: "Car")
}
