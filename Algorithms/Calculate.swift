//
//  Calculate.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/15/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Calculate
// Perform the calculations and produce a result
// The inputted queue is simplified and outputted to Expression
class Calculate: ObservableObject {
    
    static let calculate = Calculate()
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var calc = Calculations.calc
    @ObservedObject var settings = Settings.settings
    var exp = Expression.expression
    var math = Math.math
    var uiData = UIData.uiData
    
    var currentQueue = [String]()
    var parLevel = 0
    
    
    // MARK: - Perform Operations
    
    // Perform the operations
    func operate(queue: Array<String>, main: Bool) -> Array<String> {
        
        // If queue is error, return error
        if hub.error {
            hub.error = false
            return ["Error"]
        }
        
        // Create the opQueue array to operate on
        var opQueue:Array = queue
        var result = [String]()
        
        // Set current calc to -1
        hub.currentCalc = -1
        
        opQueue = step(queue: opQueue, main: main)
        
        // Remove invisible coefficients of 1
        while opQueue.contains("01") {
            let coeffIndex = opQueue.firstIndex(of: "01")!
            opQueue.remove(at: opQueue.index(opQueue.startIndex, offsetBy: coeffIndex))
            opQueue.remove(at: opQueue.index(opQueue.startIndex, offsetBy: coeffIndex))
        }
        if opQueue.count == 1 {
            if ["π","e"].contains(opQueue.first!) {
                opQueue[0] = String(setNumber(opQueue.first!)!)
            }
        }
        
        // MARK: Parentheses
        while opQueue.contains("(") || opQueue.contains(")") {
            // Loop runs while there are still parentheses in the queue
            
            // If the amount of opening parentheses does not equal the amount of closing parentheses, error
            var openPar = 0
            var closePar = 0
            for item in opQueue {
                if item == "(" {
                    openPar += 1
                }
                if item == ")" {
                    closePar += 1
                }
            }
            guard openPar == closePar else {
                // Error
                hub.extraMessage = "Parentheses mismatch"
                hub.extraMessagePopUp = "Open and closed parentheses do not match"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Initialize the variables which will hold the indexes of the pair of parentheses being operated on
            var openParIndex = -1
            var closeParIndex = -1
            
            // Find the indexes of the first of each parenthesis
            let firstOpenParIndex = opQueue.index(opQueue.startIndex, offsetBy: opQueue.firstIndex(of: "(")!)
            let firstCloseParIndex = opQueue.index(opQueue.startIndex, offsetBy: opQueue.firstIndex(of: ")")!)
            
            // If the first closing parenthesis comes before the first opening parenthesis, error
            guard firstCloseParIndex >= firstOpenParIndex else {
                // Error
                hub.extraMessage = "Parentheses mismatch"
                hub.extraMessagePopUp = "Open and closed parentheses do not match"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set openParIndex to the first open parenthesis index
            openParIndex = firstOpenParIndex
            
            // Find the matching closing parenthesis for the open parenthesis
            var findClosePar = openParIndex+1
            var skipParenthesis = 0
            
            // Loop through the queue until the closing parenthesis is located
            // If another opening parenthesis is located first, one closed parenthesis must be skipped in order to find the original open parenthesis's match
            while findClosePar < opQueue.count {
                
                // If there are no more skips and a closed parenthesis has been found
                if skipParenthesis == 0 && opQueue[findClosePar] == ")" {
                    
                    // The matching closed parenthesis has been found
                    // Set closeParIndex to that closed parenthesis's index
                    closeParIndex = findClosePar
                    
                    // End the while loop by making the condition false
                    findClosePar = opQueue.count
                }
                else {
                    
                    // If a closing parenthesis is found, decrement the skips
                    if opQueue[findClosePar] == ")" {
                        skipParenthesis -= 1
                    }
                        // If another opening parenthesis is found, increment the skips
                    else if opQueue[findClosePar] == "(" {
                        skipParenthesis += 1
                    }
                    
                    // Increment findClosePar to the next index
                    findClosePar += 1
                }
            }
            
            // Make sure the parentheses have something in between them
            if closeParIndex-openParIndex > 1 {
                
                // Create a new parentheses queue which will store the items inside the parentheses
                var parenthesesQueue: [String] = []
                
                // For each item in between the two parentheses in the opQueue
                for index in openParIndex...closeParIndex {
                    
                    // Queue the item to the parenthesesQueue instead
                    parenthesesQueue.append(opQueue[index])
                }
                
                // Remove all items in the parentheses from the opQueue
                opQueue.removeSubrange(openParIndex...closeParIndex)
                
                // Remove the outermost parentheses from the parenthesesQueue so the contents can be operated on
                parenthesesQueue.removeFirst()
                parenthesesQueue.removeLast()
                
                // Increment par level
                parLevel += 1
                
                // Perform the operations for all items in the parenthesesQueue
                var parenthesesResult = operate(queue: parenthesesQueue, main: false)
                
                var parFixIndex = 0
                while parFixIndex < parenthesesResult.count {
                    parenthesesResult[parFixIndex] = exp.fixZero(string: parenthesesResult[parFixIndex], all: true)
                    parFixIndex += 1
                }
                
                // Note: If the parenthesesQueue contains another set of parentheses, it will be operated on first in operate()
                // This will repeat for all parentheses inside the expression until all parenthetical expressions have been resolved
                
                // Queue the parenthesesResult (result of expression in the original parentheses) back into the opQueue
                // The original parentheses expression has been replaced by a single result
                opQueue.insert(contentsOf: parenthesesResult, at: openParIndex)
                
                // Decrement par level
                parLevel -= 1
            }
            else {
                // Remove the parentheses if there is nothing in between them
                opQueue.removeSubrange(openParIndex...closeParIndex)
            }
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
            
        }
        
        
        // Operator Error Protection
        for op in hub.operators+hub.operators2+["E"] {
            
            // If the queue is empty, error
            guard !opQueue.isEmpty else {
                // Error
                hub.extraMessage = "Empty queue"
                hub.extraMessagePopUp = "Please enter items"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            // If the first item in the queue is an operator, error
            if opQueue[0] == op {
                if opQueue.count > 1 {
                    if opQueue[0] != "-" || opQueue[1] != "*" {
                        // Error
                        hub.extraMessage = "Extra operator"
                        hub.extraMessagePopUp = "Operator first with nothing before"
                        print("(Error) \(hub.extraMessage)")
                        hub.error = true
                        return ["Error"]
                    }
                }
                else {
                    // Error
                    hub.extraMessage = "Extra operator"
                    hub.extraMessagePopUp = "Operator first with nothing before"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
            }
            // If the last item in the queue is an operator, error
            if opQueue.count > 0 {
                guard opQueue[opQueue.count-1] != op else {
                    // Error
                    hub.extraMessage = "Extra operator"
                    hub.extraMessagePopUp = "Operator last with nothing after"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
            }
        }
        
        // Step & Print
        opQueue = step(queue: opQueue, main: main)
        print(opQueue)
        
        
        // MARK: Rand
        while opQueue.contains("rand") {
            // Loop runs while there are still random numbers in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find a rand in the queue
            index = opQueue.firstIndex(of: "rand")!
            
            // Generate the random number
            let random = Double.random(in: 0..<1)
            
            // Set the result
            calcResult = String(random)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the number to the queue at the rand's old index
            opQueue[index] = calcResult
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Exponents
        while opQueue.contains("^") {
            // Loop runs while there are still exponents in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find a carrot in the queue
            index = opQueue.firstIndex(of: "^")!
            
            // If either the index before or after the carrot is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid exponent"
                hub.extraMessagePopUp = "Base or power is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the exponent is 0 to a negative, error
            if setNumber(opQueue[index-1]) == 0 && setNumber(opQueue[index+1])! < 0 {
                // Error
                hub.extraMessage = "Not a real number"
                hub.extraMessagePopUp = "Negative power of 0; Undefined"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the base and power
            let base = setNumber(opQueue[index-1])!
            let power = setNumber(opQueue[index+1])!
            
            // Perform the operation
            let product = math.exponent(base: base, power: power)
            
            // Set the result
            calcResult = String(product)
            
            // If calcResult is nan, error
            if calcResult == "nan" {
                // Error
                hub.extraMessage = "Not a real number"
                hub.extraMessagePopUp = "Negative raised to even fractional power does not exist"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the operator's old index
            opQueue[index] = calcResult
            
            // Remove the base and power
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Coefficients
        while opQueue.contains("*") {
            // Loop runs while there are still coefficient multipliers in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find a coefficient multiplier in the queue
            index = opQueue.firstIndex(of: "*")!
            
            // If either the index before or after the multiplier is not a number, error
            if (setNumber(opQueue[index-1]) == nil) || (setNumber(opQueue[index+1]) == nil && opQueue[index+1] != "!") {
                // Error
                hub.extraMessage = "Invalid coefficient"
                hub.extraMessagePopUp = "Coefficient is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Perform the operation
            if opQueue[index+1] != "!" {
                
                // Set the factors
                let factor1 = setNumber(opQueue[index-1])!
                let factor2 = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let product = math.multiply(factor1, factor2)
                
                // Set the result
                calcResult = String(product)
            }
            else {
                // Factorial
                var factorial = setNumber(opQueue[index-1])!
                
                guard factorial >= 0 && factorial == floor(factorial) else {
                    // Error
                    hub.extraMessage = "Invalid factorial"
                    hub.extraMessagePopUp = "Factorial only exists for whole numbers"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                factorial = floor(factorial)
                
                // Perform the operation
                let factorialResult = math.factorial(factorial)
                
                // Set the result
                calcResult = String(factorialResult)
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the multiplier's old index
            opQueue[index] = calcResult
            
            // Remove the factors
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Fractions
        while opQueue.contains("/") {
            // Loop runs while there are still fraction bars in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find a coefficient multiplier in the queue
            index = opQueue.firstIndex(of: "/")!
            
            // If either the index before or after the multiplier is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid fraction"
                hub.extraMessagePopUp = "Fraction contains non-number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the denominator is 0, error
            if opQueue[index+1] == "0" {
                // Error
                hub.extraMessage = "Divide by zero"
                hub.extraMessagePopUp = "Zero in fraction denominator; Undefined"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the numerator and denominator
            let numerator = setNumber(opQueue[index-1])!
            let denominator = setNumber(opQueue[index+1])!
            
            // Perform the operation
            let quotient = math.divide(numerator, denominator)
            
            // Set the result
            calcResult = String(quotient)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the multiplier's old index
            opQueue[index] = calcResult
            
            // Remove the factors
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Absolute Value
        while opQueue.contains("| |") {
            // Loop runs while there are still absolute values in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find an absolute value in the queue
            index = opQueue.firstIndex(of: "| |")!
            
            // If there is nothing after the abs, error
            if index == opQueue.count-1 {
                // Error
                hub.extraMessage = "Invalid absolute value"
                hub.extraMessagePopUp = "No value in absolute value bars"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the index after the abs is not a number, error
            guard setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid absolute value"
                hub.extraMessagePopUp = "Item in absolute value is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the number
            let absNumber = setNumber(opQueue[index+1])!
            
            // Perform the operation
            let result = math.absoluteValue(absNumber)
            
            // Set the result
            calcResult = String(result)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the absolute value's old index
            opQueue[index] = calcResult
            
            // Remove the abs number
            opQueue.remove(at: index+1)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Other Functions
        while opQueue.contains("round") || opQueue.contains("floor") || opQueue.contains("ceil") {
            // Loop runs while there are still absolute values in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find an absolute value in the queue
            index = opQueue.firstIndex(of: "round") ?? opQueue.firstIndex(of: "floor") ?? opQueue.firstIndex(of: "ceil")!
            
            // If there is nothing after the abs, error
            if index == opQueue.count-1 {
                // Error
                hub.extraMessage = "Invalid function"
                hub.extraMessagePopUp = "No value in function"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the index after the abs is not a number, error
            guard setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid function"
                hub.extraMessagePopUp = "Item in function is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            var result: Double = 0
            
            let num = setNumber(opQueue[index+1])!
            
            // Rounding
            if opQueue[index] == "round" {
                result = math.roundFunc(num)
            }
            // Floor
            else if opQueue[index] == "floor" {
                result = math.floorFunc(num)
            }
            // Ceil
            else if opQueue[index] == "ceil" {
                result = math.ceilFunc(num)
            }
            
            // Set the result
            calcResult = String(result)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the absolute value's old index
            opQueue[index] = calcResult
            
            // Remove the abs number
            opQueue.remove(at: index+1)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Exponential Form
        while opQueue.contains("E") {
            // Loop runs while there are still exponential operators in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find an exponential in the queue
            index = opQueue.firstIndex(of: "E")!
            
            // If either the index before or after the exponential operator is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid exponential"
                hub.extraMessagePopUp = "Base or power is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the coefficient and exponent
            let coefficient = setNumber(opQueue[index-1])!
            let exponent = setNumber(opQueue[index+1])!
            
            // Perform the operation
            let product = math.exponential(coefficient: coefficient, exponent: exponent)
            
            // Set the result
            calcResult = String(product)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the operator's old index
            opQueue[index] = calcResult
            
            // Remove the base and power
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Permutations and Combinations
        while opQueue.contains("P") || opQueue.contains("C") {
            // Loop runs while there are still permutations or combinations in the queue
            
            var index = 0
            var calcResult = ""
            var operation = ""
            var permutation: Double = 0
            var combination: Double = 0
            
            // Find a permutation or combination
            if opQueue.contains("P") && opQueue.contains("C") {
                
                // Find first index of each
                let indexP = opQueue.firstIndex(of: "P")!
                let indexC = opQueue.firstIndex(of: "C")!
                
                // Set the index to whichever comes first
                if indexP < indexC {
                    index = indexP
                    operation = "P"
                }
                else if indexC < indexP {
                    index = indexC
                    operation = "C"
                }
            }
            // Find a permutation
            else if opQueue.contains("P") {
                index = opQueue.firstIndex(of: "P")!
                operation = "P"
            }
            // Find a combination
            else if opQueue.contains("C") {
                index = opQueue.firstIndex(of: "C")!
                operation = "C"
            }
            
            // If the index is first or last, error
            guard index > 0 && index < opQueue.count-1 else {
                // Error
                hub.extraMessage = "Invalid \(operation == "P" ? "permutation" : "combination")"
                hub.extraMessagePopUp = "Missing n or r"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If either the index before or after the exponential operator is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid \(operation == "P" ? "permutation" : "combination")"
                hub.extraMessagePopUp = "n or r is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set n and r
            let n = setNumber(opQueue[index-1])!
            let r = setNumber(opQueue[index+1])!
            
            // If either n or r is not an integer, error
            guard floor(n) == n && floor(r) == r else {
                // Error
                hub.extraMessage = "Invalid \(operation == "P" ? "permutation" : "combination")"
                hub.extraMessagePopUp = "n and r must be an integer"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If either n or r is negative, error
            guard n >= 0 && r >= 0 else {
                // Error
                hub.extraMessage = "Invalid \(operation == "P" ? "permutation" : "combination")"
                hub.extraMessagePopUp = "n and r must be positive"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // For permutations
            if operation == "P" {
                
                // Perform the operation
                permutation = math.permutation(n: n, r: r)
                
                // Set the result
                calcResult = String(permutation)
            }
            // For combinations
            else if operation == "C" {
                
                // Perform the operation
                combination = math.combination(n: n, r: r)
                
                // Set the result
                calcResult = String(combination)
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the permutation/combination's old index
            opQueue[index] = calcResult
            
            // Remove n and r
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Roots
        while opQueue.contains("√") {
            // Loop runs while there are still radicals in the queue
            
            var index = 0
            var calcResult = ""
            
            // Find a radical in the queue
            index = opQueue.firstIndex(of: "√")!
            
            // If there is no root index, error
            guard opQueue.contains("§") else {
                // Error
                hub.extraMessage = "Invalid radical"
                hub.extraMessagePopUp = "Root index is missing"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the root index to the item after the index identifier §
            let rootIndex = opQueue[opQueue.firstIndex(of: "§")! + 1]
            
            // If either the root index or the item after the radical is not a number, error
            guard setNumber(rootIndex) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Invalid radical"
                hub.extraMessagePopUp = "Root index or radicand is not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the root index is 0, error
            if rootIndex == "0" || rootIndex == "-0" {
                // Error
                hub.extraMessage = "0th root does not exist"
                hub.extraMessagePopUp = "0th root is power of 1/0; Undefined"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If rootIndex is even and radicand is negative, error
            if setNumber(opQueue[index+1])! < 0 && math.isDivisible(setNumber(rootIndex)!, 2) {
                // Error
                hub.extraMessage = "Not a real number"
                hub.extraMessagePopUp = "Even root of negative does not exist"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the radicand and index
            let radicand = setNumber(opQueue[index+1])!
            let rIndex = setNumber(rootIndex)!
            
            // Perform the operation
            let rootResult = math.root(radicand: radicand, index: rIndex)
            
            // Set the result
            calcResult = String(rootResult)
            
            // If calcResult is nan, error
            if calcResult == "nan" {
                // Error
                hub.extraMessage = "Not a real number"
                hub.extraMessagePopUp = "Even root of negative does not exist"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the radical's old index
            opQueue[index] = calcResult
            
            // Remove the radicand, index, and index identifier
            opQueue.remove(at: index-2)
            opQueue.remove(at: index-2)
            opQueue.remove(at: index-1)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Trig Functions
        var containsFunction = false
        for item in opQueue {
            if hub.functions.contains(item) && item != "log" {
                containsFunction = true
            }
        }
        while containsFunction {
            // Loop runs while there are still trig functions in the queue
            
            var index = 0
            var function = ""
            var deg: Double = 0
            var rad: Double = 0
            var calcResult = ""
            
            // Find the first trig function in the queue
            var findIndex = 0
            while findIndex < opQueue.count {
                if hub.functions.contains(opQueue[findIndex]) && opQueue[findIndex] != "log" {
                    function = opQueue[findIndex]
                    index = findIndex
                    break
                }
                findIndex += 1
            }
            
            // Regular Trig Function
            if ["sin","cos","tan","cot","sec","csc","sinh","cosh","tanh","coth","sech","csch"].contains(function) {
                
                // If there is nothing after the function, error
                if index == opQueue.count-1 {
                    // Error
                    hub.extraMessage = "Invalid function"
                    hub.extraMessagePopUp = "No angle following trig function"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                // If the item after the function is not a number, error
                if setNumber(opQueue[index+1]) == nil {
                    // Error
                    hub.extraMessage = "Invalid function"
                    hub.extraMessagePopUp = "Invalid angle following trig function"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                // Set the angle if in radians
                if settings.radians {
                    rad = setNumber(opQueue[index+1])!
                    // Get a coterminal if the angle is not in the unit circle
                    if setNumber(opQueue[index+1])! <= 1000000000 && !function.contains("h") {
                        while rad - 2*Double.pi >= 0 {
                            rad -= 2*Double.pi
                        }
                        while rad + 2*Double.pi < 2*Double.pi {
                            rad += 2*Double.pi
                        }
                    }
                }
                    
                // Set the angle if in degrees
                else {
                    deg = setNumber(opQueue[index+1])!
                    // Get a coterminal if the angle is not in the unit circle
                    if setNumber(opQueue[index+1])! <= 1000000000 && !function.contains("h") {
                        while deg - 360 >= 0 {
                            deg -= 360
                        }
                        while deg + 360 < 360 {
                            deg += 360
                        }
                    }
                }
                
                // Set the angle
                let angle = settings.radians ? rad : deg * Double.pi/180
                
                // Perform the operation
                let value = math.trig(function: function, angle: angle)
                
                // Set the result
                calcResult = String(value)
            }
                
            // Inverse Trig Function
            else if ["sin⁻¹","cos⁻¹","tan⁻¹","cot⁻¹","sec⁻¹","csc⁻¹","sinh⁻¹","cosh⁻¹","tanh⁻¹","coth⁻¹","sech⁻¹","csch⁻¹"].contains(function) {
                
                // If there is nothing after the function, error
                if index == opQueue.count-1 {
                    // Error
                    hub.extraMessage = "Invalid function"
                    hub.extraMessagePopUp = "No value following trig function"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                // If the item after the function is not a number, error
                if setNumber(opQueue[index+1]) == nil {
                    // Error
                    hub.extraMessage = "Invalid function"
                    hub.extraMessagePopUp = "Invalid value following trig function"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                // Set the value
                let value = setNumber(opQueue[index+1])!
                
                // Determine the base function
                let baseFunction = function.replacingOccurrences(of: "⁻¹", with: "")
                
                // Return errors for input ranges
                if (abs(value) > 1 && (function == "sin⁻¹" || function == "cos⁻¹" )) || (abs(value) < 1 && (function == "sec⁻¹" || function == "csc⁻¹" )) || ((abs(value) < 1 || value < 0) && function == "cosh⁻¹") || ((abs(value) > 1 || value < 0) && function == "sech⁻¹") || (abs(value) > 1 && function == "tanh⁻¹") || (abs(value) < 1 && function == "coth⁻¹") {
                    // List ranges
                    var range = ""
                    if function == "sin⁻¹" || function == "cos⁻¹" { range = "-1...1" }
                    else if function == "sec⁻¹" || function == "csc⁻¹" { range = "-∞...-1 and 1...∞" }
                    else if function == "cosh⁻¹" { range = "1...∞" }
                    else if function == "sech⁻¹" { range = "0...1" }
                    else if function == "tanh⁻¹" { range = "-1...1" }
                    else if function == "coth⁻¹" { range = "-∞...-1 and 1...∞" }
                    // Error
                    hub.extraMessage = "Out of range for \(function)"
                    hub.extraMessagePopUp = "Range for \(function) is \(range)"
                    print("(Error) \(hub.extraMessage)")
                    hub.error = true
                    return ["Error"]
                }
                
                // Perform the operation
                var angle = math.itrig(function: baseFunction, value: value)
                
                // Convert to degrees if in degree mode
                if !settings.radians {
                    angle = angle * 180 / Double.pi
                }
                
                // Set the result
                calcResult = String(angle)
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the function's old index
            opQueue[index+1] = calcResult
            
            // Remove the function
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
            
            // See if there are any more functions in the queue
            var stillContainsFunction = false
            for item in opQueue {
                
                // If there are, continue the loop
                if hub.functions.contains(item) && item != "log" {
                    stillContainsFunction = true
                }
            }
            
            // If not, end the while loop and move on
            if !stillContainsFunction {
                containsFunction = false
            }
        }
        
        
        // MARK: Logarithms
        while opQueue.contains("log") {
            // Loop runs while there are still logarithms in the queue
            
            var index: Int = 0
            var calcResult = ""
            
            // Find a logarithm in the queue
            index = opQueue.firstIndex(of: "log")!
            
            // If there are not at least 3 items after the log, error
            if index >= opQueue.count-3 {
                // Error
                hub.extraMessage = "Invalid logarithm"
                hub.extraMessagePopUp = "Base or value missing from log"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If there is not a log base indicator after the log, error
            if opQueue[index+2] != "¶" {
                // Error
                hub.extraMessage = "Invalid logarithm"
                hub.extraMessagePopUp = "Incomplete log base"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If either the log base or log value is not a number, error
            if setNumber(opQueue[index+1]) == nil || setNumber(opQueue[index+3]) == nil {
                // Error
                hub.extraMessage = "Invalid logarithm"
                hub.extraMessagePopUp = "Log base or value not a number"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Set the base and value
            let base = setNumber(opQueue[index+1])!
            let value = setNumber(opQueue[index+3])!
            
            // If the base is 0, 1, or negative, error
            if base <= 0 || base == 1 {
                // Error
                hub.extraMessage = "log \(exp.fixZero(string:String(base),all:true)) ¶ does not exist"
                hub.extraMessagePopUp = "Log bases must be greater than 1"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If the value is 0 or negative, error
            if value <= 0 {
                // Error
                hub.extraMessage = "log ¶ of \(exp.fixZero(string:String(value),all:true)) does not exist"
                hub.extraMessagePopUp = "Log values must be positive"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Perform the operation
            let logResult = math.logarithm(base: base, value: value)
            
            // Set the result
            calcResult = String(logResult)
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the logarithm's old index
            opQueue[index] = calcResult
            
            // Remove the 3 items after the log
            opQueue.remove(at: index+1)
            opQueue.remove(at: index+1)
            opQueue.remove(at: index+1)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
        }
        
        
        // MARK: Multiply and Divide
        while opQueue.contains("×") || opQueue.contains("#×") || opQueue.contains("÷") || opQueue.contains("mod") {
            // Loop runs while there are still multiplication or division signs in the queue
            
            var index = 0
            var indexM = 0
            var indexD = 0
            var operation = ""
            var calcResult = ""
            
            // Replace invisible multipliers
            var invisIndex = 0
            while invisIndex < opQueue.count {
                if opQueue[invisIndex] == "#×" {
                    opQueue[invisIndex] = "×"
                }
                invisIndex += 1
            }
            
            // Find a mult and div sign in the queue
            if opQueue.contains("×") && opQueue.contains("÷") {
                // Queue contains both mult and div
                
                // Find the first occurrence of each sign in the queue
                indexM = opQueue.firstIndex(of: "×")!
                indexD = opQueue.firstIndex(of: "÷")!
                // Determine which sign comes first
                if indexM < indexD {
                    // Mult sign comes first, multiply
                    index = indexM
                    operation = "mult"
                }
                else if indexD < indexM {
                    // Div sign comes first, divide
                    index = indexD
                    operation = "div"
                }
            }
            else if opQueue.contains("×") && !opQueue.contains("÷") {
                // Queue contains only mult
                index = opQueue.firstIndex(of: "×")!
                operation = "mult"
            }
            else if !opQueue.contains("×") && opQueue.contains("÷") {
                // Queue contains only div
                index = opQueue.firstIndex(of: "÷")!
                operation = "div"
            }
            
            // Check if mod comes before
            if opQueue.contains("mod") {
                if opQueue.firstIndex(of: "mod")! < index || index == 0 {
                    index = opQueue.firstIndex(of: "mod")!
                    operation = "mod"
                }
            }
            
            // If either the index before or after the operator is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Extra operator"
                hub.extraMessagePopUp = "No number on one side of operator"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // If a zero follows the division sign, error
            if (operation == "div" || operation == "mod") && setNumber(opQueue[index+1]) == 0 {
                // Error
                hub.extraMessage = "Divide by zero"
                hub.extraMessagePopUp = "Zero after division; Undefined"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Multiply
            if operation == "mult" {
                
                // Set the factors
                let factor1 = setNumber(opQueue[index-1])!
                let factor2 = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let product = math.multiply(factor1, factor2)
                
                // Set the result
                calcResult = String(product)
            }
                
            // Divide
            else if operation == "div" {
                
                // Set the dividend and divisor
                let dividend = setNumber(opQueue[index-1])!
                let divisor = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let quotient = math.divide(dividend, divisor)
                
                // Set the result
                calcResult = String(quotient)
            }
            
            // Modulo
            else if operation == "mod" {
                
                // Set the dividend and divisor
                let dividend = setNumber(opQueue[index-1])!
                let divisor = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let remainder = math.modulo(dividend, divisor)
                
                // Set the result
                calcResult = String(remainder)
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the operator's old index
            opQueue[index] = calcResult
            
            // Remove the factors/dividend/divisor
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
            
        }
        
        
        // MARK: Add and Subtract
        while opQueue.contains("+") || opQueue.contains("-") {
            // Loop runs while there are still addition or subtraction signs in the queue
            
            var index = 0
            var indexA = 0
            var indexS = 0
            var operation = ""
            var calcResult = ""
            
            // Find an add and sub sign in the queue
            if opQueue.contains("+") && opQueue.contains("-") {
                // Queue contains both add and sub
                
                // Find the first occurrence of each sign in the queue
                indexA = opQueue.firstIndex(of: "+")!
                indexS = opQueue.firstIndex(of: "-")!
                // Determine which sign comes first
                if indexA < indexS {
                    // Add sign comes first, add
                    index = indexA
                    operation = "add"
                }
                else if indexS < indexA {
                    // Sub sign comes first, subtract
                    index = indexS
                    operation = "sub"
                }
            }
            else if opQueue.contains("+") && !opQueue.contains("-") {
                // Queue contains only add
                index = opQueue.firstIndex(of: "+")!
                operation = "add"
            }
            else if !opQueue.contains("+") && opQueue.contains("-") {
                // Queue contains only sub
                index = opQueue.firstIndex(of: "-")!
                operation = "sub"
            }
            
            // If either the index before or after the operator is not a number, error
            guard setNumber(opQueue[index-1]) != nil, setNumber(opQueue[index+1]) != nil else {
                // Error
                hub.extraMessage = "Extra operator"
                hub.extraMessagePopUp = "No number on one side of operator"
                print("(Error) \(hub.extraMessage)")
                hub.error = true
                return ["Error"]
            }
            
            // Add
            if operation == "add" {
                
                // Set the addends
                let addend1 = setNumber(opQueue[index-1])!
                let addend2 = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let sum = math.add(addend1, addend2)
                
                // Set the result
                calcResult = String(sum)
            }
                
            // Subtract
            else if operation == "sub" {
                
                // Set the minuend and subtrahend
                let minuend = setNumber(opQueue[index-1])!
                let subtrahend = setNumber(opQueue[index+1])!
                
                // Perform the operation
                let difference = math.subtract(minuend, subtrahend)
                
                // Set the result
                calcResult = String(difference)
            }
            
            // Fix zeroes
            calcResult = exp.fixZero(string: calcResult, all: true)
            
            // Add the result to the queue at the operator's old index
            opQueue[index] = calcResult
            
            // Remove the addends/minuend/subtrahend
            opQueue.remove(at: index-1)
            opQueue.remove(at: index)
            
            // Step & Print
            opQueue = step(queue: opQueue, main: main)
            print(opQueue)
            
        }
        
        // MARK: Format Result
        
        var opIndex = 0
        while opIndex < opQueue.count {
            if Double(opQueue[opIndex]) != nil {
                opQueue[opIndex] = String(Double(opQueue[opIndex])!)
            }
            opIndex += 1
        }
        
        result = opQueue
        
        if main {
            
            // Format the e+ or e-
            if result.count == 1 {
                
                // Set big numbers to exponential form
                if Double(result[0]) != nil {
                    
                    var number = Double(result[0])!
                    
                    var negative = false
                    if number < 0 {
                        negative = true
                        number = abs(number)
                    }
                    
                    if math.rounding(number) >= pow(10,10) {
                        var power = 0
                        while math.rounding(number) >= 10 {
                            number /= 10
                            power += 1
                        }
                        if negative {
                            number *= -1
                        }
                        let numberString = exp.fixZero(string: String(number), all: true)
                        let powerString = exp.fixZero(string: String(power), all: true)
                        
                        result[0] = numberString + "e" + powerString
                    }
                }
                
                if result[0].contains("e") {
                    var base = ""
                    var power = ""
                    var powering = false
                    let item = result[0]
                    var index = 0
                    while index < item.count {
                        let char = exp.stringCharGet(string: item, index: index)
                        if char == "e" {
                            powering = true
                        }
                        else if char == "+" {
                        }
                        else if !powering {
                            base += String(char)
                        }
                        else if powering {
                            power += String(char)
                        }
                        index += 1
                    }
                    if math.rounding(setNumber(base) ?? 0) >= 10 {
                        base = exp.fixZero(string: String(math.rounding((setNumber(base) ?? 0) / 10)), all: true)
                        power = exp.fixZero(string: String(math.rounding((setNumber(power) ?? 0) + 1)), all: true)
                    }
                    base = exp.fixZero(string: base, all: true)
                    power = exp.fixZero(string: power, all: true)
                    result = [base, "E", power]
                }
            }
            
            // Round/fix zeroes of each item of the result
            var resultIndex = 0
            while resultIndex < result.count {
                
                if Double(result[resultIndex]) != nil {
                    
                    var resultNumber = Double(result[resultIndex])!
                    
                    resultNumber = math.rounding(resultNumber)
                    
                    var resultString = String(resultNumber)
                    
                    resultString = exp.fixZero(string: resultString, all: true)
                    
                    result[resultIndex] = resultString
                }
                resultIndex += 1
            }
            
            // Print the result
            print(result)
            
            // Create any extra/alternate results
            hub.results = extraResult(result)
            
            // Set extraMessage to the extra result
            hub.extraMessage = !hub.results.isEmpty ? exp.createExpression(hub.results.first!) : hub.extraMessage
            hub.extraMessage = hub.extraMessage == "" ? " " : hub.extraMessage
            
        }
        
        // Return the result
        return result
    }
    
    
    // Set to Number
    func setNumber(_ input: String) -> Double? {
        
        var number = input
        
        if number.contains("#") {
            number = number.replacingOccurrences(of: "#", with: "")
        }
        
        if Double(number) != nil {
            return Double(number)!
        }
        else if number == "π" {
            return Double.pi
        }
        else if number == "e" {
            return M_E
        }
        else if number == "%" {
            return 0.01
        }
        else {
            return nil
        }
    }
    
    
    // Step
    // A step has been completed
    func step(queue: Array<String>, main: Bool) -> Array<String> {
        
        var newQueue = queue
        
        // If queue contains infinity, set the entire queue to infinity
        if queue.contains("∞") {
            newQueue = ["∞"]
        }
        // If the queue contains all real numbers, set the entire queue to all real numbers
        if queue.contains("ℝ") {
            newQueue = ["ℝ"]
        }
        // If queue contains error, set the entire queue to error
        if queue.contains("Error") {
            newQueue = ["Error"]
        }
        
        // For main expression, set current queue to inputted queue
        if main {
            currentQueue = newQueue
        }
        // For parentheses, set current queue to main expression + parentheses expression
        else {
            var currentQueuePars = 0
            for item in currentQueue {
                if item == "(" {
                    currentQueuePars += 1
                }
            }
            if !main && currentQueuePars >= parLevel {
                var openParIndex = -1
                var closeParIndex = -1
                // Get the open parentheses
                var currentQueueIndex = 0
                var currentQueuePars = 0
                while currentQueueIndex < currentQueue.count {
                    let item = currentQueue[currentQueueIndex]
                    if item == "(" {
                        currentQueuePars += 1
                    }
                    if currentQueuePars == parLevel {
                        openParIndex = currentQueueIndex
                        break
                    }
                    currentQueueIndex += 1
                }
                // Get the close parentheses
                var findParIndex = openParIndex
                var skipParentheses = 0
                while findParIndex < currentQueue.count {
                    let item = currentQueue[findParIndex]
                    if item == "(" {
                        skipParentheses += 1
                    }
                    else if item == ")" {
                        skipParentheses -= 1
                    }
                    if skipParentheses == 0 {
                        closeParIndex = findParIndex
                        break
                    }
                    findParIndex += 1
                }
                let next = findParIndex+1 < currentQueue.count ? currentQueue[findParIndex+1] : ""
                if newQueue.count > 1 || next == "^" {
                    currentQueue.removeSubrange(openParIndex+1...closeParIndex-1)
                    currentQueue.insert(contentsOf: newQueue, at: openParIndex+1)
                }
                else {
                    currentQueue.removeSubrange(openParIndex...closeParIndex)
                    currentQueue.insert(contentsOf: newQueue, at: openParIndex)
                }
            }
        }
        
        // Create a new step
        var stepsQueue = currentQueue
        
        // Edit the steps queue
        var stepsIndex = 0
        while stepsIndex < stepsQueue.count {
            var item = stepsQueue[stepsIndex]
            
            // Replace e+ with E
            if item.contains("e+") || item.contains("e-") {
                var base = ""
                var power = ""
                var powering = false
                var index = 0
                while index < item.count {
                    let char = exp.stringCharGet(string: item, index: index)
                    if char == "e" {
                        powering = true
                    }
                    else if char == "+" {
                    }
                    else if !powering {
                        base += String(char)
                    }
                    else if powering {
                        power += String(char)
                    }
                    index += 1
                }
                base = exp.fixZero(string: base, all: true)
                power = exp.fixZero(string: power, all: true)
                let exponential = [base, "E", power]
                
                stepsQueue.remove(at: stepsIndex)
                stepsQueue.insert(contentsOf: exponential, at: stepsIndex)
            }
            item = stepsQueue[stepsIndex]
            
            // Remove invisible multiplication
            if item == "#×" && stepsIndex+1 < stepsQueue.count {
                let next = stepsQueue[stepsIndex+1]
                for num in hub.numbers {
                    if next.contains(num) {
                        stepsQueue[stepsIndex] = "×"
                    }
                }
            }
            item = stepsQueue[stepsIndex]
            
            // Round and format item
            if Double(item) != nil && item != "01" && item != "-01" {
                stepsQueue[stepsIndex] = exp.fixZero(string:String(math.rounding(Double(item)!)),all:true)
            }
            
            stepsIndex += 1
        }
        
        // Do not add to steps if nothing has changed since the last step
        var stopSteps = false
        if !hub.stepsQueue.isEmpty {
            var lastStepTestArray = [String]()
            var currentStepTestArray = [String]()
            let invisibleList = ["01","*","(",")"]
            
            for item in hub.stepsQueue[hub.stepsQueue.count-1] {
                if !invisibleList.contains(item) {
                    lastStepTestArray += [item]
                }
            }
            for item in stepsQueue {
                if !invisibleList.contains(item) {
                    currentStepTestArray += [item]
                }
            }
            if lastStepTestArray == currentStepTestArray {
                stopSteps = true
            }
        }
        if !stopSteps {
            
            // Add queue to steps queue
            hub.stepsQueue += [stepsQueue]
            
            // Create the steps expression
            let stepsExpression = exp.createExpression(stepsQueue)
            
            // Add the steps expression to the list of expressions
            hub.stepsExpressions += [exp.splitExpression(stepsExpression)]
        }
        
        return newQueue
    }
    
    // MARK: - Find Equivalent Results
    
    // Extra Result
    func extraResult(_ result: [String]) -> [[String]] {
        
        // Make sure result is not zero, error, infinity, or not a number
        guard result != ["0"], result != ["∞"], result != ["Error"], result.count > 0, Double(result.first!) != nil, settings.displayAltResults else { return [[" "]] }
        
        // Get the actual value of the result
        var value: Double = 0
        if result.count == 1 {
            value = Double(result.first!)!
        }
        
        // Find the equivalent results
        var results = equivalentResults(value: value)
        
        // Do not display if the topOutput (expression) is already the same thing
        var resultIndex = 0
        while resultIndex < results.count {
            let result = results[resultIndex]
            if result == hub.queue || result == hub.result {
                results.remove(at: resultIndex)
            }
            resultIndex += 1
        }
        
        return results
    }
    
    
    // Equivalent Results
    func equivalentResults(value: Double) -> [[String]] {
        
        var results = [[String]]()
        
        // Part A - pi, e
        A: for numA in [Double.pi, M_E] {
            
            if math.isApproximately(value, round(value)) {
                break
            }
            
            if math.isApproximately( value, numA ) {
                results += [["01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : ""]]
                break A
            }
            if math.isApproximately( value, -numA ) {
                results += [["-01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : ""]]
                break A
            }
            if math.isDivisible( value, numA ) && abs(round(value/numA)) != 1 {
                results += [[exp.fixZero(string:String(round(value/numA)),all:true), "*", numA == Double.pi ? "π" : numA == M_E ? "e" : ""]]
                break A
            }
            AA: for numAA in settings.displayAllAltResults ? 2...20 : 2...5 {
                if math.isApproximately( value, numA/Double(numAA) ) {
                    results += [["01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "/", String(numAA)]]
                    break A
                }
                if math.isApproximately( value, -numA/Double(numAA) ) {
                    results += [["-01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "/", String(numAA)]]
                    break A
                }
                AAA: for numAAA in 2...20 {
                    if numAA % numAAA != 0 && numAAA % numAA != 0 {
                        if math.isApproximately( value, numA*Double(numAAA)/Double(numAA) ) {
                            results += [[String(numAAA), "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "/", String(numAA)]]
                            break A
                        }
                        if math.isApproximately( value, -numA*Double(numAAA)/Double(numAA) ) {
                            results += [[String(-numAAA), "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "/", String(numAA)]]
                            break A
                        }
                    }
                }
            }
            AB: for numAB in settings.displayAllAltResults ? 2...10 : 2...5 {
                if math.isApproximately( value, pow(numA, Double(numAB)) ) {
                    results += [["01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "^", String(numAB)]]
                    break A
                }
                if math.isApproximately( value, -pow(numA, Double(numAB)) ) {
                    results += [["-01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", "^", String(numAB)]]
                    break A
                }
                if math.isApproximately( value, pow(numA, 1/Double(numAB)) ) {
                    results += [["§", numAB == 2 ? "#2" : String(numAB), "√", "01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : ""]]
                    break A
                }
                if math.isApproximately( value, -pow(numA, 1/Double(numAB)) ) {
                    results += [["-01", "*", "(", "§", numAB == 2 ? "#2" : String(numAB), "√", "01", "*", numA == Double.pi ? "π" : numA == M_E ? "e" : "", ")"]]
                    break A
                }
            }
        }
        
        // Part B - Roots
        B: for numB in 2...100 {
            
            if math.isApproximately(value, round(value)) {
                break
            }

            if math.isApproximately( value, sqrt(Double(numB)) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                results += [["§", "#2", "√", String(numB)]]
                break B
            }
            if math.isApproximately( -value, sqrt(Double(numB)) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                results += [["-01", "*", "(", "§", "#2", "√", String(numB), ")"]]
                break B
            }
            if math.isDivisible( value, sqrt(Double(numB)) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) && abs(round(value/sqrt(Double(numB)))) != 1 {
                results += [[exp.fixZero(string:String(round(value/sqrt(Double(numB)))),all:true), "#×", "§", "#2", "√", "(", String(numB), ")"]]
                break B
            }
            BA: for numBA in settings.displayAllAltResults ? 2...20 : 2...5 {
                if numB > 10 {
                    break BA
                }
                if math.isApproximately( value, sqrt(Double(numB))/Double(numBA) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                    results += [["(", "§", "#2", "√", String(numB), ")", "/", String(numBA)]]
                    break B
                }
                if math.isApproximately( value, -sqrt(Double(numB))/Double(numBA) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                    results += [["-01", "*", "(", "§", "#2", "√", String(numB), ")", "/", String(numBA)]]
                    break B
                }
                BAA: for numBAA in settings.displayAllAltResults ? 2...20 : 2...5 {
                    if numBA % numBAA != 0 && numBAA % numBA != 0 {
                        if math.isApproximately( value, sqrt(Double(numB))*Double(numBAA)/Double(numBA) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                            results += [["(", String(numBAA), "#×", "§", "#2", "√", "(", String(numB), ")", ")", "/", String(numBA)]]
                            break B
                        }
                        if math.isApproximately( value, -sqrt(Double(numB))*Double(numBAA)/Double(numBA) ) && sqrt(Double(numB)) != round(sqrt(Double(numB))) {
                            results += [["(", String(-numBAA), "#×", "§", "#2", "√", "(", String(numB), ")", ")", "/", String(numBA)]]
                            break B
                        }
                    }
                }
            }
        }
        
        // Part C - Fractions
        C: for numC in 1...100 {
            
            if math.isApproximately(value, round(value)) {
                break C
            }
            
            CA: for numCA in settings.displayAllAltResults ? 2...100 : 2...10 {
                if (numC % numCA != 0 && numCA % numC != 0) || numC == 1 {
                    if math.isApproximately( value, Double(numC)/Double(numCA) ) {
                        results += [[String(numC), "/", String(numCA)]]
                        break C
                    }
                    if math.isApproximately( value, Double(-numC)/Double(numCA) ) {
                        results += [[String(-numC), "/", String(numCA)]]
                        break C
                    }
                }
            }
        }
        
        return results
    }
}

