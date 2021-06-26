//
//  Input.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/16/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Input
// Input the buttons and organize them into a queue
// The queue is then sent to the Calculate class to be calculated
class Input: ObservableObject {
    
    static let input = Input()
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    @ObservedObject var calc = Calculations.calc
    var calculate = Calculate.calculate
    var exp = Expression.expression
    var math = Math.math
    var formatting = Formatting.formatting
    
    // Organization variables
    var expression = ""
    var finalExpression = ""
    var resultShowing = false
    var waitForIndex = false
    var canInsert = false
    var showErrorPopUp = false
    var closeParNext = false
    
    
    // MARK: - Queue Inputs
    
    // Queue the inputs
    func queueInput(button: String, pressType: String, record: Bool) {
        
        // If refresh, refresh
        if button == "refresh" {
            
            if resultShowing {
                return
            }
            
            // Add final parentheses
            finalPar()
            
            // Create the expression
            expression = exp.createExpression(hub.queue)
            
            // Set topOutput to the previous output
            hub.topOutput = hub.prevOutput
            hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
            
            // Set mainOutput to the expression
            hub.mainOutput = exp.splitExpression(expression)
            hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
            
            // Set bottomOutput to the extra message if there is one
            hub.bottomOutput = exp.splitExpression(hub.extraMessage)
            hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
            
            // Remove final par
            while hub.queue.last == "﹚" {
                hub.queue.removeLast()
            }
            while hub.indexingQueue.last == "﹚" {
                hub.indexingQueue.removeLast()
            }
            
            return
        }
        
        // Reset
        hub.disabledButtons.removeAll()
        hub.autoParButtons.removeAll()
        hub.extraMessage = " "
        hub.queue = resultShowing ? [] : hub.queue
        
        // MARK: Determine Type
        // Determine the type of the inputted button
        var type = ""
        
        // Determine which type array contains the inputted button, and set its type
        for item in hub.numbers {
            if button == item {
                type = "numbers"
            }
        }
        for item in hub.numberMods {
            if button == item {
                type = "numberMods"
            }
        }
        for item in hub.numbers2 {
            if button == item {
                type = "numbers2"
            }
        }
        for item in hub.operators {
            if button == item {
                type = "operators"
            }
        }
        for item in hub.operators2 {
            if button == item {
                type = "operators2"
            }
        }
        for item in hub.functions {
            if button == item {
                type = "functions"
            }
        }
        for item in hub.groupingSymbols {
            if button == item {
                type = "groupingSymbols"
            }
        }
        for item in hub.control {
            if button == item {
                type = "control"
            }
        }
        
        
        // MARK: Numbers
        // Numbers type contains digits
        if type == "numbers" {
            
            // Number inputs are not directly queued; instead, they are added to the num variable, so it can have multiple digits
            // When another button such as an operator or enter is pressed, that means the num is finished, and so the num is queued
            
            // If result is currently showing, start over
            if resultShowing {
                hub.queue = afterResult(keepResult: false)
            }
            
            // If the last item in the queue is a special number or close parenthesis, queue a multiplication sign before adding a number
            if hub.queue.count >= 1 {
                var addMult = false
                for char in hub.numbers {
                    if hub.queue[hub.queue.count-1].contains(char) || (hub.numbers2+[")"]).contains(hub.queue[hub.queue.count-1]) {
                        addMult = true
                    }
                }
                if addMult {
                    hub.queue.append("×")
                }
            }
            
            // Add the inputted digit to num
            hub.num += button
            
            // Fix zeroes
            hub.num = exp.fixZero(string: hub.num, all: false)
            
            // Print the num
            print("{\"\(hub.num)\"}")
            
        }
        
        
        // MARK: Number Mods
        // Number Mods type contains number modifiers such as decimal points and negatives
        if type == "numberMods" {
            
            // Number mods are not directly queued; instead, they are added to the num variable, so it can have multiple digits
            // When another button such as an operator or enter is pressed, that means the num is finished, and so the num is queued
            
            // Decimal Point
            if button == "." {
                
                // If result is currently showing, start over
                if resultShowing {
                    hub.queue = afterResult(keepResult: false)
                }
                
                // If the last item in the queue is a special number or close parenthesis, queue a multiplication sign before adding a number
                if hub.queue.count >= 1 {
                    var addMult = false
                    for char in hub.numbers {
                        if hub.queue[hub.queue.count-1].contains(char) || (hub.numbers2+[")"]).contains(hub.queue[hub.queue.count-1]) {
                            addMult = true
                        }
                    }
                    if addMult {
                        hub.queue.append("×")
                    }
                }
                
                // Remove the decimal point if there already is one as the last digit
                if hub.num.last == "." {
                    hub.num.removeLast()
                }
                    
                // If there is a decimal point but it is not the last digit, do nothing
                else if hub.num.contains(".") {
                }
                    
                // If there is no decimal point, add one
                else {
                    hub.num += "."
                }
                
            }
                
            // Negation
            else if button == "+/-" {
                
                // If indexing base, put into par
                if hub.indexingBase {
                    putIntoPar(before: "^", closeNext: false)
                }
                
                if !hub.num.isEmpty {
                    
                    // Negate num
                    hub.num = negate(hub.num)
                }
                else if resultShowing {
                    
                    // If result is currently showing, continue
                    if resultShowing {
                        hub.queue = afterResult(keepResult: true)
                    }
                    
                    // If result queue contains one item, negate it
                    if hub.queue.count == 1 {
                        hub.queue[0] = negate(hub.queue[0])
                    }
                        
                    // If result queue contains multiple items, put parentheses around it and negate it
                    else if hub.queue.count > 1 {
                        
                        // Add button before
                        addButtonBefore(button: "-")
                        
                        // Add a negative
                        hub.queue.append("-01")
                        hub.queue.append("*")
                        
                        // Re-add the items
                        hub.queue += hub.addBeforeQueue
                        hub.addBeforeQueue.removeAll()
                    }
                    
                }
                else {
                    
                    var addNegativeBefore = false
                    
                    if hub.queue.isEmpty || (hub.operators+hub.operators2+hub.functions+["§","¶","(","E","P","C"]).contains(hub.queue.last) {

                        // Add a negative to num
                        if pressType == "tap" {
                            hub.num = "-0"
                        }
                        
                        // Add parentheses if indicated
                        else if pressType == "hold" {
                            hub.queue += ["-01","*","("]
                        }
                    }
                    else if (hub.numbers2).contains(hub.queue.last!) {
                        
                        var containsNum = false
                        if hub.queue.count >= 4 {
                            if hub.functions.contains(hub.queue[hub.queue.count-4]) {
                                addNegativeBefore = true
                            }
                        }
                        if hub.queue.count >= 3 && !addNegativeBefore {
                            for num in hub.numbers {
                                if hub.queue[hub.queue.count-3].contains(num) {
                                    containsNum = true
                                }
                            }
                            if hub.queue[hub.queue.count-2] != "*" {
                                containsNum = false
                            }
                            if containsNum {
                                hub.queue[hub.queue.count-3] = negate(hub.queue[hub.queue.count-3])
                            }
                        }
                        if !containsNum {
                            addNegativeBefore = true
                        }
                    }
                    else if hub.queue.count == 1 {
                        // If result queue contains one item, negate it
                        hub.queue[0] = negate(hub.queue[0])
                    }
                    else {
                        addNegativeBefore = true
                    }
                    
                    if addNegativeBefore {
                        // Add button before
                        addButtonBefore(button: "-")
                        
                        // Add a negative
                        hub.queue.append("-01")
                        hub.queue.append("*")
                        
                        // Re-add the items
                        hub.queue += hub.addBeforeQueue
                        hub.addBeforeQueue.removeAll()
                    }
                }
            }
            
            // Repeating decimal
            else if button == " ̅" {
                
                // Queue the num
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: false)
                
                // Queue a repeater
                hub.queue[hub.queue.count-1].append(" ̅")
                
                // End indexing
                endIndexing()
            }
            
            if !hub.num.isEmpty {
                
                // Fix zeroes
                hub.num = exp.fixZero(string: hub.num, all: false)
                
                // Print the num
                print("{\"\(hub.num)\"}")
            }
            else if !hub.queue.isEmpty {
                
                // Remove multiple negative coefficients
                var negIndex = 0
                var negFound = 0
                var coeFound = 0
                while negIndex < hub.queue.count {
                    if negFound == 0 && hub.queue[negIndex] == "-01" {
                        negFound = 1
                    }
                    if negFound == 1 && hub.queue[negIndex] == "*" {
                        negFound = 2
                    }
                    if negFound == 2 && hub.queue[negIndex] == "-01" {
                        negFound = 3
                    }
                    if negFound == 3 && hub.queue[negIndex] == "*" {
                        negFound = 0
                        hub.queue.remove(at: negIndex)
                        hub.queue.remove(at: negIndex-1)
                        hub.queue.remove(at: negIndex-2)
                        hub.queue.remove(at: negIndex-3)
                        negIndex -= 4
                    }
                    
                    if negIndex < hub.queue.count && negIndex >= 0 {
                        if coeFound == 0 && hub.queue[negIndex] == "01" {
                            coeFound = 1
                        }
                        if coeFound == 1 && hub.queue[negIndex] == "*" {
                            coeFound = 0
                            hub.queue.remove(at: negIndex)
                            hub.queue.remove(at: negIndex-1)
                            negIndex -= 2
                        }
                    }
                    
                    if negIndex >= 0 && negIndex < hub.queue.count {
                        if hub.queue[negIndex] != "01" && hub.queue[negIndex] != "-01" && hub.queue[negIndex] != "*" {
                            break
                        }
                    }
                    
                    negIndex += 1
                }
                
                // Print the queue
                print(hub.queue)
            }
        }
        
        
        // MARK: Numbers 2
        // Numbers 2 type contains special numbers such as π and e
        if type == "numbers2" {
            
            // Unlike regular numbers, special numbers are directly queued
            // When they are operated on, they are converted to their numerical values
            
            // If result is currently showing, start over
            if resultShowing && (button == "%" || button == "!") {
                hub.queue = afterResult(keepResult: true)
            }
            else if resultShowing {
                hub.queue = afterResult(keepResult: false)
            }
            
            // If after carrot or indexing, put into par
            if hub.queue.last == "^" {
                putIntoPar(before: "^", closeNext: true)
            }
            else if hub.queue.last == "§" && hub.indexingRoot {
                putIntoPar(before: "§", closeNext: true)
            }
            else if hub.queue.last == "log" && hub.indexingLog {
                putIntoPar(before: "log", closeNext: true)
            }
            else if hub.queue.last == "xb" && hub.indexingBase {
                putIntoPar(before: "xb", closeNext: true)
            }
            
            // Add a multiplier if a queued number or parentheses is last
            if hub.queue.count >= 1 {
                for num in hub.numbers {
                    if hub.queue[hub.queue.count-1].contains(num) || hub.numbers2.contains(hub.queue[hub.queue.count-1]) || hub.queue[hub.queue.count-1] == ")" {
                        if ["%","!"].contains(button) {
                            // Add extra par
                            addExtraPar(before: "*")
                            // Queue a coefficient
                            hub.queue.append("*")
                            break
                        }
                        else if ["π","e","𝔁"].contains(button) {
                            // Queue an invisible multiplication sign
                            hub.queue.append("#×")
                            break
                        }
                        else if button == "rand" {
                            // Queue a multiplication sign
                            hub.queue.append("×")
                            break
                        }
                    }
                }
            }
            
            // Add extra parentheses and coefficient if an exponential is last
            if ["E","P","C"].contains(hub.queue.last) && !hub.num.isEmpty {
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: false)
                if ["%","!"].contains(button) {
                    // Add extra par
                    addExtraPar(before: "*")
                    // Queue a coefficient
                    hub.queue.append("*")
                }
                else if ["π","e","𝔁","rand"].contains(button) {
                    // Queue a multiplication sign
                    hub.queue.append("×")
                }
            }
            
