//
//  Calculations.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/16/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Calculations
// Holds the lists of past calculations and performs tasks with them
class Calculations: ObservableObject {
    
    static let calc = Calculations()
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    
    // Calculation array
    @Published var calculations: [Calculation] = getRecentCalculations()
    @Published var savedCalculations: [Calculation] = getSavedCalculations()
    
    var calculationID = 0
    
    
    // MARK: Create Calculation
    // Create a calculation object with the calculation's data
    func createCalculation() {
        
        let calculation = Calculation()
        
        calculation.id = calculationID
        calculationID += 1
        
        calculation.time = currentDate(format: "time")
        calculation.date = currentDate(format: "date")
        calculation.fullTime = currentDate(format: "fullTime")
        calculation.fullDate = currentDate(format: "fullDate")
        
        calculation.topOutput = hub.topOutput
        calculation.mainOutput = hub.mainOutput
        calculation.bottomOutput = hub.bottomOutput
        calculation.prevOutput = hub.prevOutput
        
        calculation.topFormattingGuide = hub.topFormattingGuide
        calculation.mainFormattingGuide = hub.mainFormattingGuide
        calculation.bottomFormattingGuide = hub.bottomFormattingGuide
        
        calculation.queue = hub.queue
        calculation.result = hub.result
        calculation.results = hub.results
        
        calculation.backspaceQueue = hub.backspaceQueue
        calculation.backspaceNum = hub.backspaceNum
        calculation.backspaceIndexingQueue = hub.backspaceIndexingQueue
        
        calculation.stepsExpressions = hub.stepsExpressions
        
        calculations += [calculation]
        
        while calculations.count > settings.recentCalcCount {
            calculations.removeFirst()
        }
        var index = 0
        while index < calculations.count {
            let calculation = calculations[index]
            if calculation.id != index {
                calculation.id = index
            }
            index += 1
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(calculations) {
            UserDefaults.standard.set(encoded, forKey: "recentCalculations")
        }
    }
    
    
    // MARK: Save Calculation
    // Save a calculation
    func saveCalculation(calculation: Calculation) {
        
        print("(Calculation) Saving calculation")
        
        calculation.save.toggle()
        
        if calculation.save {
            
            let saveCalculationID = savedCalculations.count
            calculation.saveID = saveCalculationID
            
            savedCalculations.append(calculation)
        }
        else {
            
            savedCalculations.remove(at: calculation.saveID)
            
            var index = 0
            while index < savedCalculations.count {
                let calculation = savedCalculations[index]
                if calculation.saveID != index {
                    calculation.saveID = index
                }
                index += 1
            }
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(calculations) {
            UserDefaults.standard.set(encoded, forKey: "recentCalculations")
        }
        if let encoded = try? encoder.encode(savedCalculations) {
            UserDefaults.standard.set(encoded, forKey: "savedCalculations")
        }
    }
    
    
    // MARK: Delete Calculation
    // Delete a calculation
    func deleteCalculation(calculation: Calculation) {
        
        if calculation.save {
            
            savedCalculations.remove(at: calculation.saveID)
            
            var index = 0
            while index < savedCalculations.count {
                let calculation = savedCalculations[index]
                if calculation.saveID != index {
                    calculation.saveID = index
                }
                index += 1
            }
            
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(savedCalculations) {
                UserDefaults.standard.set(encoded, forKey: "savedCalculations")
            }
            
            if calculations.count > calculation.id {
                    
                if calculations[calculation.id].uuid == calculation.uuid {
                    
                    calculations.remove(at: calculation.id)
                    
                    for calc in calculations {
                        if calc.id > calculation.id {
                            calc.id -= 1
                        }
                    }
                    calculationID -= 1
                    
                }
            }
        }
        else {
        
            calculations.remove(at: calculation.id)
            
            for calc in calculations {
                if calc.id > calculation.id {
                    calc.id -= 1
                }
            }
            calculationID -= 1
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(calculations) {
            UserDefaults.standard.set(encoded, forKey: "recentCalculations")
        }
    }
    
    
    // MARK: Current Date
    // Get the current date
    func currentDate(format: String) -> String {
    
        let currentDate = DateFormatter()
        
        currentDate.dateStyle = .none
        currentDate.timeStyle = .short
        let time = currentDate.string(from: Date())
        
        currentDate.dateStyle = .short
        currentDate.timeStyle = .none
        let date = currentDate.string(from: Date())
        
        currentDate.dateStyle = .none
        currentDate.timeStyle = .medium
        let fullTime = currentDate.string(from: Date())
        
        currentDate.dateStyle = .long
        currentDate.timeStyle = .none
        let fullDate = currentDate.string(from: Date())
        
        if format == "time" { return time }
        else if format == "date" { return date }
        else if format == "fullTime" { return fullTime }
        else if format == "fullDate" { return fullDate }
        else {
            return "None"
        }
    }
}

// MARK: Get Recent Calculations
func getRecentCalculations() -> [Calculation] {
 
    if let recentCalculations = UserDefaults.standard.object(forKey: "recentCalculations") as? Data {
        
        let decoder = JSONDecoder()
        
        if let calculations = try? decoder.decode([Calculation].self, from: recentCalculations) {
            return calculations
        }
    }
    return []
}

// MARK: Get Saved Calculations
func getSavedCalculations() -> [Calculation] {
 
    if let savedCalculations = UserDefaults.standard.object(forKey: "savedCalculations") as? Data {
        
        let decoder = JSONDecoder()
        
        if let calculations = try? decoder.decode([Calculation].self, from: savedCalculations) {
            return calculations
        }
    }
    return []
}
