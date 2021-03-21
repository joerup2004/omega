//
//  Expression.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/16/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Expression
// Create and edit the expressions of the calculation
// The expression is then sent to the Formatting class to be formatted
class Expression {
    
    static let expression = Expression()
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    
    var index = 0
    
    // MARK: - Create Expression
    
    // Create the text which will be displayed using the items in the queue
    func createExpression(_ queue: Array<String>) -> String {
        
        // MARK: Add Items to Expression
        
        // Reset expression
        var expression = ""
        
        // Loop through each item in the queue
        for queuedItem in queue {
            
            // Declare new item to add
            var itemToAdd = queuedItem
            
            if itemToAdd != "﹚" {
                
                // Add a space
                expression += " "
                
                // Add separator commas to the item if it is a number
                var addCom = false
                for number in hub.numbers {
                    if itemToAdd.contains(number) {
                        addCom = true
                    }
                }
                if addCom {
                    itemToAdd = addCommas(String(itemToAdd))
                }
                
                if itemToAdd == "| |" {
                    itemToAdd = "||"
                }
                
                // Add the queued item to the expression
                expression += String(itemToAdd)
            }
        }
        
        // Add any number that is still being built to the end of the expression
        if hub.num != "" {
            
            // Declare new num to add
            var numToAdd = hub.num
            
            // Add a space if expression has text already
            if expression != "" {
                expression += " "
            }
            
            // Add separator commas to the num
            numToAdd = addCommas(String(numToAdd))
            
            // Add the num to the expression
            expression += numToAdd
            
        }
        
        // Add any final parentheses
        for item in hub.queue {
            if item == "﹚" {
                expression += " ﹚"
            }
        }
        
        // Add any root that is still being indexed to the end of the expression
        if hub.indexingRoot {
            
            // Add an indicator if the index has not yet been inputted so the user knows they should
            if queue.last == "§" && hub.num.isEmpty {
                expression += " ?"
            }
            
            // Add a radical
            expression += " √"
            
            // Add a parentheses if indicated
            if hub.indexingRootPar {
                expression += " ("
            }
        }
        
        // Add any log base that is still being indexed to the end of the expression
        if hub.indexingLog {
            
            // Add an indicator if the index has not yet been inputted so the user knows they should
            if queue.last == "log" && hub.num.isEmpty {
                expression += " ?"
            }
            
            // Add a log base indicator
            expression += " ¶"
            
            // Add a parentheses if indicated
            if hub.indexingLogPar {
                expression += " ("
            }
        }
        
        // Add any base that is still being indexed to the end of the expression
        if hub.indexingBase {
            
            // Add an indicator if the base has not yet been inputted so the user knows they should
            if queue.last == "xb" && hub.num.isEmpty {
                expression += " ?"
            }
            
            // Add a carrot
            expression += " ^"
            
            // Add a parentheses if indicated
            if hub.indexingBasePar {
                expression += " ("
            }
        }
        
        // Add anything where something is being added before
        if hub.indexingQueue != [] {
            
            // Add the results
            for item in hub.indexingQueue {
                
                // Declare new item to add
                var itemToAdd = item
                
                // Add a space
                expression += " "
                
                // Add separator commas to the item if it is a number
                var addCom = false
                for number in hub.numbers {
                    if itemToAdd.contains(number) {
                        addCom = true
                    }
                }
                if addCom {
                    itemToAdd = addCommas(String(item))
                }
                
                if itemToAdd == "| |" {
                    itemToAdd = "||"
                }
                
                // Add the queued item to the expression
                expression += String(itemToAdd)
            }
        }
        
        // Add a close par if necessary
        if hub.indexingRootPar || hub.indexingLogPar || hub.indexingBasePar {
            expression += " ﹚"
        }
        
        // MARK: Editing Part 1: Spacing, Parentheses
        
        // Temporarily replace errors so they pass the exponential test
        if expression.contains("Error") {
            expression = expression.replacingOccurrences(of: "Error", with: "yeet")
        }
        
        // Replace E with x10^ if indicated
        if expression.contains(" E") && settings.displayX10 {
            expression = expression.replacingOccurrences(of: " E", with: "×10 ^")
        }
        
        // Replace yeet with error
        if expression.contains("yeet") {
            expression = expression.replacingOccurrences(of: "yeet", with: "Error")
        }
        
        // Remove spaces around coefficient multiplier
        if expression.contains(" * ") {
            expression = expression.replacingOccurrences(of: " * ", with: "*")
        }
        // Remove spaces around fraction bar
        if expression.contains(" / ") {
            expression = expression.replacingOccurrences(of: " / ", with: "/")
        }
        if expression.contains(" /") {
            expression = expression.replacingOccurrences(of: " /", with: "/")
        }
        
        // Remove spaces around permutations
        if expression.contains(" P ") {
            expression = expression.replacingOccurrences(of: " P ", with: "P")
        }
        if expression.contains(" P") {
            expression = expression.replacingOccurrences(of: " P", with: "P")
        }
        // Remove spaces around combinations
        if expression.contains(" C ") {
            expression = expression.replacingOccurrences(of: " C ", with: "C")
        }
        if expression.contains(" C") {
            expression = expression.replacingOccurrences(of: " C", with: "C")
        }
        
        
        // MARK: Editing Part 2: Extra Identifiers
        
        // Some extra items need to be added in order to correctly position the text in the textView
        // This includes indicators where exponents end and roots end
        
        // Loop through the index
        index = 0
        
        while index < expression.count {
            
            let char = stringCharGet(string: expression, index: index)
            let char2 = index+1 < expression.count ? stringCharGet(string: expression, index: index+1) : Character(" ")
            let char3 = index+2 < expression.count ? stringCharGet(string: expression, index: index+2) : Character(" ")
            
            // Add exponent end
            if char == "^" {
                
                // Break if last index - still waiting for input
                if index == expression.count-1 || index == expression.count-2 {
                    break
                }
                
                // Find the end of the exponent
                var findIndex = index+2
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters after the carrot
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }

                        // End if end of string
                        if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex-1
                        break
                    }
                    
                    findIndex += 1
                }
                
