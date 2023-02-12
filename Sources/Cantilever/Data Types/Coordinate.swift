//
//  Coordinate.swift
//
//  Created by Zack Brown on 27/10/2022.
//

import Foundation
import Euclid

public struct Coordinate: Codable, Equatable, Hashable, Identifiable {
    
    public let x: Int
    public let y: Int
    public let z: Int
    
    public var id: String { "[\(x), \(y), \(z)]" }
    
    public var equalToZero: Bool { x + y + z == 0 }
    
    public init(_ x: Int, _ y: Int, _ z: Int) {
        
        self.x = x
        self.y = y
        self.z = z
    }
}

public extension Coordinate {
    
    static let zero = Coordinate(0, 0, 0)
    static let one = Coordinate(1, 1, 1)
    static let unitX = Coordinate(1, 0, 0)
    static let unitY = Coordinate(0, 1, 0)
    static let unitZ = Coordinate(0, 0, 1)
    
    static func -(lhs: Coordinate, rhs: Coordinate) -> Coordinate { Coordinate(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z) }
    static func +(lhs: Coordinate, rhs: Coordinate) -> Coordinate { Coordinate(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z) }
}

public extension Coordinate {
    
    var tile: Coordinate { convert(to: .chunk).convert(to: .tile) }
    var chunk: Coordinate { convert(to: .tile).convert(to: .chunk) }
    
    func convert(to scale: Triangle.Scale) -> Vector {
        
        let dx = Double(x)
        let dy = Double(y)
        let dz = Double(z)
        
        return Vector((0.5 * dx + -0.5 * dz) * scale.rawValue,
                      0,
                      (-.sqrt3 / 6.0 * dx + .sqrt3 / 3 * dy - .sqrt3 / 6.0 * dz) * scale.rawValue)
    }
}
