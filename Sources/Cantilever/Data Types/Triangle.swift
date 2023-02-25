//
//  Triangle.swift
//
//  Created by Zack Brown on 27/10/2022.
//

import Euclid
import Foundation

public struct Triangle {
    
    public enum Scale: Int {
        
        case tile = 1
        case chunk = 7
        case region = 28
    }
    
    public var isPointy: Bool { coordinate.equalToZero }
    
    private var delta: Int { isPointy ? -1 : 1 }
    
    public let coordinate: Coordinate
    
    public init(coordinate: Coordinate) {
     
        self.coordinate = coordinate
    }
}

public extension Triangle {
    
    //TODO: REMOVE THIS
    func mesh(scale: Scale) -> Mesh {
        
        let material = {
            
            switch scale {
                
            case .tile: return isPointy ? Color(hexString: "#FFE7CC") : Color(hexString: "#F8CBA6")
            case .chunk: return isPointy ? Color(hexString: "#93BFCF") : Color(hexString: "#BDCDD6")
            case .region: return isPointy ? Color(hexString: "#E1EEDD") : Color(hexString: "#FEFBE9")
            }
        }()
        
        guard let polygon = Polygon(vertices(for: scale), material: material) else { return Mesh([]) }
        
        return Mesh([polygon])
    }
}

public extension Triangle {
    
    var perimeter: [Coordinate] { diagonals + edges }
    
    var neighbours: [Coordinate] { corners }
    
    var diagonals: [Coordinate] { [Coordinate(delta + coordinate.x, delta + coordinate.y, -delta + coordinate.z),
                                   Coordinate(delta + coordinate.x, -delta + coordinate.y, delta + coordinate.z),
                                   Coordinate(-delta + coordinate.x, delta + coordinate.y, delta + coordinate.z)] }
    
    var edges: [Coordinate] { [Coordinate(delta + coordinate.x, -delta + coordinate.y, coordinate.z),
                               Coordinate(delta + coordinate.x, coordinate.y, coordinate.z),
                               Coordinate(delta + coordinate.x, coordinate.y, -delta + coordinate.z),
                               Coordinate(coordinate.x, delta + coordinate.y, -delta + coordinate.z),
                               Coordinate(coordinate.x, delta + coordinate.y,  coordinate.z),
                               Coordinate(-delta + coordinate.x, delta + coordinate.y, coordinate.z),
                               Coordinate(-delta + coordinate.x, coordinate.y, delta + coordinate.z),
                               Coordinate(coordinate.x, coordinate.y, delta + coordinate.z),
                               Coordinate(coordinate.x, -delta + coordinate.y, delta + coordinate.z)] }
}

extension Triangle {
    
    public enum Corner: CaseIterable {
        
        case c0, c1, c2
    }
    
    public var corners: [Coordinate] { Corner.allCases.map { corner(corner: $0) } }
    
    public func corner(corner: Corner) -> Coordinate {
        
        switch corner {
        case .c0: return Coordinate(delta + coordinate.x, coordinate.y, coordinate.z)
        case .c1: return Coordinate(coordinate.x, coordinate.y, delta + coordinate.z)
        case .c2: return Coordinate(coordinate.x, delta + coordinate.y, coordinate.z)
        }
    }
    
    public func vertices(for scale: Scale) -> [Vector] { corners.map { $0.convert(to: scale) } }
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

extension Triangle {
    
    public struct Triangulation {
        
        public let coordinate: Coordinate
        public let scale: Scale
        public let triangles: [Triangle]
    }
    
    public func triangulation(for scale: Scale) -> Triangulation {
        
        let pointy = isPointy
        let size = Int(floor(Double(scale.rawValue) / 2.0))
        let half = Int(Double(size) / 2.0)
        
        var triangles: [Triangle] = []
        
        for column in 0..<scale.rawValue {
            
            let rows = ((column * 2) + 1)
            
            let s = size - column
            
            for row in 0..<rows {
                
                let i = Int(ceil(Double(row) * 0.5))
                let j = Int(ceil(Double(row - 1) * 0.5))
                
                let t = (half - column) + i
                let u = half - j
                
                let offset = Coordinate(pointy ? -s : -u,
                                        pointy ? t : -t,
                                        pointy ? u : s)
                
                triangles.append(.init(coordinate: coordinate + offset))
            }
        }
        
        return .init(coordinate: coordinate, scale: scale, triangles: triangles)
    }
}

extension Triangle {
    
    public struct Handles {
        
        public let coordinate: Coordinate
        public let scale: Scale
        public let coordinates: [Coordinate]
    }
    
    public func handles(for scale: Scale) -> Handles {
        
        let columns = scale.rawValue + 1
        let origin = coordinate.convert(from: scale, to: .tile)
        let pointy = origin.equalToZero
        let size = Int(ceil(Double(scale.rawValue) / sqrt(.silver)))
        let half = Int(floor(Double(size) / 2.0))
        
        var handles: [Coordinate] = []

        for column in 0..<columns {

            let rows = columns - column

            let s = half - column
            
            for row in 0..<rows {

                let t = half - row
                let u = -size + column + row

                let offset = Coordinate(pointy ? u : -u - 1,
                                        pointy ? t : -t - 1,
                                        pointy ? s : -s - 1)

                handles.append(origin + offset)
            }
        }
        
        return .init(coordinate: coordinate, scale: scale, coordinates: handles)
    }
}
