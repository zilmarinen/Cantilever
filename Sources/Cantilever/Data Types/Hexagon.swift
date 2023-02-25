//
//  Hexagon.swift
//
//  Created by Zack Brown on 13/02/2023.
//

import Euclid
import Foundation

public struct Hexagon {
    
    public var corners: [Coordinate] { Corner.allCases.map { corner(corner: $0) } }
    
    public let coordinate: Coordinate
    
    public init(coordinate: Coordinate) {
     
        self.coordinate = coordinate
    }
}

public extension Hexagon {
    
    var triangles: [Coordinate] { [coordinate + .unitX + .unitZ,
                                   coordinate + .unitX,
                                   coordinate + .unitX + .unitY,
                                   coordinate + .unitY,
                                   coordinate + .unitY + .unitZ,
                                   coordinate + .unitZ] }
}

extension Hexagon {
    
    public enum Corner: CaseIterable {
        
        case c0, c1, c2, c3, c4, c5
    }
    
    func corner(corner: Corner) -> Coordinate {
        
        switch corner {
            
        case .c0: return coordinate - .unitY + .unitZ
        case .c1: return coordinate + .unitX - .unitY
        case .c2: return coordinate + .unitX - .unitZ
        case .c3: return coordinate + .unitY - .unitZ
        case .c4: return coordinate - .unitX + .unitY
        case .c5: return coordinate - .unitX + .unitZ
        }
    }
}
