//
//  RatingView.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 27.05.2025.
//

import SwiftUI

struct RatingView: View
{
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View
    {
        HStack
        {
            if label.isEmpty == false
            {
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self)
            { number in
                Button
                {
                    rating = number
                } label:
                {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
            }
        }
        .buttonStyle(.plain) //astfel, cand apesi pe oricare stea este tratata ca un buton separat, inainte oriunde apasai se colorau toate pt ca erau toate tratate ca un singur buton mare
        .accessibilityElement() //group everything together
        .accessibilityLabel(label) //apply label
        .accessibilityValue(rating == 1 ? "1 star" : "\(rating) stars") //read the value
        .accessibilityAdjustableAction
        { direction in
            
            switch direction
            {
            case .increment:
                if rating < maximumRating
                {
                    rating += 1
                }
            case .decrement:
                if rating > 1
                {
                    rating -= 1
                }
            default:
                break
            }
        }
    }
    
    func image(for number: Int) -> Image
    {
        if number > rating
        {
            offImage ?? onImage //use offImage but if there isn't one, use onImage 
        }
        else
        {
            onImage
        }
    }
}

#Preview
{
    RatingView(rating: .constant(4))
}