                // Add the end exponent identifier
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex))
                expression.insert("v", at: expression.index(expression.startIndex, offsetBy: endIndex+1))
                
                // Remove parentheses if matching ones are the first and last items under the root
                if index+2 < expression.count && skipParentheses == 0 {
                    if stringCharGet(string: expression, index: index+2) == "(" && stringCharGet(string: expression, index: endIndex-1) == ")" {
                        var parIndex = index+3
                        var skipParentheses = 0
                        var removePar = false
                        while parIndex < endIndex-1 {
                            let item = stringCharGet(string: expression, index: parIndex)
                            if item == "(" {
                                skipParentheses += 1
                            }
                            else if item == ")" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == -1 {
                                break
                            }
                            parIndex += 1
                        }
                        if skipParentheses == 0 {
                            removePar = true
                        }
                        if removePar {
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: index+2))
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: endIndex-2))
                        }
                    }
                }
            }
            
            // Add radicand end
            if char == "√" {
                
                // Break if last index - still waiting for input
                if index == expression.count-1 {
                    break
                }
                
                // Find the end of the radicand
                var findIndex = index+2
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters after the radical
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                        
                        // End if end of string
                        if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex-1
                        break
                    }
                    
                    findIndex += 1
                }
                
                // Add the end radicand identifier
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex))
                expression.insert("`", at: expression.index(expression.startIndex, offsetBy: endIndex+1))
                
                // Remove parentheses if matching ones are the first and last items under the root
                if index+2 < expression.count && skipParentheses == 0 {
                    if stringCharGet(string: expression, index: index+2) == "(" && stringCharGet(string: expression, index: endIndex-1) == ")" {
                        var parIndex = index+3
                        var skipParentheses = 0
                        var removePar = false
                        while parIndex < endIndex-1 {
                            let item = stringCharGet(string: expression, index: parIndex)
                            if item == "(" {
                                skipParentheses += 1
                            }
                            else if item == ")" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == -1 {
                                break
                            }
                            parIndex += 1
                        }
                        if skipParentheses == 0 {
                            removePar = true
                        }
                        if removePar {
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: index+2))
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: endIndex-2))
                        }
                    }
                }
            }
            
            // Verify radical index end
            if char == "§" {
                
                // Break if last index - still waiting for input
                if index == expression.count-1 {
                    break
                }
                
                // Find the end of the radical index
                var findIndex = index+2
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters after the radical index identifier
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                        
                        // End if end of string
                        if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex-1
                        break
                    }
                    
                    findIndex += 1
                }
                
                // Remove parentheses if matching ones are the first and last items under the root
                if index+2 < expression.count && skipParentheses == 0 {
                    if stringCharGet(string: expression, index: index+2) == "(" && stringCharGet(string: expression, index: endIndex-1) == ")" {
                        var parIndex = index+3
                        var skipParentheses = 0
                        var removePar = false
                        while parIndex < endIndex-1 {
                            let item = stringCharGet(string: expression, index: parIndex)
                            if item == "(" {
                                skipParentheses += 1
                            }
                            else if item == ")" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == -1 {
                                break
                            }
                            parIndex += 1
                        }
                        if skipParentheses == 0 {
                            removePar = true
                        }
                        if removePar {
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: index+2))
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: endIndex-2))
                        }
                    }
                }
            }
            
            // Verify log base index end
            if char == "l" && char2 == "o" && char3 == "g" {
                
                // Break if last index - still waiting for input
                if index == expression.count-1 {
                    break
                }
                
                // Find the end of the log
                var findIndex = index+4
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters after the log
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                        
                        // End if end of string
                        if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex-1
                        break
                    }
                    
                    findIndex += 1
                }
                // Remove parentheses if matching ones are the first and last items under the root
                if index+4 < expression.count && skipParentheses == 0 {
                    if stringCharGet(string: expression, index: index+4) == "(" && stringCharGet(string: expression, index: endIndex-1) == ")" {
                        var parIndex = index+5
                        var skipParentheses = 0
                        var removePar = false
                        while parIndex < endIndex-1 {
                            let item = stringCharGet(string: expression, index: parIndex)
                            if item == "(" {
                                skipParentheses += 1
                            }
                            else if item == ")" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == -1 {
                                break
                            }
                            parIndex += 1
                        }
                        if skipParentheses == 0 {
                            removePar = true
                        }
                        if removePar {
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: index+4))
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: endIndex-2))
                        }
                    }
                }
            }
            
            // Add end of absolute value
            if char == "|" && char2 == "|" {
                
                // Break if last index - still waiting for input
                if index == expression.count-2 {
                    expression.append(" ª")
                }
                
                // Find the end of the absolute value
                var findIndex = index+3
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters after the absolute value
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                        
                        // End if end of string
                        if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex-1
                        break
                    }
                    
                    findIndex += 1
                }
                
                // Add the beginning abs indicator
                expression.insert("\\", at: expression.index(expression.startIndex, offsetBy: index+1))
                
                // Add the end abs
                expression.insert("|", at: expression.index(expression.startIndex, offsetBy: endIndex+1))
                expression.insert("\\", at: expression.index(expression.startIndex, offsetBy: endIndex+1))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex+1))
                
                // Remove the first 2nd abs
                expression.remove(at: expression.index(expression.startIndex, offsetBy: index+2))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: index+2))
                
                // Remove parentheses if matching ones are the first and last items under the root
                if index+4 < expression.count && skipParentheses == 0 {
                    if stringCharGet(string: expression, index: index+4) == "(" && stringCharGet(string: expression, index: endIndex) == ")" {
                        var parIndex = index+5
                        var skipParentheses = 0
                        var removePar = false
                        while parIndex < endIndex-1 {
                            let item = stringCharGet(string: expression, index: parIndex)
                            if item == "(" {
                                skipParentheses += 1
                            }
                            else if item == ")" {
                                skipParentheses -= 1
                            }
                            if skipParentheses == -1 {
                                break
                            }
                            parIndex += 1
                        }
                        if skipParentheses == 0 {
                            removePar = true
                        }
                        if removePar {
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: index+4))
                            expression.remove(at: expression.index(expression.startIndex, offsetBy: endIndex-1))
                        }
                    }
                }
            }
            
            index += 1
        }
        
        // Go back through backwards
        index = expression.count-1
        while index >= 0 {
            
            if index >= expression.count {
                index = expression.count-1
            }
            
            let char = stringCharGet(string: expression, index: index)
            
            // Add fraction beginning and end identifiers
            if char == "/" {
                
                // Find the beginning and end of the fraction
                var findIndex = index-1
                var beginningIndex = 0
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters in the numerator
                while findIndex >= 0 {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == ")" || char == "﹚" {
                        skipParentheses += 1
                    }
                    else if char == "(" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            beginningIndex = findIndex
                            break
                        }
                    }
                    
                    findIndex -= 1
                }
                
                findIndex = index+1
                skipParentheses = 0
                
                // Loop through all characters in the denominator
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                            
                        // End if a root or log indicator is found
                        else if char == "√" || char == "¶" {
                            expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: findIndex))
                            expression.insert("å", at: expression.index(expression.startIndex, offsetBy: findIndex))
                            endIndex = findIndex+1
                            break
                        }
                        
                        // End if end of string
                        else if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex
                        expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex))
                        break
                    }
                    
                    // Add a down carrot if needed
                    if char == "^" && findIndex == expression.count-1 {
                        expression.append(" ")
                        expression.append("v")
                        endIndex = findIndex+3
                        break
                    }
                    
                    findIndex += 1
                }
                    
                // Add the beginning and end fraction identifiers
                expression.insert("“", at: expression.index(expression.startIndex, offsetBy: beginningIndex))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: beginningIndex))
                expression.insert("‘", at: expression.index(expression.startIndex, offsetBy: endIndex+2))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex+2))
                
                // Add spaces around the fraction bar
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: index+2))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: index+4))
                
                // Increase the index by 3 to account for the newly inputted characters
                index += 3
            }
            
            // Add permutation and combination beginning and end identifiers
            if char == "P" || char == "C" {
                
                // Find the beginning and end of the fraction
                var findIndex = index-1
                var beginningIndex = 0
                var endIndex = expression.count
                var skipParentheses = 0
                
                // Loop through all characters in n
                while findIndex >= 0 {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == ")" || char == "﹚" {
                        skipParentheses += 1
                    }
                    else if char == "(" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            beginningIndex = findIndex
                            break
                        }
                    }
                    
                    findIndex -= 1
                }
                
                findIndex = index+1
                skipParentheses = 0
                
                // Loop through all characters in r
                while findIndex < expression.count {
                    
                    let char = stringCharGet(string: expression, index: findIndex)
                    
                    // Skip over parentheses
                    if char == "(" {
                        skipParentheses += 1
                    }
                    else if char == ")" || char == "﹚" {
                        skipParentheses -= 1
                    }
                    
                    if skipParentheses == 0 {
                            
                        // End if a space is found
                        if char == " " {
                            endIndex = findIndex
                            break
                        }
                            
                        // End if a root or log indicator is found
                        else if char == "√" || char == "¶" {
                            expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: findIndex))
                            expression.insert("å", at: expression.index(expression.startIndex, offsetBy: findIndex))
                            endIndex = findIndex+1
                            break
                        }
                        
                        // End if end of string
                        else if findIndex == expression.count-1 {
                            endIndex = findIndex+1
                            break
                        }
                    }
                    
                    if skipParentheses == -1 {
                        endIndex = findIndex
                        expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex))
                        break
                    }
                    
                    // Add a down carrot if needed
                    if char == "^" && findIndex == expression.count-1 {
                        expression.append(" ")
                        expression.append("v")
                        endIndex = findIndex+3
                        break
                    }
                    
                    findIndex += 1
                }
                    
                // Add the beginning and end permutation/combination identifiers
                expression.insert("Ó", at: expression.index(expression.startIndex, offsetBy: beginningIndex))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: beginningIndex))
                expression.insert("Ò", at: expression.index(expression.startIndex, offsetBy: endIndex+2))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: endIndex+2))
                
                // Add spaces around the P/C
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: index+2))
                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: index+4))
                
                // Increase the index by 3 to account for the newly inputted characters
                index += 3
            }
            
            index -= 1
        }
        
        
        // MARK: Editing Part 3: Degrees, Coefficients, Spacing
        
        // This section includes edits for the expression, such as removing coefficients of 1 or implied multiplication
        
        // If expression is still empty because nothing was added to it, set it to display 0
        if expression == "" {
            expression = "0"
        }
        
        // Remove double spaces
        while expression.contains("  ") {
            expression = expression.replacingOccurrences(of: "  ", with: " ")
        }
        
        // Add degrees to the end of angles if in degree mode
        var containsFunc = false
        for function in hub.functions {
            if expression.contains(function) {
                containsFunc = true
            }
        }
        if !settings.radians && containsFunc && settings.degreeSymbol {
            index = 2
            while index < expression.count {
                
                let char = stringCharGet(string: expression, index: index)
                let prevChar =  index-1 >= 0 ? stringCharGet(string: expression, index: index-1) : Character(" ")
                let prevChar2 =  index-2 >= 0 ? stringCharGet(string: expression, index: index-2) : Character(" ")
                let prevChar3 = index-3 >= 0 ? stringCharGet(string: expression, index: index-3) : Character(" ")
                let postChar = index+2 < expression.count ? stringCharGet(string: expression, index: index+1) : Character(" ")
                
                let prev3 = String(prevChar2) + String(prevChar) + String(char)
                let prev4 = prevChar3 != " " ? String(prevChar3) + String(prevChar2) + String(prevChar) + String(char) : " "
                
                if (["sin","cos","tan","cot","sec","csc"].contains(prev3) && postChar != "⁻" && postChar != "h") || (["sinh","cosh","tanh","coth","sech","csch"].contains(prev4) && postChar != "⁻") {
                    var degIndex = index+2
                    
                    var skipParentheses = 0
                    while degIndex < expression.count {
                        let degIndexChar = stringCharGet(string: expression, index: degIndex)
                        
                        if degIndexChar == "(" || degIndexChar == "“" {
                            skipParentheses += 1
                        }
                        else if degIndexChar == ")" || degIndexChar == "﹚" || degIndexChar == "‘" {
                            skipParentheses -= 1
                        }
                        
                        if skipParentheses == 0 {
                            if degIndexChar == " " {
                                expression.insert("º", at: expression.index(expression.startIndex, offsetBy: degIndex))
                                expression.insert(" ", at: expression.index(expression.startIndex, offsetBy: degIndex))
                                break
                            }
                            else if degIndex == expression.count-1 && !(["√","`","v"].contains(degIndexChar)) {
                                expression.append(" ")
                                expression.append("º")
                                break
                            }
                            else if degIndexChar == "√" || degIndexChar == "¶" {
                                break
                            }
                        }
                        
                        degIndex += 1
                    }
                    
                    // Add parentheses around the value if necessary
                    var degValue = ""
                    var degValueIndex = index+2
                    while degValueIndex <= degIndex && degValueIndex < expression.count {
                        
                        if degValueIndex < expression.count {
                            degValue += String(stringCharGet(string: expression, index: degValueIndex))
                        }
                        
                        degValueIndex += 1
                    }
                    
                    var addDegPar = false
                    if degValue.contains("*") || degValue.contains("/") {
                        addDegPar = true
                    }
                    if degValue.first == "(" {
                        addDegPar = false
                    }
                    
                    if addDegPar {
                        expression.insert(contentsOf: ["("," "], at: expression.index(expression.startIndex, offsetBy: index+2))
                        if degIndex+4 < expression.count {
                            if String(stringCharGet(string: expression, index: degIndex+4)) == "º" {
                                expression.insert(contentsOf: [" ",")"," "], at: expression.index(expression.startIndex, offsetBy: degIndex+4))
                            }
                        }
                        if degIndex+3 < expression.count {
                            if String(stringCharGet(string: expression, index: degIndex+3)) == "º" {
                                expression.insert(contentsOf: [" ",")"," "], at: expression.index(expression.startIndex, offsetBy: degIndex+3))
                            }
                        }
                        if degIndex+2 < expression.count {
                            if String(stringCharGet(string: expression, index: degIndex+2)) == "º" {
                                expression.insert(contentsOf: [" ",")"," "], at: expression.index(expression.startIndex, offsetBy: degIndex+2))
                            }
                        }
                    }
                }
                index += 1
            }
        }
        
        // Replace log e with ln
        if expression.contains("log #e ¶") {
            expression = expression.replacingOccurrences(of: "log #e ¶", with: "ln")
        }
        
        // Remove invisible negative 1 coefficients
        if expression.contains("-01*") {
            expression = expression.replacingOccurrences(of: "-01*", with: "-")
        }
        // Remove invisible 1 coefficients
        if expression.contains(" 01*") {
            expression = expression.replacingOccurrences(of: " 01*", with: " ")
        }
        if expression.contains("(01*") {
            expression = expression.replacingOccurrences(of: "(01*", with: "(")
        }
        
        // Remove coefficient multipliers altogether
        if expression.contains("*") {
            expression = expression.replacingOccurrences(of: "*", with: "")
        }
        
        // Add a space after radical end indicators
        if expression.contains("`") {
            expression = expression.replacingOccurrences(of: "`", with: "` ")
        }
        
        // Fix dots and commas based on settings
        if settings.spaceSeparators {
            expression = expression.replacingOccurrences(of: ",", with: " ")
        }
        if settings.commaDecimal {
            expression = expression.replacingOccurrences(of: ".", with: "D")
            expression = expression.replacingOccurrences(of: ",", with: ".")
            expression = expression.replacingOccurrences(of: "D", with: ",")
        }
        
        // Remove double spaces
        while expression.contains("  ") {
            expression = expression.replacingOccurrences(of: "  ", with: " ")
        }
        
        // Remove the first character if it is a space
        if expression.first == " " {
            expression.removeFirst()
        }
        
        // Print the expression