            // If the num is -0, queue multiplication by negative
            if hub.num == "-0" && ["π","e","𝔁","rand"].contains(button) {
                hub.num = ""
                hub.queue += ["-01"]
                hub.queue += ["*"]
            }
            
            // If num contains something, queue the num and then a coefficient before adding the special number
            if !hub.num.isEmpty && ["%","!"].contains(button) {
                queueNum(addToZero: true, removeOp: false, endIndex: false, closePar: false)
                hub.queue.append("*")
            }
            else if !hub.num.isEmpty && ["π","e","𝔁"].contains(button) {
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: false)
                hub.queue.append("*")
            }
            else if !hub.num.isEmpty && button == "rand" {
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: false)
                hub.queue.append("×")
            }
            
            // If the queue is still empty and the special number is % or !, queue a 0 as the coefficient (those cannot stand alone)
            if hub.queue.isEmpty && ["%","!"].contains(button) {
                hub.queue.append("0")
                hub.queue.append("*")
            }
            
            // Add an invisible coefficient if there is not one already
            if hub.queue.last != "*" {
                hub.queue.append("01")
                hub.queue.append("*")
            }
            
            // Queue the number
            hub.queue.append(button)
            
            // Add par if necessary
            if closeParNext {
                hub.queue.append(")")
                closeParNext = false
            }
            
            // End indexing
            endIndexing()
            
            // Print the queue
            print(hub.queue)
            
        }
        
        
        // MARK: Operators
        // Operators type contains major operators such as addition, subtraction, multiplication, and division
        if type == "operators" {
            
            // When an operator is pressed, it means the previous num is complete and so it can be queued
            // Then, the operator is added to the queue
            
            // If result is currently showing, continue from previous result
            if resultShowing {
                hub.queue = afterResult(keepResult: true)
            }
            
            // For fraction bars
            if button == "/" {
                
                // Add extra parentheses and coefficient if a queued number is last
                if hub.queue.count >= 1 {
                    // Queue a coefficient if a number is last
                    for num in hub.numbers {
                        if hub.queue[hub.queue.count-1].contains(num) || [")","E","P","C"].contains(hub.queue[hub.queue.count-1]) {
                            if ["E","P","C"].contains(hub.queue[hub.queue.count-1]) {
                                queueNum(addToZero: true, removeOp: true, endIndex: false, closePar: false)
                            }
                            // Add extra parentheses
                            addExtraPar(before: "/")
                            break
                        }
                    }
                }
                
                // Put into par
                putIntoPar(before: "/", closeNext: false)
                
                // Queue the previous number, add zero if queue is empty, and remove the operator if there is one
                queueNum(addToZero: true, removeOp: true, endIndex: false, closePar: false)
            }
            else {
                
                // Queue the previous number, add zero if queue is empty, and remove the operator if there is one
                queueNum(addToZero: true, removeOp: true, endIndex: true, closePar: true)
            }
            
            // Queue the operator
            hub.queue.append(button)
            
            // Add parentheses if indicated
            if pressType == "hold" {
                hub.queue.append("(")
            }
            
            // Print the queue
            print(hub.queue)
            
        }
        
        
        // MARK: Operators 2
        // Operators 2 type contains other operators such as exponents and roots
        if type == "operators2" {
            
            // When an operator is pressed, it means the previous num is complete and so it can be queued
            // Then, the operator is added to the queue
            
            // If result is currently showing, continue from previous result
            if resultShowing {
                hub.queue = afterResult(keepResult: true)
            }
            
            // For exponents
            if button.contains("^") || button == "EXP" {
                
                // For pedefined powers (square/cube)
                if button == "^2" || button == "^3" || button == "^-1" {
                    
                    // Queue the previous number, add to zero if queue is empty
                    queueNum(addToZero: true, removeOp: false, endIndex: true, closePar: true)
                    
                    // Add extra parentheses
                    addExtraPar(before: "^")
                    
                    // Only add a carrot if there is not one already in the last place
                    if !hub.queue.isEmpty {
                        if hub.queue[hub.queue.count-1] != "^" {
                            
                            // Queue a carrot
                            hub.queue.append("^")
                        }
                    }
                    
                    // Square
                    if button == "^2" {
                        
                        // Queue a 2
                        hub.queue.append("2")
                    }
                        
                    // Cube
                    else if button == "^3" {
                        
                        // Queue a 3
                        hub.queue.append("3")
                    }
                        
                    // Inverse
                    else if button == "^-1" {
                        
                        // Queue a -1
                        hub.queue.append("-1")
                    }
                }
                    
                // For inputted powers (xth power)
                else if button == "^" {
                    
                    // Queue the previous number, add to zero if queue is empty
                    queueNum(addToZero: true, removeOp: false, endIndex: true, closePar: true)
                    
                    // Add extra parentheses
                    addExtraPar(before: "^")
                    
                    // Queue a carrot
                    hub.queue.append("^")
                    
                    // Queue a parentheses if the button was held
                    if pressType == "hold" {
                        hub.queue.append("(")
                    }
                    
                    // Wait for the next number to be inputted
                    
                }
                    
                // For base 10, 2, and e
                else if button == "10^" || button == "2^" || button == "e^" || button == "x^" {
                    
                    // If the num is -0, queue multiplication by negative
                    if hub.num == "-0" {
                        hub.num = ""
                        hub.queue += ["-01"]
                        hub.queue += ["*"]
                        hub.queue += hub.addBeforeQueue.isEmpty ? ["("] : []
                    }
                    
                    // Add any possible items to the addButtonBefore, so the 10^ or e^ will go before them
                    addButtonBefore(button: "^", doNotPar: pressType == "hold")
                    
                    // For predefined bases (10/2/e)
                    if button == "10^" || button == "2^" || button == "e^" {
                    
                        // Base 10
                        if button == "10^" {
                            // Queue a 10
                            hub.queue.append("10")
                        }
                            
                        // Base 2
                        else if button == "2^" {
                            // Queue a 10
                            hub.queue.append("2")
                        }
                            
                        // Base e
                        else if button == "e^" {
                            // Queue an e
                            hub.queue.append("e")
                        }
                        
                        // Queue a carrot
                        hub.queue.append("^")
                        
                        // Add parentheses if indicated
                        if pressType == "hold" && hub.addBeforeQueue.isEmpty {
                            hub.queue.append("(")
                        }
                    }
                    
                    // For base x
                    else if button == "x^" {
                        
                        // Allow for the base to be inputted
                        hub.indexingBase = true
                        
                        // Add xb (x base) temporarily
                        hub.queue.append("xb")
                        
                        // Add parentheses if indicated
                        if pressType == "hold" && hub.addBeforeQueue.isEmpty {
                            hub.indexingBasePar = true
                        }
                        
                        // The rest of this happens under Other after the next number is inputted
                    }
                    
                    // If added before items, re-add the items
                    if !hub.addBeforeQueue.isEmpty {
                        if pressType == "hold" {
                            hub.addBeforeQueue = ["("]+hub.addBeforeQueue
                        }
                        if hub.queue.last == "xb" {
                            waitForIndex = true
                            hub.indexingQueue = hub.addBeforeQueue
                        }
                        else {
                            hub.queue += hub.addBeforeQueue
                        }
                        hub.addBeforeQueue.removeAll()
                    }
                }
                
                // For exponential operator
                else if button == "EXP" {
                    
                    // Add extra parentheses
                    var containsNum = false
                    if !hub.queue.isEmpty {
                        for num in hub.numbers+hub.numbers2 {
                            if hub.queue.last!.contains(num) {
                                containsNum = true
                            }
                        }
                    }
                    if !hub.num.isEmpty {
                        queueNum(addToZero: true, removeOp: false, endIndex: true, closePar: false)
                        containsNum = true
                    }
                    if (containsNum || hub.queue.last == ")") {
                        addExtraPar(before: "E")
                    }
                    
                    // Put into parentheses
                    if hub.queue.count > 1 || (hub.queue.count == 1 && !containsNum) {
                        putIntoPar(before: "E", closeNext: false)
                    }
                    
                    // Queue the previous number, add to zero if queue is empty
                    queueNum(addToZero: true, removeOp: false, endIndex: false, closePar: false)
                    
                    // Queue an exponential operator
                    hub.queue.append("E")
                    
                    // Queue a parentheses if the button was held
                    if pressType == "hold" {
                        hub.queue.append("(")
                    }
                    
                    // Wait for the next number to be inputted
                    
                }
            }
            
            // Foor roots
            else if button.contains("√") {
                
                // If the num is -0, queue multiplication by negative
                if hub.num == "-0" {
                    hub.num = ""
                    hub.queue += ["-01"]
                    hub.queue += ["*"]
                    hub.queue += hub.addBeforeQueue.isEmpty ? ["("] : []
                }
                
                // Add any possible items to the addButtonBefore, so the radical will go before them
                addButtonBefore(button: "√", doNotPar: pressType == "hold")
                
                // Queue a root index identifier
                hub.queue.append("§")
                
                // For pedefined roots (square/cube)
                if button == "√" || button == "³√" {
                    
                    // Square root
                    if button == "√" {
                        
                        // Queue an invisible 2
                        hub.queue.append("#2")
                    }
                        
                    // Cube root
                    else if button == "³√" {
                        
                        // Queue a 3
                        hub.queue.append("3")
                    }
                    
                    // Queue a root
                    hub.queue.append("√")
                    
                    // Queue a parenthesis if the button was held
                    if pressType == "hold" && hub.addBeforeQueue.isEmpty {
                        hub.queue.append("(")
                    }
                }
                    
                // For inputted roots (xth root)
                else if button == "ˣ√" {
                    
                    // Allow for the index to be inputted
                    hub.indexingRoot = true
                    
                    // Add parentheses if indicated
                    if pressType == "hold" && hub.addBeforeQueue.isEmpty {
                        hub.indexingRootPar = true
                    }
                    
                    // The rest of this happens under Other after the next number is inputted
                }
                
                // If added before items, re-add the items
                if !hub.addBeforeQueue.isEmpty {
                    if pressType == "hold" {
                        hub.addBeforeQueue = ["("]+hub.addBeforeQueue
                    }
                    if hub.queue.last == "§" {
                        waitForIndex = true
                        hub.indexingQueue = hub.addBeforeQueue
                    }
                    else {
                        hub.queue += hub.addBeforeQueue
                    }
                    hub.addBeforeQueue.removeAll()
                }
            }
            
            // For permutations and combinations
            else if button == "nPr" || button == "nCr" {
                
                // Add extra parentheses
                var containsNum = false
                if !hub.queue.isEmpty {
                    for num in hub.numbers+hub.numbers2 {
                        if hub.queue.last!.contains(num) {
                            containsNum = true
                        }
                    }
                }
                if !hub.num.isEmpty {
                    queueNum(addToZero: true, removeOp: false, endIndex: true, closePar: false)
                    containsNum = true
                }
                if (containsNum || hub.queue.last == ")") {
                    addExtraPar(before: "E")
                }
                
                // Put into parentheses
                if hub.queue.count > 1 || (hub.queue.count == 1 && !containsNum) {
                    putIntoPar(before: "E", closeNext: false)
                }
                
                // Queue the previous number, add to zero if queue is empty
                queueNum(addToZero: true, removeOp: false, endIndex: true, closePar: true)
                
                // Queue the operation
                if button.contains("P") {
                    hub.queue.append("P")
                }
                else if button.contains("C") {
                    hub.queue.append("C")
                }
                
                // Queue a parentheses if the button was held
                if pressType == "hold" {
                    hub.queue.append("(")
                }
            }
            
            // Print the queue
            print(hub.queue)
            
        }
        
        
        // MARK: Functions
        // Functions type contains trigonometric and logarithmic functions such as sine, cosine, tangent, log, etc.
        if type == "functions" {
            
            // When a function is pressed, it means the previous num is complete and so it can be queued
            // Then, the function is added to the queue
            
            // If result is currently showing, start over
            if resultShowing {
                hub.queue = afterResult(keepResult: true)
            }
            
            // If the num is -0, queue multiplication by negative
            if hub.num == "-0" {
                hub.num = ""
                hub.queue += ["-01"]
                hub.queue += ["*"]
                hub.queue += hub.addBeforeQueue.isEmpty ? ["("] : []
            }
            
            // Add any possible items to the addButtonBefore, so the radical will go before them
            addButtonBefore(button: "func", doNotPar: pressType == "hold")
            
            // Queue the previous number
            queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
            
            // Queue a multiplication operator before the function if no other operator was specified
            var addMult = true
            if hub.queue.count > 0 {
                for op in hub.operators+hub.operators2+["(","¶"] {
                    // If another operator already is present, do not add
                    if hub.queue[hub.queue.count-1] == op {
                        addMult = false
                    }
                }
            }
            else {
                addMult = false
            }
            if addMult == true {
                hub.queue.append("×")
            }
                
            // Absolute Value
            if button == "| |" {
                
                // Queue the function
                hub.queue.append("| |")
                
                // Add parentheses if indicated
                if pressType == "hold" {
                    hub.queue.append("(")
                }
            }
            
            // Regular and Hyperbolic Trig Functions
            else if ["sin","cos","tan","cot","sec","csc","sinh","cosh","tanh","coth","sech","csch"].contains(button) {
                
                // Queue the function
                hub.queue.append(button)
                
                // Queue parentheses if indicated
                if pressType == "hold" || (self.settings.autoParFunction && hub.addBeforeQueue.first != "(") {
                    hub.queue.append("(")
                }
            }
                
            // Inverse and Hyperbolic Inverse Trig Functions
            else if ["sin⁻¹","cos⁻¹","tan⁻¹","cot⁻¹","sec⁻¹","csc⁻¹","sinh⁻¹","cosh⁻¹","tanh⁻¹","coth⁻¹","sech⁻¹","csch⁻¹"].contains(button) {
                
                // Queue the function
                hub.queue.append(button)
                
                // Queue parentheses
                if pressType == "hold" || (hub.addBeforeQueue.first != "(" || hub.addBeforeQueue.last != ")") {
                    hub.queue.append("(")
                }
            }
                
            // Logarithmic Functions
            else if ["log","ln","log₂","logₓ"].contains(button) {
                
                // Queue a logarithm
                hub.queue.append("log")
                
                // Queue the base
                
                // For base 10
                if button == "log" {
                    
                    // Queue an invisible 10
                    hub.queue.append("#10")
                    
                    // Queue a log base indicator
                    hub.queue.append("¶")
                    
                    // Add parentheses if indicated
                    if pressType == "hold" || (self.settings.autoParFunction && hub.addBeforeQueue.first != "(") {
                        hub.queue.append("(")
                    }
                }
                    
                // For natural log (base e)
                else if button == "ln" {
                    
                    // Queue an e
                    hub.queue.append("#e")
                    
                    // Queue a log base indicator
                    hub.queue.append("¶")
                    
                    // Add parentheses if indicated
                    if pressType == "hold" || (self.settings.autoParFunction && hub.addBeforeQueue.first != "(") {
                        hub.queue.append("(")
                    }
                }
                    
                // For base 2
                else if button == "log₂" {
                    
                    // Queue a 2
                    hub.queue.append("2")
                    
                    // Queue a log base indicator
                    hub.queue.append("¶")
                    
                    // Add parentheses if indicated
                    if pressType == "hold" || (self.settings.autoParFunction && hub.addBeforeQueue.first != "(") {
                        hub.queue.append("(")
                    }
                }
                    
                // For inputted base (x base)
                else if button == "logₓ" {
                    
                    // Allow for the base to be inputted
                    hub.indexingLog = true
                    
                    // Add parentheses if indicated
                    if (self.settings.autoParFunction || pressType == "hold") && hub.addBeforeQueue.isEmpty {
                        hub.indexingLogPar = true
                    }
                    if pressType != "hold" && hub.addBeforeQueue.first == "(" {
                        hub.indexingLogPar = false
                    }
                    
                    // The rest of this happens under Other after the next number is inputted
                    
                }
            }
            
            // Other Functions
            else if ["round","floor","ceil"].contains(button) {
                
                // Queue the function
                hub.queue.append(button)
                
                // Queue parentheses
                if pressType == "hold" || (hub.addBeforeQueue.first != "(" || hub.addBeforeQueue.last != ")") {
                    hub.queue.append("(")
                }
            }
            
            // If added before items, re-add the items
            if !hub.addBeforeQueue.isEmpty {
                if button == "logₓ" && self.settings.autoParFunction && pressType != "hold" && hub.addBeforeQueue.last != ")" {
                    hub.addBeforeQueue = ["("]+hub.addBeforeQueue+[")"]
                }
                else if button == "logₓ" && self.settings.autoParFunction && pressType == "hold" {
                    hub.addBeforeQueue = ["("]+hub.addBeforeQueue
                }
                else if button == "logₓ" && !self.settings.autoParFunction && pressType == "hold" {
                    hub.addBeforeQueue = ["("]+hub.addBeforeQueue
                }
                
                if hub.queue.last == "log" {
                    waitForIndex = true
                    hub.indexingQueue = hub.addBeforeQueue
                }
                else {
                    hub.queue += hub.addBeforeQueue
                }
                hub.addBeforeQueue.removeAll()
                
                // Add another parentheses if needed
                if (button.contains("⁻¹") || (self.settings.autoParFunction && button != "| |" && button != "logₓ") || ["round","floor","ceil"].contains(button) ) && hub.queue.last != ")" && pressType != "hold" {
                    hub.queue.append(")")
                }
            }
            
            // Print the queue
            print(hub.queue)
        }
        
        
        // MARK: Grouping Symbols
        // Grouping Symbols type contains parentheses and brackets
        if type == "groupingSymbols" {
            
            // When a grouping symbols button is pressed, it means the previous num is complete and so it can be queued
            // Then, different processes are executed depending on which button was pressed
            
            // If result is currently showing, continue from previous result
            if resultShowing {
                hub.queue = afterResult(keepResult: true)
            }
            
            // Queue the parentheses at the very beginning of the queue if it was held
            if pressType == "hold" && button == "(" {
                hub.queue.insert(button, at: 0)
            }
            else {
                
                // If the num is -0, queue multiplication by negative
                if hub.num == "-0" && button == "(" {
                    
                    // Add parentheses if necessary
                    if hub.queue.last == "^" || (hub.indexingRoot && hub.queue.last == "§") || (hub.indexingLog && hub.queue.last == "log") {
                        hub.queue += ["("]
                    }
                    
                    hub.num = ""
                    hub.queue += ["-01"]
                    hub.queue += ["*"]
                }
                
                // Queue the previous number
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a multiplication operator before the opening parenthesis if no other operator was specified
                if button == "(" {
                    var addMult = true
                    if hub.queue.count > 0 {
                        for op in hub.operators+hub.operators2+["(","§","¶","E","P","C","xb"]+hub.functions {
                            // If another operator or function already is present, do not add
                            if hub.queue[hub.queue.count-1] == op {
                                addMult = false
                            }
                        }
                    }
                    else {
                        addMult = false
                    }
                    if addMult == true {
                        hub.queue.append("#×")
                    }
                }
                
                // Queue the parenthesis
                hub.queue.append(button)
            }
            
            // Print the queue
            print(hub.queue)
        }
        
        // Update any indexing
        updateIndexing(button)
        
    
        // Control type contains clear, backspace, and enter
        if type == "control" {
            
            // MARK: Clear
            if button == "C" {
                
                // When clear is tapped, everything is cleared
                
                // If resultShowing, make it the prev output
                if hub.mainOutput != ["0"] && resultShowing {
                    
                    // Set top output to previous main output
                    hub.topOutput = hub.mainOutput
                    hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
                    
                    // Set the prev output to the main output
                    hub.prevOutput = hub.mainOutput
                }
                else {
                    // Set both outputs to nothing
                    hub.topOutput = exp.splitExpression(" ")
                    hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
                    
                    hub.prevOutput = exp.splitExpression(" ")
                }
                
                // Reset main output
                hub.mainOutput = exp.splitExpression("0")
                hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
                
                // Reset bottom output
                hub.bottomOutput = exp.splitExpression(" ")
                hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
                
                // Clear everything
                clear()
                hub.currentCalc = -1
                
                // Create the expression
                expression = exp.createExpression(hub.queue)
                
                // Output the expression
                hub.mainOutput = exp.splitExpression(expression)
                hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
                
            }
            
            // MARK: Backspace
            if button == "⭠" {
                
                // When backspace is tapped, the last action is undone
                if resultShowing || (hub.backspaceQueue.count == 1 && hub.backspaceNum.count == 1) {
                    
                    // Print backspace
                    print("(Backspace)")
                    
                    // Go back to the previous input
                    prevInput(backspaceOnly: true)
                }
                else if hub.backspaceQueue.count > 1 && hub.backspaceNum.count > 1 {
                    
                    // Print backspace
                    print("(Backspace)")
                    
                    // Set the queue to the last item in the backspace queue
                    hub.backspaceQueue.removeLast()
                    hub.backspaceNum.removeLast()
                    hub.backspaceIndexingQueue.removeLast()
                    
                    hub.queue = hub.backspaceQueue.last!
                    hub.num = hub.backspaceNum.last!
                    
                    // Print the queue
                    print(hub.queue)
                    
                    // Modify root or log or base index
                    var startRoot = 0
                    var endRoot = 0
                    for item in hub.queue {
                        if item == "§" {
                            startRoot += 1
                        }
                        else if item == "√" {
                            endRoot += 1
                        }
                    }
                    if startRoot <= endRoot {
                        hub.indexingRoot = false
                    }
                    
                    var startLog = 0
                    var endLog = 0
                    for item in hub.queue {
                        if item == "log" {
                            startLog += 1
                        }
                        else if item == "¶" {
                            endLog += 1
                        }
                    }
                    if startLog <= endLog {
                        hub.indexingLog = false
                    }
                    
                    var startBase = 0
                    var endBase = 0
                    for item in hub.queue {
                        if item == "xb" {
                            startBase += 1
                        }
                        else if item == "^" {
                            endBase += 1
                        }
                    }
                    if startBase <= endBase {
                        hub.indexingBase = false
                    }
                    
                    // Reset indexing queue to how it was at the backspaced point
                    if !hub.backspaceIndexingQueue.isEmpty {
                        hub.indexingQueue = hub.backspaceIndexingQueue[hub.backspaceIndexingQueue.count-1]
                    }
                    
                    // Re-enter if possible
                    reEnterIndex("§")
                    reEnterIndex("log")
                    reEnterIndex("xb")
                }
                else {
                    clear()
                }
                
                // Remove
                if hub.queue.last == "" {
                    hub.queue.removeLast()
                }
                
                closeParNext = false
                
                // Create the expression
                expression = exp.createExpression(hub.queue)
                
                // Set mainOutput to the expression
                hub.mainOutput = exp.splitExpression(expression)
                hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
                
                // Set topOutput to the previous output
                hub.topOutput = hub.prevOutput
                hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
            }
            
            // MARK: Enter
            if button == "=" {
                
                // Print enter
                print("(Enter)")
                
                // When enter is pressed, it means the previous num is complete and so it can be queued to finalize the queue
                // Then, the result is calculated using the queue
                
                // If result is currently showing, return
                if resultShowing {
                    return
                }
                
                // Queue the previous num
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Add final parentheses
                finalPar()
                
                // Replace final parentheses with real parentheses
                var parIndex = 0
                while parIndex < hub.queue.count {
                    if hub.queue[parIndex] == "﹚" {
                        hub.queue[parIndex] = ")"
                    }
                    parIndex += 1
                }
                
                // End any indexing
                updateIndexing(button)
                endIndexing()
                
                // Replace final parentheses with real parentheses
                parIndex = 0
                while parIndex < hub.queue.count {
                    if hub.queue[parIndex] == "﹚" {
                        hub.queue[parIndex] = ")"
                    }
                    parIndex += 1
                }
                
                // Print the queue
                print(hub.queue)
                
                // If queue contains nothing, return
                if hub.queue.isEmpty {
                    return
                }
                    
                // Perform the operations
                hub.result = calculate.operate(queue: hub.queue, main: true)
                
                // Create the final expression for the result
                finalExpression = exp.createExpression(hub.result)
                
                // Create the expression
                expression = exp.createExpression(hub.queue)
                
                // Set topOutput to the expression
                hub.topOutput = exp.splitExpression(expression + " =")
                hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
                
                // Add commas to the final expression
                finalExpression = exp.addCommas(finalExpression)
                
                // Set mainOutput to the final expression
                hub.mainOutput = exp.splitExpression(finalExpression)
                hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
                
                // Set bottomOutput to the extra message if there is one
                hub.bottomOutput = exp.splitExpression(hub.extraMessage)
                hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
                
                // Set previous output to the current expression
                hub.prevOutput = exp.splitExpression(expression)
                
                // Create a calculation object with the calculation's data
                calc.createCalculation()
                
                // Mark that a result is showing, for when the next button is pressed
                resultShowing = true
                
                // Clear the steps queue and backspace queues
                hub.stepsQueue.removeAll()
                hub.stepsExpressions.removeAll()
                hub.backspaceQueue.removeAll()
                hub.backspaceNum.removeAll()
                hub.backspaceIndexingQueue.removeAll()
                
                // Reset the queue
                hub.queue.removeAll()
            }
        }
        else {
            // If another button was pressed besides enter or clear, the expression is created here
            
            // Add final parentheses
            finalPar()
            
            // Create the expression
            expression = exp.createExpression(hub.queue)
            
            // Set topOutput to the previous output
            hub.topOutput = hub.prevOutput
            hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
            
            // Set mainOutput to the expression
            hub.mainOutput = exp.splitExpression(expression)
            hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
            
            // Set bottomOutput to the extra message if there is one
            hub.bottomOutput = exp.splitExpression(hub.extraMessage)
            hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
            
            if record {
                // Add anything to backspaceIndexingQueue
                while hub.backspaceQueue.count > hub.backspaceIndexingQueue.count {
                    hub.backspaceIndexingQueue += [[]]
                }
                
                // Add current queue to backspace queue
                hub.backspaceQueue += [hub.queue]
                hub.backspaceNum += [hub.num]
                hub.backspaceIndexingQueue += [hub.indexingQueue]
            }
        }
        
        // Remove final par
        while hub.queue.last == "﹚" {
            hub.queue.removeLast()
        }
        while hub.indexingQueue.last == "﹚" {
            hub.indexingQueue.removeLast()
        }
        
        // Disable buttons
        disableButtons()
    }
    
    
    // MARK: - Queueing Assistance
    
    // Clear
    // Clear all data
    func clear() {
        
        // Print clear
        print("(Clear)")
        
        hub.queue = []
        hub.result = []
        hub.results = []
        hub.addBeforeQueue = []
        hub.indexingQueue = []
        hub.stepsQueue = []
        hub.stepsExpressions = []
        hub.backspaceQueue = []
        hub.backspaceNum = []
        hub.backspaceIndexingQueue = []
        hub.num = ""
        expression = ""
        finalExpression = ""
        hub.extraMessage = " "
        resultShowing = false
        hub.indexingRoot = false
        hub.indexingLog = false
        hub.indexingBase = false
        hub.indexingRootPar = false
        hub.indexingLogPar = false
        hub.indexingBasePar = false
        waitForIndex = false
        closeParNext = false
        hub.error = false
    }
    
    
    // Disable Buttons
    // Disables buttons based on what is entered in the queue
    func disableButtons() {
        
        // Disable closed parentheses if it has no opening partner
        // Find the number of parentheses in the queue
        var openPar = 0
        var closePar = 0
        for item in hub.queue {
            if item == "(" {
                openPar += 1
            }
            else if item == ")" {
                closePar += 1
            }
        }
        // Disable closed parentheses if every parenthesis has a partner
        if closePar >= openPar {
            hub.disabledButtons += [")"]
        }
        // Disable repeaters if there is no num or no decimal in it
        hub.disabledButtons += [" ̅"]
        var checkRepeaters = ""
        if !hub.num.isEmpty && hub.num.contains(".") {
            checkRepeaters = hub.num
        }
        else if !hub.queue.isEmpty && hub.queue[hub.queue.count-1].contains(".") {
            checkRepeaters = hub.queue[hub.queue.count-1]
        }
        if checkRepeaters != "" {
            var index = exp.stringCharIndex(string: checkRepeaters, character: ".", position: "first")
            var places = 0
            var repeaters = 0
            while index < checkRepeaters.count {
                let item = String(exp.stringCharGet(string: checkRepeaters, index: index))
                if Int(item) != nil {
                    places += 1
                }
                else if item == " ̅" {
                    repeaters += 1
                }
                index += 1
            }
            if places > repeaters {
                hub.disabledButtons.removeLast()
            }
        }
        
        if !hub.queue.isEmpty {
            
            // Disable operators and closed parentheses if the last item in the queue is an open parenthesis
            if hub.queue[hub.queue.count-1] == "(" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^2","^3","^-1","^","EXP","nPr","nCr",")"]
            }
            
            // Disable closed parentheses if an operator or function is last in the queue and there is no num
            for op in hub.operators+hub.operators2+hub.functions+["§","¶","E","P","C","xb"] {
                if hub.queue[hub.queue.count-1] == op && hub.num.isEmpty {
                    hub.disabledButtons += [")"]
                }
            }
            
            // Auto par operators and functions if a fraction bar is the last item in the queue
            if hub.queue[hub.queue.count-1] == "/" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^","^2","^3","^-1","EXP","nPr","nCr"]
                hub.autoParButtons += hub.functions+["√","³√","ˣ√","10^","2^","e^","x^"]
            }
            
            // Disable exponents if num is empty and the last queued item is not a closed parenthesis nor another number
            var containsNum = false
            for num in hub.numbers+hub.numbers2+hub.numberMods {
                if hub.queue[hub.queue.count-1].contains(num) {
                    containsNum = true
                }
            }
            if hub.num.isEmpty && hub.queue[hub.queue.count-1] != ")" && !containsNum {
                hub.disabledButtons += ["^2","^3","^-1","^","EXP","nPr","nCr"]
            }
            
            // Disable percents and factorials if an operator, function, or open par is last
            if hub.num.isEmpty && (hub.operators+hub.operators2+hub.functions+["§","¶","(","E","P","C","xb"]).contains(hub.queue[hub.queue.count-1]) {
                hub.disabledButtons += ["%","!"]
            }
            
            // Disable ^, and auto par all base ^, roots and operators if the last item in the queue is a single carrot
            if hub.queue[hub.queue.count-1] == "^" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^","^2","^3","^-1","EXP","nPr","nCr"]
                hub.autoParButtons += ["√","³√","ˣ√"]
            }
            
            // Disable all operators and auto par roots if last item in the queue is a root
            if hub.queue[hub.queue.count-1] == "√" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^2","^3","^-1","^","EXP","nPr","nCr",")"]
                hub.autoParButtons += ["√","³√","ˣ√"]
            }
            
            // Disable operators if the last item in the queue is a root index or log or base
            if (hub.queue[hub.queue.count-1] == "§" && hub.indexingRoot && hub.num.isEmpty) || (hub.queue[hub.queue.count-1] == "log" && hub.indexingLog && hub.num.isEmpty) || (hub.queue[hub.queue.count-1] == "xb" && hub.indexingBase && hub.num.isEmpty) {
                hub.disabledButtons += hub.operators
            }
            
            // Disable operators and auto par functions if the last item in the queue is a function
            if hub.functions.contains(hub.queue[hub.queue.count-1]) && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^2","^3","^-1","^","EXP","nPr","nCr"]
                hub.autoParButtons += hub.functions+["√","³√","ˣ√","10^","2^","e^","x^"]
            }
            
            // Disable operators and auto par roots and functions if the last item is an exponential, permutation, or combination
            if ["E","P","C"].contains(hub.queue[hub.queue.count-1]) && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^2","^3","^-1","^","EXP","nPr","nCr"]
                hub.autoParButtons += hub.functions+["√","³√","ˣ√","10^","2^","e^","x^"]
            }
            
            // Auto par functions if the last item in the queue is a root, root index, or carrot
            if ["^","√","§","¶"].contains(hub.queue[hub.queue.count-1]) && hub.num.isEmpty {
                hub.autoParButtons += hub.functions+["10^","2^","e^","x^"]
            }
            
            // Disable operators and exponents and autopar roots and functions if the last item in the queue is a log base identifier
            if hub.queue[hub.queue.count-1] == "¶" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^2","^3","^-1","^","EXP","nPr","nCr"]
                hub.autoParButtons += hub.functions+["√","³√","ˣ√"]
            }
            
            // Auto par operators and functions if a x base is the last item in the queue
            if hub.queue[hub.queue.count-1] == "xb" && hub.num.isEmpty {
                hub.disabledButtons += hub.operators+["^","^2","^3","^-1","EXP","nPr","nCr"]
                hub.autoParButtons += hub.functions+["√","³√","10^","2^","e^"]
            }
            
            // Disable all roots if indexing root
            if hub.indexingRoot && hub.queue.contains("§") {
                var rootIndex = hub.queue.lastIndex(of: "§")!
                if rootIndex == hub.queue.count-1 && hub.num.isEmpty {
                    hub.disabledButtons += ["√","³√","ˣ√","logₓ","x^"]
                }
                else {
                    var openPar = 0
                    var closePar = 0
                    var disableRoots = false
                    while rootIndex < hub.queue.count {
                        let item = hub.queue[rootIndex]
                        if item == "(" {
                            openPar += 1
                        }
                        else if item == ")" {
                            closePar += 1
                        }
                        rootIndex += 1
                    }
                    if openPar != closePar {
                        disableRoots = true
                    }
                    if disableRoots {
                        hub.disabledButtons += ["√","³√","ˣ√","logₓ","x^"]
                    }
                }
            }
            
            // Disable all logs if indexing log
            if hub.indexingLog && hub.queue.contains("log") {
                var logIndex = hub.queue.lastIndex(of: "log")!
                if logIndex == hub.queue.count-1 && hub.num.isEmpty {
                    hub.disabledButtons += ["log","ln","log₂","logₓ","ˣ√","x^"]
                }
                else {
                    var openPar = 0
                    var closePar = 0
                    var disableLogs = false
                    while logIndex < hub.queue.count {
                        let item = hub.queue[logIndex]
                        if item == "(" {
                            openPar += 1
                        }
                        else if item == ")" {
                            closePar += 1
                        }
                        logIndex += 1
                    }
                    if openPar != closePar {
                        disableLogs = true
                    }
                    if disableLogs {
                        hub.disabledButtons += ["log","ln","log₂","logₓ","ˣ√","x^"]
                    }
                }
            }
            
            // Disable all indexers if indexing base
            if hub.indexingBase && hub.queue.contains("xb") {
                var baseIndex = hub.queue.lastIndex(of: "xb")!
                if baseIndex == hub.queue.count-1 && hub.num.isEmpty {
                    hub.disabledButtons += ["ˣ√","logₓ","x^"]
                }
                else {
                    var openPar = 0
                    var closePar = 0
                    var disableBases = false
                    while baseIndex < hub.queue.count {
                        let item = hub.queue[baseIndex]
                        if item == "(" {
                            openPar += 1
                        }
                        else if item == ")" {
                            closePar += 1
                        }
                        baseIndex += 1
                    }
                    if openPar != closePar {
                        disableBases = true
                    }
                    if disableBases {
                        hub.disabledButtons += ["ˣ√","logₓ","x^"]
                    }
                }
            }
        }
        
        // See if something can be inserted
        canInsert = false
        
        if hub.num.isEmpty {
            if hub.queue.isEmpty {
                if !resultShowing {
                    canInsert = true
                }
            }
            else {
                for item in hub.operators+hub.operators2+hub.functions+["(","§","¶","E","P","C","xb"] {
                    if hub.queue.last!.contains(item) {
                        canInsert = true
                    }
                }
            }
        }
    }
    
    
    // Queue Num
    // Queue the previous num
    func queueNum(addToZero: Bool, removeOp: Bool, endIndex: Bool, closePar: Bool) {
        
        // addToZero means if there is no num, zero will be queued first, and the input will be added after
        // removeOp means the previous operator will be removed and replaced with the input
        // endIndex means if the num was in a root index or log index, it will be ended before the newly inputted button is added
        
        // If the queue is empty and no num is being added
        if addToZero && hub.num == "" && hub.queue.isEmpty {
            
            // Queue a zero
            hub.queue.append("0")
        }
            
        // If the queue is not empty and no num is being added
        else if hub.num == "" && !hub.queue.isEmpty {
            
            // Remove the last item in the queue if it is an operator - if it was indicated in the call
            if removeOp {
                for op in hub.operators {
                    if hub.queue[hub.queue.count-1] == op {
                        hub.queue.removeLast()
                    }
                }
            }
        }
            
        // If there is a num
        else if hub.num != "" {
            
            // Queue the completed num and reset it
            hub.queue.append(hub.num)
            hub.num = ""

            // End indexing if possible
            if endIndex {
                endIndexing()
            }
        }
    }
    
    
    // Negate
    func negate(_ string: String) -> String {
        
        // Create a new string to negate
        var negation = string
        
        // Make sure the string being negated contains a number
        var containsNum = false
        for num in hub.numbers+hub.numbers2 {
            if string.contains(num) {
                containsNum = true
            }
        }
        if string.isEmpty {
            containsNum = true
        }
        // If not, return the string before negating it
        if containsNum == false {
            return string
        }
            
        // If string does not start with minus
        if negation.first != "-" {
            
            // Add a zero if the string is empty
            if negation.isEmpty {
                negation.insert("0", at: negation.startIndex)
            }
            
            // Add a minus at the beginning
            negation.insert("-", at: negation.startIndex)
        }
            
        // If string starts with minus
        else {
            
            // Remove the minus
            negation.removeFirst()
        }
        
        // Return negated string
        return negation
        
    }
    
    
    // Final Par
    // Add final parentheses
    func finalPar() {
        
        var parentheses = 0
        var iParentheses = 0
        
        var index = 0
        while index < hub.queue.count {
            
            let item = hub.queue[index]
            
            if item == "(" {
                if hub.indexingRoot && hub.queue.contains("§") {
                    if hub.queue.lastIndex(of: "§")! < index {
                        iParentheses += 1
                    }
                    else {
                        parentheses += 1
                    }
                }
                else if hub.indexingLog && hub.queue.contains("log") {
                    if hub.queue.lastIndex(of: "log")! < index {
                        iParentheses += 1
                    }
                    else {
                        parentheses += 1
                    }
                }
                else if hub.indexingBase && hub.queue.contains("xb") {
                    if hub.queue.lastIndex(of: "xb")! < index {
                        iParentheses += 1
                    }
                    else {
                        parentheses += 1
                    }
                }
                else {
                    parentheses += 1
                }
            }
            else if item == ")" {
                if hub.indexingRoot && hub.queue.contains("§") {
                    if hub.queue.lastIndex(of: "§")! < index {
                        iParentheses -= 1
                    }
                    else {
                        parentheses -= 1
                    }
                }
                else if hub.indexingLog && hub.queue.contains("log") {
                    if hub.queue.lastIndex(of: "log")! < index {
                        iParentheses -= 1
                    }
                    else {
                        parentheses -= 1
                    }
                }
                else if hub.indexingBase && hub.queue.contains("xb") {
                    if hub.queue.lastIndex(of: "xb")! < index {
                        iParentheses -= 1
                    }
                    else {
                        parentheses -= 1
                    }
                }
                else {
                    parentheses -= 1
                }
            }
            
            index += 1
        }
        
        if !hub.indexingRoot && !hub.indexingLog && !hub.indexingBase {
            while parentheses > 0 {
                hub.queue.append("﹚")
                parentheses -= 1
            }
        }
        else {
            while parentheses > 0 {
                hub.indexingQueue.append("﹚")
                parentheses -= 1
            }
            while iParentheses > 0 {
                hub.queue.append("﹚")
                iParentheses -= 1
            }
        }
        
        var jParentheses = 0
        
        index = 0
        while index < hub.indexingQueue.count {
            
            let item = hub.indexingQueue[index]
            
            if item == "(" {
                jParentheses += 1
            }
            else if item == ")" || item == "﹚" {
                jParentheses -= 1
            }
            
            index += 1
        }
        while jParentheses > 0 {
            hub.indexingQueue.append("﹚")
            jParentheses -= 1
        }
        
        
        index = 0
        while index < hub.queue.count {
            let item = hub.queue[index]
            if item == "#×" {
                var afterClosePar = false
                if index-1 >= 0 {
                    if hub.queue[index-1] == ")" {
                        afterClosePar = true
                    }
                }
                if index+1 < hub.queue.count && !afterClosePar {
                    let next = hub.queue[index+1]
                    if !(hub.functions+hub.operators+hub.operators2+["§","(","01"]).contains(next) {
                        hub.queue[index] = "×"
                    }
                }
            }
            index += 1
        }
    }
    
    
    // After Result
    // Button presses while result is being displayed
    func afterResult(keepResult: Bool) -> Array<String> {
        
        // keepResult means the result from the previous calculation will be kept and further operated on
        
        // Only proceed if result was not an error nor infinity
        guard hub.result != ["Error"] && hub.result != ["∞"] else {
            // Clear and return nothing
            clear()
            return []
        }
        
        // Create a start value for num
        var startValue = [String]()
        
        // If the result is being kept, set the start value to it
        if keepResult {
            print("[Reset] Continuing from previous result")
            
            // Set the start value to the previous final result
            startValue += hub.result
            
            // Set the last calculation to result continuing
            if calc.calculations.last != nil {
                calc.calculations.last!.resultContinues = true
            }
            
            // Add resultQueue to backspaceQueue
            hub.backspaceQueue += [hub.result]
            
            // Set the previous output to the expression
            hub.prevOutput = exp.splitExpression(expression)
        }
            
        // If the result is not being kept, start over
        else {
            print("[Reset] Starting over")
            
            // Set the previous output to the previous final expression
            hub.prevOutput = exp.splitExpression(finalExpression)
        }
        
        // Clear the backspace queue, and add the startValue to it
        hub.backspaceQueue = []
        hub.backspaceNum = []
        if startValue != [""] {
            
            hub.backspaceQueue += [startValue]
        }
        for _ in hub.backspaceQueue {
            hub.backspaceNum += [""]
        }
        
        // Set extraMessage to any extra alternate result for the start value
        hub.bottomOutput = [" "]
        
        // Clear queue, expression, resultQueue, and num
        hub.queue.removeAll()
        expression = ""
        hub.num = ""
        
        resultShowing = false
        
        return startValue
    }
    
    
    // MARK: - Edit Queue
    
    // Add Button Before
    // Add button before - allow things to be added before numbers and parentheses
    func addButtonBefore(button: String, doNotPar: Bool = false) {
        
        // Remove everything from add before
        hub.addBeforeQueue = []
        
        // Add everything which the inputted item should be added before
        if !hub.queue.isEmpty || !hub.num.isEmpty {
            
            if !hub.num.isEmpty {
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
            }
            
            guard !hub.queue.isEmpty else {
                return
            }
            
            var containsNum = false
            for num in hub.numbers+hub.numbers2 {
                if hub.queue.last!.contains(num) {
                    containsNum = true
                }
            }
            if containsNum {
                
                hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                hub.queue.removeLast()
                
                while hub.queue.last == "*" || hub.queue.last == "/" {
                    
                    hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                    hub.queue.removeLast()
                    
                    if !hub.queue.isEmpty {
                        containsNum = false
                        for num in hub.numbers+hub.numbers2 {
                            if hub.queue.last!.contains(num) {
                                containsNum = true
                            }
                        }
                        if containsNum {
                            hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                            hub.queue.removeLast()
                        }
                        
                        if hub.queue.last == ")" {
                            
                            var parIndex = hub.queue.lastIndex(of: ")")!
                            var skipParentheses = 0
                            var count = 0
                            
                            while parIndex >= 0 {
                                let item = hub.queue[parIndex]
                                count += 1
                                
                                hub.addBeforeQueue.insert(item, at: 0)
                                
                                if item == ")" {
                                    skipParentheses += 1
                                }
                                else if item == "(" {
                                    skipParentheses -= 1
                                }
                                
                                var containsNum = false
                                for num in hub.numbers+hub.numbers2 {
                                    if item.contains(num) {
                                        containsNum = true
                                    }
                                }
                                
                                var coeffLast = false
                                var fracLast = false
                                if parIndex-1 >= 0 {
                                    if hub.queue[parIndex-1] == "*" {
                                        coeffLast = true
                                    }
                                    else if hub.queue[parIndex-1] == "/" {
                                        fracLast = true
                                    }
                                }
                                
                                if skipParentheses == 0 && !coeffLast && !fracLast {
                                    if item == "(" {
                                        break
                                    }
                                    else if containsNum {
                                        break
                                    }
                                }
                                
                                parIndex -= 1
                            }
                            
                            for _ in 0..<count {
                                hub.queue.removeLast()
                            }
                        }
                    }
                    
                    var stopPar = false
                    if hub.queue.last != nil {
                        if (hub.operators2+hub.functions).contains(hub.queue.last!) {
                            stopPar = true
                        }
                    }
                    if ["^","√"].contains(button) && !["E","P","C","*","/"].contains(hub.queue.last ?? "") && !stopPar && !doNotPar {
                        hub.addBeforeQueue.insert("(", at: 0)
                        hub.addBeforeQueue.append(")")
                    }
                }
            }
            
            if hub.queue.last == ")" {
                
                var parIndex = hub.queue.lastIndex(of: ")")!
                var skipParentheses = 0
                var count = 0
                
                while parIndex >= 0 {
                    let item = hub.queue[parIndex]
                    count += 1
                    
                    hub.addBeforeQueue.insert(item, at: 0)
                    
                    if item == ")" {
                        skipParentheses += 1
                    }
                    else if item == "(" {
                        skipParentheses -= 1
                    }
                    
                    var containsNum = false
                    for num in hub.numbers+hub.numbers2 {
                        if item.contains(num) {
                            containsNum = true
                        }
                    }
                    
                    var coeffLast = false
                    var fracLast = false
                    if parIndex-1 >= 0 {
                        if hub.queue[parIndex-1] == "*" {
                            coeffLast = true
                        }
                        else if hub.queue[parIndex-1] == "/" {
                            fracLast = true
                        }
                    }
                    
                    if skipParentheses == 0 && !coeffLast && !fracLast {
                        if item == "(" {
                            break
                        }
                        else if containsNum {
                            break
                        }
                    }
                    
                    parIndex -= 1
                }
                
                for _ in 0..<count {
                    hub.queue.removeLast()
                }
            }
            
            if hub.queue.last == "^" {
                
                hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                hub.queue.removeLast()
                
                var containsNum = false
                for num in hub.numbers+hub.numbers2 {
                    if hub.queue.last!.contains(num) {
                        containsNum = true
                    }
                }
                if containsNum {
                    
                    hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                    hub.queue.removeLast()
                    
                    if hub.queue.count >= 2 {
                        if hub.queue[hub.queue.count-1] == "*" {
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                        }
                    }
                    
                    if !doNotPar {
                        hub.addBeforeQueue.insert("(", at: 0)
                        hub.addBeforeQueue.append(")")
                    }
                }
                
                if hub.queue.last == ")" {
                    
                    var parIndex = hub.queue.lastIndex(of: ")")!
                    var skipParentheses = 0
                    var count = 0
                    
                    while parIndex >= 0 {
                        let item = hub.queue[parIndex]
                        count += 1
                        
                        hub.addBeforeQueue.insert(item, at: 0)
                        
                        if item == ")" {
                            skipParentheses += 1
                        }
                        else if item == "(" {
                            skipParentheses -= 1
                        }
                        
                        var containsNum = false
                        for num in hub.numbers+hub.numbers2 {
                            if item.contains(num) {
                                containsNum = true
                            }
                        }
                        
                        var coeffLast = false
                        var fracLast = false
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                coeffLast = true
                            }
                            else if hub.queue[parIndex-1] == "/" {
                                fracLast = true
                            }
                        }
                        
                        if skipParentheses == 0 && !coeffLast && !fracLast {
                            if item == "(" {
                                break
                            }
                            else if containsNum {
                                break
                            }
                        }
                        
                        parIndex -= 1
                    }
                    
                    for _ in 0..<count {
                        hub.queue.removeLast()
                    }
                    
                    if !doNotPar {
                        hub.addBeforeQueue.insert("(", at: 0)
                        hub.addBeforeQueue.append(")")
                    }
                }
            }
            
            if ["E","P","C"].contains(hub.queue.last ?? "") {
                
                hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                hub.queue.removeLast()
                
                var containsNum = false
                for num in hub.numbers+hub.numbers2 {
                    if hub.queue.last!.contains(num) {
                        containsNum = true
                    }
                }
                if containsNum {
                    
                    hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                    hub.queue.removeLast()
                    
                    if hub.queue.count >= 2 {
                        if hub.queue[hub.queue.count-1] == "*" {
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                        }
                    }
                    
                    if !doNotPar {
                        hub.addBeforeQueue.insert("(", at: 0)
                        hub.addBeforeQueue.append(")")
                    }
                }
                
                if hub.queue.last == ")" {
                    
                    var parIndex = hub.queue.lastIndex(of: ")")!
                    var skipParentheses = 0
                    var count = 0
                    
                    while parIndex >= 0 {
                        let item = hub.queue[parIndex]
                        count += 1
                        
                        hub.addBeforeQueue.insert(item, at: 0)
                        
                        if item == ")" {
                            skipParentheses += 1
                        }
                        else if item == "(" {
                            skipParentheses -= 1
                        }
                        
                        var containsNum = false
                        for num in hub.numbers+hub.numbers2 {
                            if item.contains(num) {
                                containsNum = true
                            }
                        }
                        
                        var coeffLast = false
                        var fracLast = false
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                coeffLast = true
                            }
                            else if hub.queue[parIndex-1] == "/" {
                                fracLast = true
                            }
                        }
                        
                        if skipParentheses == 0 && !coeffLast && !fracLast {
                            if item == "(" {
                                break
                            }
                            else if containsNum {
                                break
                            }
                        }
                        
                        parIndex -= 1
                    }
                    
                    for _ in 0..<count {
                        hub.queue.removeLast()
                    }
                    
                    if !doNotPar {
                        hub.addBeforeQueue.insert("(", at: 0)
                        hub.addBeforeQueue.append(")")
                    }
                }
            }
            
            if hub.queue.last == ")" {
                
                var parIndex = hub.queue.lastIndex(of: ")")!
                var skipParentheses = 0
                var count = 0
                
                while parIndex >= 0 {
                    let item = hub.queue[parIndex]
                    count += 1
                    
                    hub.addBeforeQueue.insert(item, at: 0)
                    
                    if item == ")" {
                        skipParentheses += 1
                    }
                    else if item == "(" {
                        skipParentheses -= 1
                    }
                    
                    var containsNum = false
                    for num in hub.numbers+hub.numbers2 {
                        if item.contains(num) {
                            containsNum = true
                        }
                    }
                    
                    var coeffLast = false
                    var fracLast = false
                    if parIndex-1 >= 0 {
                        if hub.queue[parIndex-1] == "*" {
                            coeffLast = true
                        }
                        else if hub.queue[parIndex-1] == "/" {
                            fracLast = true
                        }
                    }
                    
                    if skipParentheses == 0 && !coeffLast && !fracLast {
                        if item == "(" {
                            break
                        }
                        else if containsNum {
                            break
                        }
                    }
                    
                    parIndex -= 1
                }
                
                for _ in 0..<count {
                    hub.queue.removeLast()
                }
            }
            
            if hub.queue.last == "*" {
                
                hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                hub.queue.removeLast()
                
                var containsNum = false
                for num in hub.numbers+hub.numbers2 {
                    if hub.queue.last!.contains(num) {
                        containsNum = true
                    }
                }
                if containsNum {
                    
                    hub.addBeforeQueue.insert(hub.queue.last!, at: 0)
                    hub.queue.removeLast()
                    
                    if hub.queue.count >= 2 {
                        if hub.queue[hub.queue.count-1] == "*" {
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                            hub.addBeforeQueue.insert(hub.queue[hub.queue.count-1], at: 0)
                            hub.queue.removeLast()
                        }
                    }
                }
                
                if !doNotPar {
                    hub.addBeforeQueue.insert("(", at: 0)
                    hub.addBeforeQueue.append(")")
                }
            }
        }
        
        // If the last item in the queue is now something requiring the entire thing to be edited, add parentheses
        if (hub.operators2+hub.functions+["¶","E","P","C"]).contains(hub.queue.last) {
            var index = hub.queue.count-1
            
            var skipParentheses = 0
            while index >= 0 {
                
                let item = hub.queue[index]
                
                hub.addBeforeQueue.insert(item, at: 0)
                hub.queue.removeLast()
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                if skipParentheses == 0 && (hub.functions+["§"]).contains(item) {
                    break
                }
                
                index -= 1
            }
            
            if !doNotPar {
                hub.addBeforeQueue.insert("(", at: 0)
                hub.addBeforeQueue.append(")")
            }
        }
    }
    
    
    // Put Into Par
    // Insert a par before the newest term
    func putIntoPar(before: String, closeNext: Bool) {
        
        var addPar = true
        var index = 0
        
        if hub.queue.isEmpty {
            addPar = false
            return
        }
        
        if before == "^" || before == "/" {
            
            index = hub.queue.count-1
            var skipParentheses = 0
            while index >= 0 {
                
                let item = hub.queue[index]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                if index == 0 && item == "(" {
                    addPar = false
                    break
                }
                
                else if skipParentheses == 0 {
                    
                    if before == "/" && item == "#×" {
                        break
                    }
                    
                    if (hub.operators2+["§","E","P","C","xb","log"]).contains(item) {
                        break
                    }
                    
                    if (hub.operators+hub.functions+["¶"]).contains(item) {
                        addPar = false
                        break
                    }
                    
                    if index == 0 {
                        addPar = false
                        break
                    }
                }
                    
                else if skipParentheses < 0 && item == "(" {
                    addPar = false
                    break
                }
                
                index -= 1
            }
            
            if before == "^" && hub.queue.contains("xb") {
                let xbIndex = hub.queue.lastIndex(of: "xb")!
                if xbIndex+1 < hub.queue.count {
                    if hub.queue[xbIndex+1] == "(" {
                        addPar = false
                    }
                }
            }
            
            index += 1
            if index >= hub.queue.count {
                index = hub.queue.count-1
            }
            if index < 0 {
                addPar = false
            }
        }
        
        else if ["E","P","C"].contains(before) {
            
            index = hub.queue.count-1
            var skipParentheses = 0
            while index >= 0 {
                
                let item = hub.queue[index]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                if index == 0 && (item == "(" || item == "01") {
                    addPar = false
                    break
                }
                
                else if skipParentheses == 0 {
                    
                    if item == "/" || item == "÷" || item == "#×" {
                        break
                    }
                        
                    else if (hub.operators2+hub.functions+["§","¶","E","P","C","xb"]).contains(item) {
                        break
                    }
                    
                    else if (hub.operators).contains(item) {
                        if index-1 >= 0 {
                            if item == "*" && hub.queue[index-1] == "01" {
                            }
                            else {
                                addPar = false
                                break
                            }
                        }
                        else {
                            addPar = false
                            break
                        }
                    }
                }
                    
                else if skipParentheses < 0 && item == "(" {
                    addPar = false
                    break
                }
                
                index -= 1
            }
        }
        
        index += 1
        
        if index <= hub.queue.count && index >= 0 && addPar {
            hub.queue.insert("(", at: index)
            if closeNext {
                closeParNext = true
            }
        }
    }
    
    
    // Add Extra Par
    // Add extra parentheses
    func addExtraPar(before: String) {
        
        var parPower = false
        var parRoot = false
        var parFunction = false
        var parExponential = false
        var parFraction = false
        var parCoefficient = false
        var parNegative = false
        var parPermutation = false
        var parCombination = false
        
        // LOOP: Find a power or a function
        var prevIndex = hub.queue.count-1
        var skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "^" {
                    // Power found
                    parPower = true
                    break
                }
                else if item == "§" {
                    // Root index found
                    parRoot = true
                    break
                }
                else if (hub.functions+["¶"]).contains(item) {
                    // Function found
                    parFunction = true
                    if item == "¶" {
                        var logIndex = prevIndex
                        skipParentheses = 0
                        while logIndex >= 0 {
                            let logItem = hub.queue[logIndex]
                            if item == ")" {
                                skipParentheses += 1
                            }
                            else if item == "(" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == 0 {
                                if logItem == "log" {
                                    prevIndex = logIndex
                                    break
                                }
                            }
                            logIndex -= 1
                        }
                    }
                    break
                }
                else if item == "*" {
                    // Coefficient found - keep going
                }
                else if item == "/" {
                    // Fraction found - keep going
                }
                else if item == "√" {
                    // Radical found - keep going to root index
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found - end
                    break
                }
            }
            else if skipParentheses == -1 {
                break
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around a power
        if parPower {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers+hub.numbers2 {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                var prev = ""
                if parIndex-1 >= 0 {
                    prev = hub.queue[parIndex-1]
                }
                
                if skipParentheses == 0 {
                    if prev == "*" {
                        // If coefficient is last, do nothing
                    }
                    else if item == "(" {
                        // Open par found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                    else if containsNum {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // Add parentheses around a root to a power
        if parRoot {
            var openParIndex = -1
            
            // Find where to add the parentheses
            openParIndex = prevIndex
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // Add parentheses around a function
        if parFunction {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsFunc = false
                for function in hub.functions {
                    if item.contains(function) {
                        containsFunc = true
                    }
                }
                
                if skipParentheses == 0 {
                    if containsFunc {
                        // Function found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find an exponential
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "E" {
                    // Exponential found
                    parExponential = true
                    break
                }
                else if item == "*" {
                    // Coefficient found - keep going
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            else if skipParentheses == -1 {
                break
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around an exponential
        if parExponential {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers+hub.numbers2 {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                
                if skipParentheses == 0 {
                    if item == "(" {
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                // Coefficient, keep going
                            }
                            else {
                                // Open par found, which begins the expression
                                openParIndex = parIndex
                                break
                            }
                        }
                        else {
                            // Open par found, which begins the expression
                            openParIndex = parIndex
                            break
                        }
                    }
                    else if containsNum {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find a permutation
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "P" {
                    // Permutation found
                    parPermutation = true
                    break
                }
                else if item == "*" {
                    // Coefficient found - keep going
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            else if skipParentheses == -1 {
                break
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around a permutation
        if parPermutation {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers+hub.numbers2 {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                
                if skipParentheses == 0 {
                    if item == "(" {
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                // Coefficient, keep going
                            }
                            else {
                                // Open par found, which begins the expression
                                openParIndex = parIndex
                                break
                            }
                        }
                        else {
                            // Open par found, which begins the expression
                            openParIndex = parIndex
                            break
                        }
                    }
                    else if containsNum {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find a combination
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "C" {
                    // Combination found
                    parCombination = true
                    break
                }
                else if item == "*" {
                    // Coefficient found - keep going
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            else if skipParentheses == -1 {
                break
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around a combination
        if parCombination {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers+hub.numbers2 {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                
                if skipParentheses == 0 {
                    if item == "(" {
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                // Coefficient, keep going
                            }
                            else {
                                // Open par found, which begins the expression
                                openParIndex = parIndex
                                break
                            }
                        }
                        else {
                            // Open par found, which begins the expression
                            openParIndex = parIndex
                            break
                        }
                    }
                    else if containsNum {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find a fraction
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "/" {
                    // Fraction found
                    parFraction = true
                    break
                }
                else if item == "*" {
                    // Coefficient found - keep going
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            else if skipParentheses == -1 {
                break
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around a fraction
        if parFraction {
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers+hub.numbers2 {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                
                var coeffLast = false
                var fracLast = false
                if parIndex-1 >= 0 {
                    if hub.queue[parIndex-1] == "*" {
                        coeffLast = true
                    }
                    else if hub.queue[parIndex-1] == "/" {
                        fracLast = true
                    }
                }
                
                if skipParentheses == 0 {
                    if item == "(" && !coeffLast && !fracLast {
                        // Open par found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                    else if item == "*" {
                        // Coefficient found - keep going
                    }
                    else if item == "/" {
                        // Another fraction found - keep going
                    }
                    else if containsNum && !coeffLast && !fracLast {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find a coefficient
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            if skipParentheses == 0 {
                if item == "*" {
                    // Coefficient found
                    parCoefficient = true
                    if prevIndex-1 >= 0 {
                        if hub.queue[prevIndex-1] == "01" {
                            parCoefficient = false
                        }
                    }
                    break
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            
            prevIndex -= 1
        }
        
        var parNegativeCoefficient = false
        if hub.queue.count-3 >= 0 {
            if hub.queue[hub.queue.count-3] == "-01" {
                parNegativeCoefficient = true
            }
        }
        
        // Add parentheses around a coefficient
        if parCoefficient && before != "/" && (before != "^" || parNegativeCoefficient || ["%","!"].contains(hub.queue.last)) {
            
            var openParIndex = -1
            
            // Find where to add the parentheses
            var parIndex = prevIndex
            skipParentheses = 0
            while parIndex >= 0 {
                
                let item = hub.queue[parIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
                var containsNum = false
                for number in hub.numbers {
                    if item.contains(number) {
                        containsNum = true
                    }
                }
                for number in hub.numbers2 {
                    if item == number {
                        containsNum = true
                    }
                }
                
                if skipParentheses == 0 {
                    if item == "(" {
                        if parIndex-1 >= 0 {
                            if hub.queue[parIndex-1] == "*" {
                                // Another coefficient, keep going
                            }
                            else {
                                // Open par found, which begins the expression
                                openParIndex = parIndex
                                break
                            }
                        }
                        else {
                            // Open par found, which begins the expression
                            openParIndex = parIndex
                            break
                        }
                    }
                    else if item == "01" && before != "*" {
                        // Invisible coefficient of 1, do not par
                        break
                    }
                    else if containsNum {
                        // Number found, which begins the expression
                        openParIndex = parIndex
                        break
                    }
                }
                
                parIndex -= 1
            }
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
        
        // LOOP: Find a negative number
        prevIndex = hub.queue.count-1
        skipParentheses = 0
        while prevIndex >= 0 {
            
            parPower = false
            parFunction = false
            parExponential = false
            parFraction = false
            parCoefficient = false
            parNegative = false
            parPermutation = false
            parCombination = false
            
            let item = hub.queue[prevIndex]
            
            if item == ")" {
                skipParentheses += 1
            }
            else if item == "(" {
                skipParentheses -= 1
            }
            
            var containsNeg = false
            for number in hub.numbers {
                if item.contains(number) && item.contains("-") {
                    containsNeg = true
                }
            }
            
            if skipParentheses == 0 {
                if containsNeg {
                    // Negative found
                    parNegative = true
                    break
                }
                else if (hub.operators+hub.operators2).contains(item) {
                    // Other operator found
                    break
                }
            }
            
            prevIndex -= 1
        }
        
        // Add parentheses around a negative number
        if parNegative && !["E","P","C"].contains(before) {
            
            let openParIndex = prevIndex
            
            // Add in the parentheses
            if openParIndex >= 0 {
                
                hub.queue.insert("(", at: openParIndex)
                hub.queue.append(")")
            }
        }
    }
    
    
    // Prev Input
    // Return to the previous inputted expression
    func prevInput(backspaceOnly: Bool) {
        
        // Go back to the input
        if hub.currentCalc-1 < calc.calculations.count && hub.currentCalc-1 >= 0 {
            if resultShowing {
                editCalculation(calculation: calc.calculations[hub.currentCalc])
            }
            else if calc.calculations[hub.currentCalc-1].resultContinues {
                var containsResult = true
                for item in calc.calculations[hub.currentCalc-1].result {
                    if !calc.calculations[hub.currentCalc].queue.contains(item) {
                        containsResult = false
                    }
                }
                if containsResult {
                    editCalculation(calculation: calc.calculations[hub.currentCalc-1])
                }
                else {
                    clear()
                }
            }
            else {
                clear()
            }
        }
        else if hub.currentCalc == -1 && calc.calculations.last != nil {
            if resultShowing {
                editCalculation(calculation: calc.calculations.last!)
            }
            else if calc.calculations.last!.resultContinues && calc.calculations.last!.topOutput.dropLast() == hub.prevOutput {
                editCalculation(calculation: calc.calculations.last!)
            }
            else if !backspaceOnly && hub.prevOutput == calc.calculations.last!.mainOutput {
                insertCalculation(calculation: calc.calculations.last!)
            }
            else {
                clear()
            }
        }
        else {
            clear()
        }
    }
    
    
    // MARK: - Edit Indexing
    
    // Update Indexing
    // Check if indexing root, log, or base can be ended and end it
    func updateIndexing(_ button: String) {
        
        // Inputting xth root
        if hub.indexingRoot && button != "ˣ√" && hub.queue.contains("§") {
            
            // Get the sub-queue from the index indicator to the end
            let xRootQueue = hub.queue[hub.queue.lastIndex(of: "§")!...hub.queue.count-1]
            
            // Count the parentheses in the sub-queue
            var openPar = 0
            var closePar = 0
            for item in xRootQueue {
                if item == "(" {
                    openPar += 1
                }
                else if item == ")" {
                    closePar += 1
                }
            }
            
            // If the index is complete (same number of open and closed parentheses)
            if openPar == closePar && hub.num != "-0" && hub.num != "0." && !waitForIndex {
                
                // xth root index is no longer being inputted
                hub.indexingRoot = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a radical
                hub.queue.append("√")
                
                // Queue a parenthesis if indicated
                if hub.indexingRootPar {
                    hub.queue.append("(")
                    hub.indexingRootPar = false
                }
            }
            // If the index is complete and there is a result too
            else if openPar == closePar && waitForIndex && hub.queue.last == ")" {
                
                // xth root index is no longer being inputted
                hub.indexingRoot = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a radical
                hub.queue.append("√")
                
                // Queue a parenthesis if indicated
                if hub.indexingRootPar {
                    hub.queue.append("(")
                    hub.indexingRootPar = false
                }
                
                // Add the result
                hub.queue += hub.indexingQueue
                
                hub.indexingQueue.removeAll()
                waitForIndex = false
            }
        }
        
        // Inputting xth log base
        if hub.indexingLog && button != "logₓ" && hub.queue.contains("log") {
            
            // Get the sub-queue from the log to the end
            let logBaseQueue = hub.queue[hub.queue.lastIndex(of: "log")!...hub.queue.count-1]
            
            // Count the parentheses in the sub-queue
            var openPar = 0
            var closePar = 0
            for item in logBaseQueue {
                if item == "(" {
                    openPar += 1
                }
                else if item == ")" {
                    closePar += 1
                }
            }
            
            // If the base is complete (same number of open and closed parentheses)
            if openPar == closePar && hub.num != "-0" && hub.num != "0." && !waitForIndex {
                
                // Log base is no longer being inputted
                hub.indexingLog = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a log base indicator
                hub.queue.append("¶")
                
                // Queue a parenthesis if indicated
                if hub.indexingLogPar {
                    hub.queue.append("(")
                    hub.indexingLogPar = false
                }
            }
                // If the index is complete and there is a result too
            else if openPar == closePar && waitForIndex && hub.queue.last == ")" {
                
                // Log base is no longer being inputted
                hub.indexingLog = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a log base indicator
                hub.queue.append("¶")
                
                // Queue a parenthesis if indicated
                if hub.indexingLogPar {
                    hub.queue.append("(")
                    hub.indexingLogPar = false
                }
                
                hub.queue += hub.indexingQueue
                
                hub.indexingQueue.removeAll()
                waitForIndex = false
            }
        }
        
        // Inputting xth base
        if hub.indexingBase && button != "x^" && hub.queue.contains("xb") {
            
            // Get the sub-queue from the index indicator to the end
            let xRootQueue = hub.queue[hub.queue.lastIndex(of: "xb")!...hub.queue.count-1]
            
            // Count the parentheses in the sub-queue
            var openPar = 0
            var closePar = 0
            for item in xRootQueue {
                if item == "(" {
                    openPar += 1
                }
                else if item == ")" {
                    closePar += 1
                }
            }
            
            // If the index is complete (same number of open and closed parentheses)
            if openPar == closePar && hub.num != "-0" && hub.num != "0." && !waitForIndex {
                
                // xth base is no longer being inputted
                hub.indexingBase = false
                
                // Remove the xb
                var xbIndex = 0
                while xbIndex < hub.queue.count {
                    if hub.queue[xbIndex] == "xb" {
                        hub.queue.remove(at: xbIndex)
                    }
                    else {
                        xbIndex += 1
                    }
                }
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a carrot
                hub.queue.append("^")
                
                // Queue a parenthesis if indicated
                if hub.indexingBasePar {
                    hub.queue.append("(")
                    hub.indexingBasePar = false
                }
            }
            // If the index is complete and there is a result too
            else if openPar == closePar && waitForIndex && hub.queue.last == ")" {
                
                // xth base is no longer being inputted
                hub.indexingBase = false
                
                // Remove the xb
                var xbIndex = 0
                while xbIndex < hub.queue.count {
                    if hub.queue[xbIndex] == "xb" {
                        hub.queue.remove(at: xbIndex)
                    }
                    else {
                        xbIndex += 1
                    }
                }
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: true, closePar: true)
                
                // Queue a carrot
                hub.queue.append("^")
                
                // Queue a parenthesis if indicated
                if hub.indexingBasePar {
                    hub.queue.append("(")
                    hub.indexingBasePar = false
                }
                
                // Add the result
                hub.queue += hub.indexingQueue
                
                hub.indexingQueue.removeAll()
                waitForIndex = false
            }
        }
        
        // Remove indexing if done
        if hub.indexingRoot && !hub.queue.contains("§") {
            hub.indexingRoot = false
            waitForIndex = false
            hub.indexingQueue.removeAll()
        }
        if hub.indexingLog && !hub.queue.contains("log") {
            hub.indexingLog = false
            waitForIndex = false
            hub.indexingQueue.removeAll()
        }
        if hub.indexingBase && !hub.queue.contains("xb") {
            hub.indexingBase = false
            waitForIndex = false
            hub.indexingQueue.removeAll()
        }
    }
    
    
    // End Indexing
    // End indexingRoot, indexingLog, or indexingBase
    func endIndexing() {
        
        // Add previous result if indicated
        if waitForIndex {
            
            // Indexing Root Complete
            if hub.indexingRoot {
                
                // Get the index after the indicator
                let indicatorIndex = hub.queue.contains("§") ? hub.queue.lastIndex(of: "§")! : hub.queue.count
                let parIndex = indicatorIndex+1 < hub.queue.count ? indicatorIndex+1 : indicatorIndex
                
                // If the first character in the index is an open par, return
                if hub.queue[parIndex] == "(" {
                    return
                }
                if hub.queue[parIndex] == "-01" {
                    if parIndex+2 < hub.queue.count {
                        if hub.queue[parIndex+1] == "*" && hub.queue[parIndex+2] == "(" {
                            return
                        }
                    }
                }
                
                // xth root index is no longer being inputted
                hub.indexingRoot = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: true)
                
                // Add any parentheses if they are mismatched
                var openPar = 0
                var closePar = 0
                var indexIndex = parIndex
                while indexIndex < hub.queue.count {
                    let item = hub.queue[indexIndex]
                    if item == "(" {
                        openPar += 1
                    }
                    if item == ")" {
                        closePar += 1
                    }
                    indexIndex += 1
                }
                while openPar > closePar {
                    hub.queue.append(")")
                    closePar += 1
                }
                
                // Queue a radical
                hub.queue.append("√")
                
                // Queue a parenthesis if indicated
                if hub.indexingRootPar {
                    hub.queue.append("(")
                    hub.indexingRootPar = false
                }
            }
            // Indexing Log Complete
            else if hub.indexingLog {
                
                // Get the index after the indicator
                let indicatorIndex = hub.queue.contains("log") ? hub.queue.lastIndex(of: "log")! : hub.queue.count
                let parIndex = indicatorIndex+1 < hub.queue.count ? indicatorIndex+1 : indicatorIndex
                
                // If the first character in the index is an open par, return
                if hub.queue[parIndex] == "(" {
                    return
                }
                if hub.queue[parIndex] == "-01" {
                    if parIndex+2 < hub.queue.count {
                        if hub.queue[parIndex+1] == "*" && hub.queue[parIndex+2] == "(" {
                            return
                        }
                    }
                }
                
                // Log base is no longer being inputted
                hub.indexingLog = false
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: true)
                
                // Queue a log base indicator
                hub.queue.append("¶")
                
                // Queue a parenthesis if indicated
                if hub.indexingLogPar {
                    hub.queue.append("(")
                    hub.indexingLogPar = false
                }
            }
            // Indexing Base Complete
            else if hub.indexingBase {
                
                // Get the index after the indicator
                let indicatorIndex = hub.queue.contains("xb") ? hub.queue.lastIndex(of: "xb")! : hub.queue.count
                let parIndex = indicatorIndex+1 < hub.queue.count ? indicatorIndex+1 : indicatorIndex
                
                // If the first character in the index is an open par, return
                if hub.queue[parIndex] == "(" {
                    return
                }
                if hub.queue[parIndex] == "-01" {
                    if parIndex+2 < hub.queue.count {
                        if hub.queue[parIndex+1] == "*" && hub.queue[parIndex+2] == "(" {
                            return
                        }
                    }
                }
                
                // Base is no longer being inputted
                hub.indexingBase = false
                
                // Remove the xb
                var xbIndex = 0
                while xbIndex < hub.queue.count {
                    if hub.queue[xbIndex] == "xb" {
                        hub.queue.remove(at: xbIndex)
                    }
                    else {
                        xbIndex += 1
                    }
                }
                
                // Queue any number not queued
                queueNum(addToZero: false, removeOp: false, endIndex: false, closePar: true)
                
                // Queue a carrot
                hub.queue.append("^")
                
                // Queue a parenthesis if indicated
                if hub.indexingBasePar {
                    hub.queue.append("(")
                    hub.indexingBasePar = false
                }
            }
            
            // Add the result
            hub.queue += hub.indexingQueue
            hub.indexingQueue.removeAll()
            waitForIndex = false
        }
    }
    
    
    // Re-Enter Index
    // Re-enter indexingRoot or indexingRoot
    func reEnterIndex(_ type: String) {
        
        // Re-enter indexingRoot if root comes before any operators
        if ((type == "§" && !hub.indexingRoot) || (type == "log" && !hub.indexingLog) || (type == "xb" && !hub.indexingBase)) && !hub.queue.isEmpty {
            var rootFinderQueue = hub.queue
            
            var openPar = 0
            var closePar = 0
            var index = 0
            if rootFinderQueue.contains(type) {
                index = rootFinderQueue.lastIndex(of: type)!
            }
            while index < rootFinderQueue.count {
                let item = rootFinderQueue[index]
                if item == "(" {
                    openPar += 1
                }
                if item == ")" {
                    closePar += 1
                }
                index += 1
            }
            if openPar > closePar && !hub.num.isEmpty {
                rootFinderQueue += [hub.num]
            }
            while openPar > closePar {
                rootFinderQueue.append(")")
                closePar += 1
            }
            
            var rootFound = false
            var rootIndex = rootFinderQueue.count-1
            var skipParentheses = 0
            
            while rootIndex >= 0 {
                let item = rootFinderQueue[rootIndex]
                
                if item == ")" {
                    skipParentheses += 1
                }
                else if item == "(" {
                    skipParentheses -= 1
                }
                
//                var containsNum = false
//                for num in hub.numbers+hub.numbers2 {
//                    if item.contains(num) {
//                        containsNum = true
//                    }
//                }
                
                if skipParentheses == 0 {
                    
                    if item == type {
                        // Root index or log found
                        rootFound = true
                        break
                    }
                    else if (hub.operators+hub.operators2+["¶"]).contains(item) && item != "/" {
                        // Other operator found
                        break
                    }
//                    else if containsNum {
//                        // Number found
//                        break
//                    }
                }
                
                rootIndex -= 1
            }
            if rootFound {
                if type == "§" {
                    hub.indexingRoot = true
                }
                else if type == "log" {
                    hub.indexingLog = true
                }
                else if type == "xb" {
                    hub.indexingBase = true
                }
                
                if !hub.indexingQueue.isEmpty {
                    waitForIndex = true
                }
            }
        }
    }
    
    
    // MARK: - Switch Results
    
    // Swap Alternate Results
    // Swap between main result and other result
    func swapAlternateResults(calculation: Calculation) {
        
        if calc.calculations.isEmpty {
            return
        }
        
        if calculation.id == calc.calculations.last!.id {
            
            // If error, explain why
//            if hub.error {
//
//                // Show the error pop up
//                showErrorPopUp = true
//
//                // Set bottomOutput to the extra message if there is one
//                hub.bottomOutput = exp.splitExpression(hub.extraMessage)
//
//                // Wait
//                let seconds = 3.0
//                DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
//
//                    // Stop showing the error pop up
//                    self.showErrorPopUp = false
//
//                    // Set bottomOutput to the extra message if there is one
//                    self.hub.bottomOutput = self.exp.splitExpression(self.hub.extraMessage)
//                }
//            }
            
            // If either result or results is empty, return
            guard !hub.result.isEmpty, !hub.results.isEmpty, hub.result != [" "], hub.results != [[" "]] else {
                return
            }
            
            // Change the result
            if !hub.results.isEmpty {
                let swap = hub.result
                hub.result = hub.results[0]
                hub.results[0] = swap
            }
            
            // Create the final expression for the result
            finalExpression = exp.createExpression(hub.result)
            
            // Add commas to the final expression
            finalExpression = exp.addCommas(finalExpression)
            
            // Set mainOutput to the final expression
            hub.mainOutput = exp.splitExpression(finalExpression)
            
            // Set extraMessage to the extra result
            hub.extraMessage = !hub.results.isEmpty ? exp.createExpression(hub.results.first!) : hub.extraMessage
            
            // Add commas to the extra message
            hub.extraMessage = exp.addCommas(hub.extraMessage)
            
            // Set bottomOutput to the extra message if there is one
            hub.bottomOutput = exp.splitExpression(hub.extraMessage)
            
        }
        
        // Swap the calculation's result queue and extra result queue
        if !calculation.results.isEmpty {
            let swap2 = calculation.result
            calculation.result = calculation.results[0]
            calculation.results[0] = swap2
        }
        let swap3 = calculation.mainOutput
        calculation.mainOutput = calculation.bottomOutput
        calculation.bottomOutput = swap3
        
        // Set the formatting guides
        hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
        hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
        calculation.mainFormattingGuide = formatting.createFormattingGuide(array: calculation.mainOutput)
        calculation.bottomFormattingGuide = formatting.createFormattingGuide(array: calculation.bottomOutput)
        
    }
    
    
    // Set Result
    // Set the result to an already completed calculation
    func setResult(calculation: Calculation) {
        
        print("(Calculation) Setting result")
        settings.showCalculations = false
        
        guard calculation.result != ["Error"], calculation.result != ["∞"] else {
            return
        }
        
        // Clear everything
        clear()
        
        // Set the calculation currently displayed
        hub.currentCalc = calculation.id
        
        // Set the queues to the calculation's queues
        hub.queue = calculation.queue
        hub.result = calculation.result
        hub.results = calculation.results
        
        // Create the expression
        expression = exp.createExpression(hub.queue)
        
        // Set topOutput to the expression
        hub.topOutput = exp.splitExpression(expression + " =")
        
        // Create the final expression for the result
        finalExpression = exp.createExpression(hub.result)
        
        // Add commas to the final expression
        finalExpression = exp.addCommas(finalExpression)
        
        // Set mainOutput to the final expression
        hub.mainOutput = exp.splitExpression(finalExpression)
        
        // Set extraMessage to the extra result
        hub.extraMessage = !hub.results.isEmpty ? exp.createExpression(hub.results.first!) : hub.extraMessage
        
        // Set bottomOutput to the extra message if there is one
        hub.bottomOutput = exp.splitExpression(hub.extraMessage)
        
        // Set previous output to the current expression
        hub.prevOutput = exp.splitExpression(expression)
        
        // Set the formatting guides
        hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
        hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
        hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
        
        // Mark that a result is showing, for when the next button is pressed
        resultShowing = true
        
        // Reset the queue
        hub.queue.removeAll()
    }
    
    
    // Edit Calculation
    // Edit the expression of a calculation
    func editCalculation(calculation: Calculation) {
        
        print("(Calculation) Setting calculation input")
        settings.showCalculations = false
        
        // Clear everything
        clear()
        
        // Set the calculation currently displayed
        hub.currentCalc = calculation.id
        
        // Set the queues to the calculation's queues
        hub.queue = calculation.queue
        hub.backspaceQueue = calculation.backspaceQueue
        hub.backspaceNum = calculation.backspaceNum
        hub.backspaceIndexingQueue = calculation.backspaceIndexingQueue
        
        // Create the expression
        expression = exp.createExpression(hub.queue)
        
        // Set mainOutput to the expression
        hub.mainOutput = exp.splitExpression(expression)
        
        // Reset topOutput to the prev output
        if calculation.id-1 >= 0 && !calculation.save {
            
            if calc.calculations[calculation.id-1].resultContinues {
                
                var containsResult = true
                for item in calc.calculations[calculation.id-1].result {
                    if !calculation.queue.contains(item) {
                        containsResult = false
                    }
                }
                
                if containsResult {
                    hub.prevOutput = calc.calculations[calculation.id-1].prevOutput
                    hub.topOutput = hub.prevOutput
                }
                else {
                    hub.prevOutput = []
                    hub.topOutput = hub.prevOutput
                }
            }
            else {
                hub.prevOutput = []
                hub.topOutput = hub.prevOutput
            }
        }
        else {
            hub.prevOutput = []
            hub.topOutput = hub.prevOutput
        }
        
        // Reset bottomOutput
        hub.bottomOutput = []
        
        // Set the formatting guides
        hub.topFormattingGuide = formatting.createFormattingGuide(array: hub.topOutput)
        hub.mainFormattingGuide = formatting.createFormattingGuide(array: hub.mainOutput)
        hub.bottomFormattingGuide = formatting.createFormattingGuide(array: hub.bottomOutput)
    }
    
    
    // Insert Calculation
    // Insert an already completed calculation into the queue
    func insertCalculation(calculation: Calculation) {
        
        print("(Calculation) Inserting calculation")
        settings.showCalculations = false
        
        guard calculation.result != ["Error"], calculation.result != ["∞"] else {
            return
        }
        
        if canInsert {
            
            // Add the calculation's resultQueue to the end of the queue
            if calculation.result.count > 1 {
                hub.queue += ["("]+calculation.result+[")"]
            }
            else {
                hub.queue += calculation.result
            }
            
            // End any indexing
            endIndexing()
            
            // Run through queueing inputs
            queueInput(button: " ", pressType: "tap", record: true)
            
        }
    }
}

// Refresh
func refresh() {
    let input = Input.input
    input.queueInput(button: "refresh", pressType: "", record: false)
}
