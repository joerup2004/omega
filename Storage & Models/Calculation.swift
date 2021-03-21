//
//  Calculation.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import Foundation
import UIKit

class Calculation: ObservableObject, Codable {
    
    var uuid = UUID()
    var id = 0
    var saveID = 0
    
    var name = "Calculation"
    
    var date = String()
    var time = String()
    var fullDate = String()
    var fullTime = String()
    
    var topOutput = [String]()
    var mainOutput = [String]()
    var bottomOutput = [String]()
    var prevOutput = [String]()
    
    var topFormattingGuide = [[""]]
    var mainFormattingGuide = [[""]]
    var bottomFormattingGuide = [[""]]
    
    var queue = [String]()
    var result = [String]()
    var results = [[String]]()
    
    var backspaceQueue = [[String]]()
    var backspaceNum = [String]()
    var backspaceIndexingQueue = [[String]]()
    
    var stepsExpressions = [[String]]()
    
    var resultContinues = false
    
    var save = false
    
}


