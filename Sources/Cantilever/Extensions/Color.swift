//
//  Color.swift
//
//  Created by Zack Brown on 16/02/2023.
//

import Foundation
import Euclid

extension Color {
    
    public init(hexString: String) {
        var cString = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue: UInt64 = 0
    
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  CGFloat(rgbValue & 0x0000FF) / 255.0,
                  CGFloat(1.0))
    }
}
