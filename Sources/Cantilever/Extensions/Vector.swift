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
        
        let edgeLength = Double(scale.rawValue)
        let xv = x + (0.5 * edgeLength)
        let yv = z + ((-.sqrt3 / 6.0) * edgeLength)
        let zv = x - (0.5 * edgeLength)
        
        let cx = Int(floor(( 1 * xv - .sqrt3 / 3.0 * yv) / edgeLength))
        let cy = Int(ceil((     .sqrt3 * 2.0 / 3.0 * yv) / edgeLength))
        let cz = Int(floor((-1 * zv - .sqrt3 / 3.0 * yv) / edgeLength))
        
        return Coordinate(cx, cy, cz)
    }
}

public extension Vector {
    
    static let up = Vector(0, 1, 0)
}
