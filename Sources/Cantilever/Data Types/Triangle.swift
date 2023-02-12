//
//  Triangle.swift
//
//  Created by Zack Brown on 27/10/2022.
//

import Euclid
import Foundation

public struct Triangle {
    
    public enum Scale: Double {
        
        case tile = 1.0
        case chunk = 7.0
    }
    
    public var corners: [Coordinate] { [corner(corner: .c0),
                                        corner(corner: .c1),
                                        corner(corner: .c2)] }
    
    public var handles: [Coordinate] { !isPointy ? corners : corners.map { $0 + .one } }
    
    public let coordinate: Coordinate
    
    public init(coordinate: Coordinate) {
     
        self.coordinate = coordinate
    }
}

public extension Triangle {
    
    func mesh(scale: Scale) -> Mesh {
        
        let material = (scale == .tile ? (isPointy ? Color(0.28, 0.28, 0.28) : Color(0.77, 0.77, 0.77)) :
                                         (isPointy ? Color.black : Color.gray))
        
        guard let polygon = Polygon(vertices(scale: scale), material: material) else { return Mesh([]) }
        
        return Mesh([polygon])
    }
    
    func vertices(scale: Scale) -> [Vector] { corners.map { $0.convert(to: scale) } }
}

public extension Triangle {
    
    var isPointy: Bool { coordinate.equalToZero }
    var delta: Int { isPointy ? -1 : 1 }
    
    var perimeter: [Coordinate] { diagonals + edges }
    
    var neighbours: [Coordinate] { corners.map { coordinate - $0 } }
    
    var diagonals: [Coordinate] {
        
        return [Coordinate(delta + coordinate.x, delta + coordinate.y, -delta + coordinate.z),
                Coordinate(delta + coordinate.x, -delta + coordinate.y, delta + coordinate.z),
                Coordinate(-delta + coordinate.x, delta + coordinate.y, delta + coordinate.z)].map { coordinate - $0 }
    }
    
    var edges: [Coordinate] {
        
        return [Coordinate(delta + coordinate.x, -delta + coordinate.y, coordinate.z),
                Coordinate(delta + coordinate.x, coordinate.y, coordinate.z),
                Coordinate(delta + coordinate.x, coordinate.y, -delta + coordinate.z),
                Coordinate(coordinate.x, delta + coordinate.y, -delta + coordinate.z),
                Coordinate(coordinate.x, delta + coordinate.y,  coordinate.z),
                Coordinate(-delta + coordinate.x, delta + coordinate.y, coordinate.z),
                Coordinate(-delta + coordinate.x, coordinate.y, delta + coordinate.z),
                Coordinate(coordinate.x, coordinate.y, delta + coordinate.z),
                Coordinate(coordinate.x, -delta + coordinate.y, delta + coordinate.z)].map { coordinate - $0 }
    }
}

extension Triangle {
    
    public enum Corner {
        
        case c0, c1, c2
    }
    
    func corner(corner: Corner) -> Coordinate {
        
        switch corner {
        case .c0: return Coordinate(delta + coordinate.x, coordinate.y, coordinate.z)
        case .c1: return Coordinate(coordinate.x, coordinate.y, delta + coordinate.z)
        case .c2: return Coordinate(coordinate.x, delta + coordinate.y, coordinate.z)
        }
    }
}

extension Triangle {
    
    //
    //  Profile defines a fixed set of points for the outer
    //  corners and edges of a triangle as well as three
    //  interior points of an inner triangle.
    //
    //
    //      0       3       5       8       1
    //
    //          4       6       9       12
    //
    //              7       10      13
    //
    //                  11      14
    //
    //                      2
    
    public struct Profile {
        
        public enum Point {
            
            case p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14
        }
        
        //  triangle corners
        let p0, p1, p2: Vector
        
        //  adjacent edge
        let p3, p5, p8: Vector
        
        //  opposite edge
        let p4, p7, p11: Vector
        
        //  hypotenuse edge
        let p12, p13, p14: Vector
        
        //  inner triangle corners
        let p6, p9, p10: Vector
        
        public var center: Vector { (p0 + p1 + p2) / 3 }
        
        public func vertex(for point: Point) -> Vector {
            
            switch point {
                
            case .p0: return p0
            case .p1: return p1
            case .p2: return p2
            case .p3: return p3
            case .p4: return p4
            case .p5: return p5
            case .p6: return p6
            case .p7: return p7
            case .p8: return p8
            case .p9: return p9
            case .p10: return p10
            case .p11: return p11
            case .p12: return p12
            case .p13: return p13
            case .p14: return p14
            }
        }
    }
    
    public func profile(for scale: Scale) -> Profile {
        
        let p0 = corner(corner: .c0).convert(to: scale)
        let p1 = corner(corner: .c1).convert(to: scale)
        let p2 = corner(corner: .c2).convert(to: scale)
        
        let p5 = p0.lerp(p1, 0.5)
        let p3 = p0.lerp(p5, 0.5)
        let p8 = p5.lerp(p1, 0.5)
        
        let p7 = p0.lerp(p2, 0.5)
        let p4 = p0.lerp(p7, 0.5)
        let p11 = p7.lerp(p2, 0.5)
        
        let p13 = p1.lerp(p2, 0.5)
        let p12 = p1.lerp(p13, 0.5)
        let p14 = p13.lerp(p2, 0.5)
        
        let p6 = p7.lerp(p5, 0.5)
        let p9 = p5.lerp(p13, 0.5)
        let p10 = p13.lerp(p7, 0.5)
        
        return Profile(p0: p0, p1: p1, p2: p2, p3: p3, p5: p5, p8: p8, p4: p4, p7: p7, p11: p11, p12: p12, p13: p13, p14: p14, p6: p6, p9: p9, p10: p10)
    }
}
