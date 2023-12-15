//
//  Road.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import Foundation

struct Road {
    
    enum RoadType: String, CaseIterable {
        case state
        case regional
        case oblasna
        case local
    }
    
    init(type: RoadType, length: Int, amountOfLanes: Int, isSeparatorPresent: Bool, isSidewalkPresent: Bool) {
        self.type = type
        self.length = length
        self.amountOfLanes = amountOfLanes
        self.isSeparatorPresent = isSeparatorPresent
        self.isSidewalkPresent = isSidewalkPresent
    }
    
    init() {
        type = .regional
        length = 0
        amountOfLanes = 0
        isSeparatorPresent = false
        isSidewalkPresent = false
    }
    
    public var type: RoadType
    public var length: Int
    public var amountOfLanes: Int
    public var isSeparatorPresent: Bool
    public var isSidewalkPresent: Bool
    
}

