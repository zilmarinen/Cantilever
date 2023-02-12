//
//  TerrainType.swift
//
//  Created by Zack Brown on 10/02/2023.
//

public enum TerrainType: CaseIterable {
    
    case boreal
    case chaparral
    case deciduous
    case prairie
    case rainforest
    case scrubland
    case tundra
    
    public var transitions: [TerrainType] {
        
        switch self {
            
        case .boreal: return [.chaparral, .deciduous, .tundra]
        case .chaparral: return [.boreal, .prairie, .scrubland]
        case .deciduous: return [.boreal, .rainforest, .scrubland]
        case .prairie: return [.chaparral]
        case .rainforest: return [.deciduous]
        case .scrubland: return [.chaparral, .deciduous]
        case .tundra: return [.boreal]
        }
    }
}
