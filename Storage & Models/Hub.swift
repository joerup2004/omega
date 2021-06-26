//
//  Hub.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/16/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Hub
// Holds all data used in the calculating process
// The hub of data used by all other algorithm classes
class Hub: ObservableObject {
    
    static let hub = Hub()
    
    // Output arrays
    @Published var topOutput: [String] = [" "]
    @Published var mainOutput: [String] = ["0"]
    @Published var bottomOutput: [String] = [" "]
    var prevOutput: [String] = []
    
    // FormattingGuide arrays
    @Published var topFormattingGuide: [[String]] = [[""]]
    @Published var mainFormattingGuide: [[String]] = [[""]]
    @Published var bottomFormattingGuide: [[String]] = [[""]]
    
    // Button arrays
    @Published var disabledButtons: [String] = [")"," ̅"]
    @Published var autoParButtons: [String] = []
    
    // Queue arrays
    var queue = [String]()
    var result = [String]()
    var results = [[String]]()
    var indexingQueue = [String]()
    var addBeforeQueue = [String]()
    var backspaceQueue = [[String]]()
    var backspaceNum = [String]()
    var backspaceIndexingQueue = [[String]]()
    var stepsQueue = [[String]]()
    var stepsExpressions = [[String]]()
    
    // Other variables
    var num = ""
    var indexingRoot = false
    var indexingLog = false
    var indexingBase = false
    var indexingRootPar = false
    var indexingLogPar = false
    var indexingBasePar = false
    var extraMessage = " "
    var extraMessagePopUp = ""
    var error = false
    var currentCalc = -1
    
    // Type collections
    let numbers = ["0","1","2","3","4","5","6","7","8","9"]
    let numberMods = [".","+/-"," ̅"]
    let numbers2 = ["π","e","%","!","𝔁","rand"]
    let operators = ["+","-","×","÷","*","#×","/","mod"]
    let operators2 = ["^2","^3","^","√","³√","ˣ√","^-1","EXP","10^","2^","e^","x^","nPr","nCr"]
    let functions = ["| |","sin","cos","tan","csc","sec","cot","sin⁻¹","cos⁻¹","tan⁻¹","csc⁻¹","sec⁻¹","cot⁻¹","sinh","cosh","tanh","csch","sech","coth","sinh⁻¹","cosh⁻¹","tanh⁻¹","csch⁻¹","sech⁻¹","coth⁻¹","log","ln","log₂","logₓ","round","floor","ceil"]
    let groupingSymbols = ["(",")"]
    let control = ["=","C","⭠"]
}

