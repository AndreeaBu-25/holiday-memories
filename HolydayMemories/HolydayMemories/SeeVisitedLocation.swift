//
//  SeeVisitedLocation.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI
import SwiftData

struct SeeVisitedLocation: View
{
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    let location: Location
    
    var formattedStartDate: String
    {
        location.startDate.formatted(date: .abbreviated, time: .omitted)
    }
    var formattedEndDate: String
    {
        location.endDate.formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View
    {
        ZStack
        {
            Color.bgColor.ignoresSafeArea()
            
            VStack(spacing: 20)
            {
                Section
                {
                    Text(location.name)
                        .font(.headline.bold())
                        .foregroundStyle(Color.darkPurple)
                    
                    Text("\(formattedStartDate) - \(formattedEndDate)")
                        .font(.body.bold().italic())
                        .foregroundStyle(Color.darkPurple)
                }
                Section
                {
                    ScrollView(.horizontal, showsIndicators: false)
                    {
                        HStack(spacing: 16)
                        {
                            ForEach(location.imageData.indices, id: \.self)
                            { index in
                                
                                if let uiImage = UIImage(data: location.imageData[index])
                                {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipped()
                                        .cornerRadius(12)
                                } else
                                {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .foregroundColor(.gray)
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                Section
                {
                    HStack
                    {
                        if location.nrPers == 1
                        {
                            (
                                Text("Party of two\n") +
                                Text("Company:\n").bold() +
                                Text(location.persons)
                            )
                            .font(.body)
                            .foregroundStyle(Color.darkPurple)
                            .padding()
                        } else if location.nrPers > 1
                        {
                            (
                                Text("Group of \(location.nrPers + 1)\n") +
                                Text("Company:\n").bold() +
                                Text(location.persons)
                            )
                            .font(.body)
                            .foregroundStyle(Color.darkPurple)
                            .padding()

                        } else
                        {
                            Text("You have been there alone")
                                .font(.body)
                                .foregroundStyle(Color.darkPurple)
                                .padding()
                        }
                        Spacer()
                    }
                }
                if location.notes.isEmpty == false
                {
                    Section
                    {
                        VStack
                        {
                            HStack
                            {
                                (
                                    Text("Here are some notes about the trip:\n").bold() +
                                    Text(location.notes)
                                )
                                .font(.body)
                                .foregroundStyle(Color.darkPurple)
                                .padding()
                                
                                Spacer()
                            }
                        }
                    }
                }
                Section
                {
                    RatingView(rating: .constant(location.rating))
                        .font(.title)
                }
                Spacer()
            }
        }
        .scrollBounceBehavior(.basedOnSize)
        .alert("Delete trip", isPresented: $showingDeleteAlert)
        {
            Button("Delete", role: .destructive, action: deleteLocation)
            Button("Cancel", role: .cancel) { }
        } message:
        {
            Text("Are you sure?")
        }
        .toolbar
        {
            Button("Delete this trip", systemImage: "trash")
            {
                showingDeleteAlert = true
            }
            .tint(Color.darkPurple)
        }
       
    }
    func deleteLocation()
    {
        modelContext.delete(location)
        
        do
        {
            try modelContext.save()
        } catch
        {
            print("Error (for delete save): \(error)")
        }
        
        dismiss()
    }
}
