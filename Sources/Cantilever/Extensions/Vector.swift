//
//  Vector.swift
//
//  Created by Zack Brown on 27/10/2022.
//

import Euclid
import Foundation

extension Vector: Identifiable {
    
    public var id: String { "[\(x), \(y), \(z)]" }
}

extension Vector {
    
    public func convert(to scale: Triangle.Scale) -> Coordinate {
        
        let xv = x + (0.5 * scale.rawValue)
        let yv = z + ((-.sqrt3 / 6.0) * scale.rawValue)
        let zv = x - (0.5 * scale.rawValue)
        
        let cx = Int(floor(( 1 * xv - .sqrt3 / 3.0 * yv) / scale.rawValue))
        let cy = Int(ceil((     .sqrt3 * 2.0 / 3.0 * yv) / scale.rawValue))
        let cz = Int(floor((-1 * zv - .sqrt3 / 3.0 * yv) / scale.rawValue))
        
        return Coordinate(cx, cy, cz)
    }
}

public extension Vector {
    
    static let up = Vector(0, 1, 0)
}