//        print(expression)
        
        // Return the expression
        return expression
        
    }
    
    
    // MARK: - Split Expression
    
    // The expression will be split into an array, so each piece can be evaluated independently once it is sent to the textView
    func splitExpression(_ expression: String) -> Array<String> {
        
        var expressionArray = [String]()
        
        // Return if it is just a space
        if expression == " " {
            return [" "]
        }
        
        // Loop through the expression
        var index = 0
        var split = ""
        while index < expression.count {
            
            let char = stringCharGet(string: expression, index: index)
            
            // Split if a space is found
            if char == " " {
                
                // Add the split piece to the expression array
                expressionArray += [split]
                split = ""
            }
                
            // If another character is found
            else {
                
                // Add the character to the next piece being split
                split += String(char)
            }
            
            index += 1
        }
        
        // Add the final split once the entire expression has been done
        if split != "" {
            expressionArray += [split]
        }
        
        return expressionArray
    }
    
    
    // MARK: - Edit Number
    
    // Add Commas
    // Add commas to separate thousands places
    func addCommas(_ string: String) -> String {
        
        if !settings.commaSeparators && !settings.spaceSeparators {
            return string
        }
        
        // Create a new string
        var newString = string
        
        // Make sure the string contains numbers
        var containsNum = false
        for number in hub.numbers {
            if newString.contains(number) {
                containsNum = true
            }
        }
        for op in hub.operators+hub.operators2+hub.functions+hub.numbers2+["E"] {
            if newString.contains(op) && op != "-" {
                containsNum = false
            }
        }
        if containsNum == true {
            
            // Make sure the string does not already have commas in it
            if !newString.contains(",") && !newString.contains(" ") {
                    
                // Find the index of the decimal point
                var decimalIndex = 0
                if newString.contains(".") {
                    decimalIndex = stringCharIndex(string: newString, character: ".", position: "first")
                }
                else if newString.contains("%") {
                    decimalIndex = stringCharIndex(string: newString, character: "%", position: "first")
                }
                else {
                    decimalIndex = newString.count
                }
                
                // Create a new comma index to insert the commas
                var commaIndex = decimalIndex
                
                // Loop through all characters before the decimal point, inserting a comma every 3 places
                while commaIndex >= 4 {
                    
                    // Go back 3 places
                    commaIndex -= 3
                    
                    // Insert a comma
                    newString.insert(",", at: newString.index(newString.startIndex, offsetBy: commaIndex))
                }
                
                // Remove comma if it comes after a space
                if newString.contains(" ,") {
                    newString = newString.replacingOccurrences(of: " ,", with: " ")
                }
                
                // Remove unintended comma after negative sign
                newString = newString.replacingOccurrences(of: "-,", with: "-")
                
            }
        }
        
        // Return the string
        return newString
    }
    
    
    // Fix Zero
    // Fix unnecessary zeroes and decimals
    func fixZero(string:String,all:Bool) -> String {
        guard !string.isEmpty else {
            return ""
        }
            
        guard !string.contains(" "), !string.contains("e+"), !string.contains("e-") else {
            return string
        }
        
        // Create a new string
        var newString = string
        
        // Remove zeroes from beginning if a decimal point does not follow (and 0 is not the only digit)
        if String(string.prefix(1)) == "0" && String(string.prefix(2)) != "0." && string != "0" {
            newString.removeFirst()
        }
        else if String(string.prefix(2)) == "-0" && String(string.prefix(3)) != "-0." && string != "-0" {
            newString.remove(at: newString.firstIndex(of: "0")!)
        }
        
        // Add zero before decimal point
        if String(string.prefix(1)) == "." {
            newString.insert("0", at: string.startIndex)
        }
        
        // Add zero after negative if the string is just a negative
        if newString == "-" {
            newString = "-0"
        }
        
        // Stop and return now if all is false
        // Proceed for hardcore
        if all == false {
            return newString
        }
        
        // Remove decimal point and decimal zeroes if nothing follows them
        if newString.contains(".") {
            
            // Remove the last digit if it is a 0, until it is not a 0
            while newString.last == "0" {
                newString.removeLast()
            }
            
            // Remove the decimal point if nothing follows it
            if newString.last == "." {
                newString.removeLast()
            }
        }
        
        // Remove negative from 0
        if newString == "-0" {
            newString = "0"
        }
        
        // Change "inf" or "nan"
        if newString == "inf" || newString == "nan" {
            newString = "∞"
            return newString
        }

        // Return the new string
        return newString
    }
    
    
    // MARK: - String Editing
    
    // String Char Index
    // Get index of a character in a string (returns int)
    func stringCharIndex(string:String,character:Character,position:String) -> Int {
        
        // Make sure the character is somewhere in the string
        if string.contains(character) {
            
            // Look for first occurrence of the character
            if position == "first" {
                
                // Find first index of character
                let charIndex = string.firstIndex(of: character)
                // Find distance between start index to character index
                let distance = string.distance(from: string.startIndex, to: charIndex!)
                
                return distance
            }
            
            // Look for last occurrence of the character
            else if position == "last" {
                
                // Find last index of character
                let charIndex = string.lastIndex(of: character)
                // Find distance between start index to character index
                let distance = string.distance(from: string.startIndex, to: charIndex!)
                
                return distance
            }
                
            else {
                return -1
            }
        }
        else {
            return -1
        }
    }
    
    
    // String Char Get
    // Get the character at an index in a string
    func stringCharGet(string:String,index:Int) -> Character {
        
        // Return an empty character if the string is empty
        if string.isEmpty {
            return Character("")
        }
        
        // Get the difference between the character index and the start index
        let charIndex = string.index(string.startIndex, offsetBy: index)
        
        // Return the character at that index
        return string[charIndex]
    }
    
}
