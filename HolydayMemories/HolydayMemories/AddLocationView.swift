//
//  AddLocationView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI
import SwiftData
import PhotosUI

extension Color
{
   // static let bgColor = Color(red: 0.4, green: 0.3, blue: 0.4)
   // static let sectionColor = Color(red: 0.3, green: 0.2, blue: 0.3)
    
    static let bgColor = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let sectionColor = Color(red: 1.0, green: 1.0, blue: 1.0)
    
    static let darkPurple = Color(red: 0.4, green: 0.3, blue: 0.4)
}

struct AddLocationView: View
{
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var nrPeople = 0
    @State private var persons = ""
    @State private var rating = 3
    @State private var vehicle = "Car"
    @State private var notes = ""
    
    let vehicles = ["Airplane", "Car", "Train", "Bus", "Bike", "Motorbike", "Helicopter", "Boat", "Ship"]
    
    @State private var photoPicker = [PhotosPickerItem]()
    @State private var selectedImages = [Data]()
    
    //let country: Country
    let countryName: String
    var onSave: (() -> Void)? = nil
    
    var body: some View
    {
        NavigationStack
        {
            ZStack
            {
                Color.bgColor.ignoresSafeArea()
                List
                {
                    Section
                    {
                        TextField("Location(s)", text: $name)
                            .font(.title)
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    Section
                    {
                        DatePicker("Start Date:", selection: $startDate, displayedComponents: [.date])
                        DatePicker("End Date: ", selection: $endDate, displayedComponents: [.date])
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    Section
                    {
                        Picker("Travelled by", selection: $vehicle)
                        {
                            ForEach(vehicles, id: \.self)
                            {
                                Text($0)
                            }
                        }
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    Section
                    {
                        Stepper("Number of companions: \(nrPeople)", value: $nrPeople, in: 0...30)
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    Section("Who was there with you?")
                    {
                        TextEditor(text: $persons)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.darkPurple)
                    
                    Section("Would you like to add some notes about the trip?")
                    {
                        TextEditor(text: $notes)
                            .foregroundStyle(.white)
                    }
                    .listRowBackground(Color.darkPurple)
                    
                    Section("How much did you like this trip?")
                    {
                        RatingView(rating: $rating)
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    Section("Add some photos from your trip!")
                    {
                        VStack(spacing: 10)
                        {
                            HStack
                            {
                                Spacer()
                                
                                PhotosPicker(
                                    selection: $photoPicker,
                                    maxSelectionCount: 15,
                                    matching: .images
                                )
                                {
                                    VStack
                                    {
                                        Image(systemName: "photo.badge.plus")
                                            .font(.system(size: 30))
                                            .foregroundColor(.gray)
                                        Text("Add photos")
                                            .foregroundStyle(.gray)
                                    }
                                }
                                Spacer()
                            }
                            ScrollView
                            {
                                ForEach(selectedImages, id: \.self)
                                { data in
                                    if let uiImage = UIImage(data: data)
                                    {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                        .onChange(of: photoPicker)
                        {
                            Task
                            {
                                selectedImages.removeAll()
                                for item in photoPicker
                                {
                                    if let loadedImage = try? await item.loadTransferable(type: Data.self)
                                    {
                                        selectedImages.append(loadedImage)
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.sectionColor)
                    
                    HStack
                    {
                        Spacer()
                        Button("Save")
                        {
                            let newCity = Location(name: name, startDate: startDate, endDate: endDate, nrPers: nrPeople, persons: persons, rating: rating, vehicle: vehicle, notes: notes, imageData: selectedImages, countryName: countryName)
                            
                            modelContext.insert(newCity)
                            do
                            {
                                try modelContext.save()
                                onSave?()
                                print("Ok")
                                dismiss()
                            } catch
                            {
                                print("Error: \(error)")
                            }
                        }
                        .font(.body)
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.darkPurple)
                        .clipShape(.capsule)
                        
                        Spacer()
                    }
                }
                .navigationTitle("Add Trip in \(countryName)")
                .navigationBarTitleDisplayMode(.inline)
            }
            .scrollContentBackground(.hidden)
        }
    }
}

/*#Preview {
    AddLocationView()
}*/
