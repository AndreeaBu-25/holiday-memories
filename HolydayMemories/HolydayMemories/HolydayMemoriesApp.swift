//
//  HolydayMemoriesApp.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI
import SwiftData

@main
struct HolydayMemoriesApp: App
{
    var body: some Scene
    {
        WindowGroup
        {
            ContentView()
        }
        .modelContainer(for: [Country.self, Location.self])
    }
}
