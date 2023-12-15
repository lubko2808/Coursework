//
//  RoadError.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//


import Foundation

enum RoadError: LocalizedError {
    case emptyLength(description: String)
    case negativeLength(description: String)
    case incorrectLength(description: String)
    
    var errorDescription: String? {
        switch self {
        case .emptyLength(let description): return description
        case .negativeLength(let description): return description
        case .incorrectLength(let description): return description
        }
    }
}

