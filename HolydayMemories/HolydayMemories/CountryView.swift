//
//  CountryView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI
import SwiftData

struct CountryView: View
{
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var showingAddScreen = false
    
    let countryName: String
    let onColorPicked: (UIColor) -> Void
    @State private var selectedColor: Color = .white
    
    @State private var locations: [Location] = []

    @State private var refreshID = UUID()

    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                Color.bgColor.ignoresSafeArea()
                
                VStack
                {
                    List
                    {
                        if locations.count == 0
                        {
                            Text("You haven't been to \(countryName) yet.")
                                .font(.body)
                                .foregroundStyle(Color.darkPurple)
                        } else if locations.count == 1
                        {
                            Text("You have been to \(countryName) one time.")
                                .font(.body)
                                .foregroundStyle(Color.darkPurple)
                        } else
                        {
                            Text("You have been to \(countryName) \(locations.count) times")
                                .font(.body)
                                .foregroundStyle(Color.darkPurple)
                        }
                        
                        ForEach(locations)
                        { location in
                            
                            NavigationLink(destination: SeeVisitedLocation(location: location))
                            {
                                HStack
                                {
                                    EmojiVehicleView(vehicle: location.vehicle)
                                        .font(.largeTitle)
                                    VStack(alignment: .leading)
                                    {
                                        Text(location.name)
                                            .font(.headline)
                                        Text("\(location.startDate.formatted(date: .abbreviated, time: .omitted)) - \(location.endDate.formatted(date: .abbreviated, time: .omitted))")
                                            .font(.body.italic())
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteTrip)
                        .listRowBackground(Color.sectionColor)
                        
                    }
                    .id(refreshID)
                    
                    ColorPicker("Choose a new color for \(countryName) on the map", selection: $selectedColor, supportsOpacity: true)
                        .padding()
                        .foregroundStyle(Color.darkPurple)
                        .disabled(locations.isEmpty)
                    HStack
                    {
                        Spacer()
                        Button("Apply", systemImage: "lasso.badge.sparkles")
                        {
                            let uiColor = UIColor(selectedColor)
                            onColorPicked(uiColor)
                            dismiss()
                        }
                        .padding(7)
                        .font(.body)
                        .foregroundStyle(.white)
                        .background(Color.darkPurple)
                        .clipShape(.capsule)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .disabled(locations.isEmpty)
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Button()
                    {
                        dismiss()
                    }label:
                    {
                        Image(systemName: "x.circle")
                            .padding()
                            .font(.body)
                            .foregroundStyle(.white)
                            .background(Color.darkPurple)
                            .clipShape(.capsule)
                    }
                    Spacer()
                }
                .navigationTitle(countryName)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar
                {
                    ToolbarItem(placement: .topBarLeading)
                    {
                        EditButton()
                            .foregroundStyle(Color.darkPurple)
                    }
                    ToolbarItem(placement: .topBarTrailing)
                    {
                        Button
                        {
                            showingAddScreen.toggle()
                        } label:
                        {
                            Label("Add location", systemImage: "plus")
                        }
                        .tint(Color.darkPurple)
                        
                    }
                }
                .sheet(isPresented: $showingAddScreen)
                {
                    AddLocationView(countryName: countryName)
                    {
                        refreshID = UUID()
                        fetchLocations()
                    }
                    .environment(\.modelContext, modelContext)
                }
                
            }
            .onAppear
            {
                fetchLocations()
            }
            .scrollContentBackground(.hidden)
        }
    }
    func deleteTrip(at offsets: IndexSet)
    {
        for offset in offsets
        {
            let loc = locations[offset]
            modelContext.delete(loc)
        }

        do
        {
            try modelContext.save()
            fetchLocations()

            if locations.isEmpty
            {
                selectedColor = .white
                let uiColor = UIColor(selectedColor)
                onColorPicked(uiColor)
            }
        } catch
        {
            print("Error (for delete save): \(error)")
        }

    }
    
    func fetchLocations()
    {
        do
        {
            let descriptor = FetchDescriptor<Location>(
                predicate: #Predicate { $0.countryName == countryName },
                sortBy: [SortDescriptor(\.startDate)]
            )
            locations = try modelContext.fetch(descriptor)
            print("Loaded \(locations.count) for \(countryName)")
        } catch
        {
            print("Failed to fetch: \(error)")
        }
    }

}

/*#Preview {
    CountryView()
}*/
