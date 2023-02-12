//
//  ColorPalette.swift
//
//  Created by Zack Brown on 05/02/2023.
//

import Euclid
import Foundation

public struct ColorPalette {
    
    public let primary: Color
    public let secondary: Color
    public let tertiary: Color
    public let quaternary: Color
    
    public init(primary: Color, secondary: Color, tertiary: Color, quaternary: Color) {
        
        self.primary = primary
        self.secondary = secondary
        self.tertiary = tertiary
        self.quaternary = quaternary
    }
}
