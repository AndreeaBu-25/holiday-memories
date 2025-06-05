//
//  ColorToHex.swift
//  HolydayMemories
//
//  Created by Andreea Bucsa on 30.05.2025.
//

import Foundation
import UIKit


extension UIColor
{
    func toHexString() -> String //convert UIColor in a hexadecimal string
    {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let rgb = (Int(red * 255) << 16) | (Int(green * 255) << 8) | Int(blue * 255)
        
        return String(format: "#%06x", rgb)
    }

    static func fromHex(_ hex: String) -> UIColor // creates a UIColor object from a hexadegimal string
    {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
