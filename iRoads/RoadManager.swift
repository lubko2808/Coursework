//
//  RoadManager.swift
//  iRoads
//
//  Created by Любомир  Чорняк on 15.12.2023.
//

import Foundation

class RoadManager {
    
    public var roads: [Road] = []
    
    static let shared = RoadManager()
    
    private init() {}

    /// Знаходить найкоротшу дорогу, де найбільша кількість смуг
    ///  - Returns: дорогу яка віповідає критеріям або nil, якщо масив доріг пустий
    public func shortestRoad() -> Road? {
        guard let maxAmountOfLanes = roads.max(by: { $0.amountOfLanes < $1.amountOfLanes })?.amountOfLanes else { return nil }
        let roads = roads.filter { $0.amountOfLanes == maxAmountOfLanes }
        let road = roads.min { $0.length < $1.length }
        return road
    }

    /// Впорядковує дороги за протяжністю методом підрахунку.
    /// - Returns: відсортовані дороги
    public func sortByLength() -> [Road] {
        let roadsLength = countingSort( roads.map {$0.length} )
        
        var roadsCopy = roads
        var sortedRoads: [Road] = []
        for length in roadsLength {
            guard let index = roadsCopy.firstIndex(where: {$0.length == length}) else { return []}
            sortedRoads.append(roadsCopy[index])
            roadsCopy.remove(at: index)
        }
        
        return sortedRoads
    }
    
    private func countingSort(_ array: [Int])-> [Int] {
        guard array.count > 0 else {return []}
        
        let maxElement = array.max() ?? 0
        
        var countArray = [Int](repeating: 0, count: Int(maxElement + 1))
        for element in array {
            countArray[element] += 1
        }

        for index in 1 ..< countArray.count {
            let sum = countArray[index] + countArray[index - 1]
            countArray[index] = sum
        }

        var sortedArray = [Int](repeating: 0, count: array.count)
        for index in stride(from: array.count - 1, through: 0, by: -1) {
            let element = array[index]
            countArray[element] -= 1
            sortedArray[countArray[element]] = element
        }
        return sortedArray
    }
    
    /// Визначає типи автомобільних доріг, з найбільшою протяжністю та наявністю пішохідних доріжок.
    /// - Returns: типи автомобільних доріг, які відповідають критеріям
    public func longestRoadTypes() -> [Road.RoadType] {
        guard let maxLength = roads.max(by: { $0.length < $1.length })?.length else { return []}
        var longestRoadTypes = Set<Road.RoadType>()
        roads.forEach { road in
            if road.length == maxLength && road.isSidewalkPresent == true {
                longestRoadTypes.insert(road.type)
            }
        }
        
        return longestRoadTypes.map {$0}
    }
    
    /// Визначає автомобільні дороги з найбільшою кількістю смуг та наявними пішохідними доріжками які належать до регіональних.
    /// - Returns: дороги, які відповідають критеріям
    public func roadsWithTheBiggestAmountOfLanes() -> [Road] {
        guard let maxAmountOfLanes = roads.max(by: { $0.amountOfLanes < $1.amountOfLanes })?.amountOfLanes else { return [] }
        let filteredRoads = roads.filter { road in
            if road.amountOfLanes == maxAmountOfLanes && road.isSidewalkPresent == true && road.type == .regional {
                return true
            } else {
                return false
            }
        }
        return filteredRoads
    }
    
    /**
     Знаходить всі дороги, які належать до заданого типу, наявні розділювачі посередині, кількість смуг >2.

     - Parameters:
        - type: Ціле число, яке представляє тип дороги.

     - Returns: дороги, які відповідають критеріям
     */
    public func roadsWithType(_ type: Int) -> [Road] {
        var roadType: Road.RoadType = .regional
        switch type {
        case 0: roadType = .state
        case 1: roadType = .regional
        case 2: roadType = .oblasna
        case 3: roadType = .local
        default: break
        }
        
        var roads: [Road] = []
        for road in self.roads {
            if road.isSeparatorPresent == true && road.amountOfLanes > 2 {
                if road.type == roadType {
                    roads.append(road)
                }
            }
        }

        return roads
    }
    
    public func addRoad(road: Road) {
        roads.append(road)
    }
    
    
    /**
    Перевіряє коректність довжини

     - Parameters:
        - length: довжина

     - Returns: опис помилки, або nil якщо довжина коректна
     */
    public func checkLength(length: String) throws {
        if length.isEmpty {
            throw RoadError.emptyLength(description: "you didn't enter length")
        }
        
        guard let length = Int(length) else {
            throw RoadError.incorrectLength(description: "you entered incorrect length")
        }
        
        if length < 0 {
            throw RoadError.negativeLength(description: "you entered negative length")
        }
    }
    
    /**
    Перевіряє коректність кількості смуг

     - Parameters:
        - amountOfLanes: кількості смуг

     - Returns: опис помилки, або nil якщо кількості смуг коректна
     */
    public func isAmountOfLanesValid(amountOfLanes: String) -> String? {
        var errorMessage: String? = nil
        if amountOfLanes.isEmpty {
            errorMessage = "you didn't enter amount of lanes"
        } else if Int(amountOfLanes) == nil {
            errorMessage = "you entered incorrect amount of lanes"
        }
        return errorMessage
    }
    
}
