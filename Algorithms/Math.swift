//
//  Math.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/16/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

// Math
// Calculate the result of an operation and return it
// Used by Calculate to do the actual operations
class Math {
    
    static let math = Math()
    
    @ObservedObject var settings = Settings.settings
    
    // MARK: - Basic Operations
    
    // Addition
    func add(_ addend1: Double, _ addend2: Double) -> Double {
        
        var sum: Double
        
        sum = addend1 + addend2
        
        return sum
    }
    
    // Subtraction
    func subtract(_ minuend: Double, _ subtrahend: Double) -> Double {
        
        var difference: Double
        
        difference = minuend - subtrahend
        
        return difference
    }
    
    // Multiplication
    func multiply(_ factor1: Double, _ factor2: Double) -> Double {
        
        var product: Double
            
        product = factor1 * factor2
        
        return product
    }
    
    // Division
    func divide(_ dividend: Double, _ divisor: Double) -> Double {
        
        var quotient: Double
            
        quotient = dividend / divisor
        
        return quotient
    }
    
    
    // MARK: - Advanced Operations
    
    // Exponent
    func exponent(base: Double, power: Double) -> Double {
        
        var result: Double
        
        result = pow(base, power)
        
        return result
    }
    
    // Root
    func root(radicand: Double, index: Double) -> Double {
        
        var result: Double
        
        if (radicand < 0 && isDivisible(Double(index), 2) == false) {
            result = -pow(-radicand, 1/index)
        } else {
            result = pow(radicand, 1/index)
        }
        
        return result
    }
    
    // Exponential
    func exponential(coefficient: Double, exponent: Double) -> Double {
        
        var result: Double
        
        if Double(Int(exponent)) == exponent {
        
            let exponentForm = String(coefficient) + "e" + String(Int(exponent))
            
            if Double(exponentForm) != nil {
                
                result = Double(exponentForm)!
            }
            else {

                result = coefficient * pow(10, exponent)
            }
        }
        else {
            
            result = coefficient * pow(10, exponent)
        }
        
        return result
    }
    
    // Modulo
    func modulo(_ dividend: Double, _ divisor: Double) -> Double {
        
        var result: Double
        
        result = dividend.truncatingRemainder(dividingBy: divisor)
        
        return result
    }
    
    
    // MARK: - Functions
    
    // Absolute Value
    func absoluteValue(_ num: Double) -> Double {
        
        var result: Double
        
        result = abs(num)
        
        return result
    }
    
    // Rounding
    func roundFunc(_ num: Double) -> Double {
        
        var result: Double
        
        result = round(num)
        
        return result
    }
    
    // Floor
    func floorFunc(_ num: Double) -> Double {
        
        var result: Double
        
        result = floor(num)
        
        return result
    }
    
    // Ceil
    func ceilFunc(_ num: Double) -> Double {
        
        var result: Double
        
        result = ceil(num)
        
        return result
    }
    
    // Trig
    func trig(function: String, angle: Double) -> Double {
        
        var result: Double
        
        if function == "sin" {
            result = sin(angle)
        }
        else if function == "cos" {
            result = cos(angle)
        }
        else if function == "tan" {
            result = tan(angle)
        }
        else if function == "cot" {
            result = 1/tan(angle)
        }
        else if function == "sec" {
            result = 1/cos(angle)
        }
        else if function == "csc" {
            result = 1/sin(angle)
        }
        else if function == "sinh" {
            result = sinh(angle)
        }
        else if function == "cosh" {
            result = cosh(angle)
        }
        else if function == "tanh" {
            result = tanh(angle)
        }
        else if function == "coth" {
            result = 1/tanh(angle)
        }
        else if function == "sech" {
            result = 1/cosh(angle)
        }
        else if function == "csch" {
            result = 1/sinh(angle)
        }
        else {
            result = 0
        }
        
        if abs(result) >= pow(10,10) {
            result = Double.infinity
        }
        else if abs(result) <= pow(10,-10) {
            result = 0
        }
        
        return result
    }
    
    // Inverse Trig
    func itrig(function: String, value: Double) -> Double {
        
        var result: Double
        
        if function == "sin" {
            result = asin(value)
        }
        else if function == "cos" {
            result = acos(value)
        }
        else if function == "tan" {
            result = atan(value)
        }
        else if function == "cot" {
            result = atan(1/value)
        }
        else if function == "sec" {
            result = acos(1/value)
        }
        else if function == "csc" {
            result = asin(1/value)
        }
        else if function == "sinh" {
            result = asinh(value)
        }
        else if function == "cosh" {
            result = acosh(value)
        }
        else if function == "tanh" {
            result = atanh(value)
        }
        else if function == "coth" {
            result = atanh(1/value)
        }
        else if function == "sech" {
            result = acosh(1/value)
        }
        else if function == "csch" {
            result = asinh(1/value)
        }
        else {
            result = 0
        }
        
        return result
    }
    
    // Logarithm
    func logarithm(base: Double, value: Double) -> Double {
        
        var result: Double
        
        result = log(value) / log(base)
        
        return result
    }
    
    // Factorial
    func factorial(_ num: Double) -> Double {
        
        var result: Double
        
        if num == 0 {
            result = 1
        }
        else if num > 200 {
            result = Double.infinity
        }
        else {
            var index = num
            result = 1
            while index > 0 {
                result *= index
                index -= 1
            }
        }
        
        return result
    }
    
    // Permutation
    func permutation(n: Double, r: Double) -> Double {
        
        var result: Double
        
        if r > n {
            result = 0
        }
        else if r > 2000 || n > pow(10,15) {
            result = Double.infinity
        }
        else {
            var index = n
            result = 1
            while index > n-r {
                result *= index
                index -= 1
            }
        }
        
        return result
    }
    
    // Combination
    func combination(n: Double, r: Double) -> Double {
        
        var result: Double
        
        if r > n {
            result = 0
        }
        else if r > 2000 || n > pow(10,15) {
            result = Double.infinity
        }
        else {
            var nindex = n
            var rindex = r
            result = 1
            while nindex > n-r {
                result *= nindex / rindex
                nindex -= 1
                rindex -= 1
            }
        }
        
        return result
    }
    
    // Summation
    func summation(min: Double, max: Double) -> Double {
        
        //var result: Double
        
        return 0
    }
    
    // MARK: - Other
    
    // Round
    func rounding(_ value: Double) -> Double {
        
        var result: Double
        
        var multiplier: Double = pow(10, Double(self.settings.roundPlaces))
        
        var whole = round(value * multiplier)
        
        while abs(whole) >= pow(10,10) {
            multiplier /= 10
            whole = round(value * multiplier)
        }
        
        result = whole / multiplier
        
        return result
    }
    
    
    // MARK: - Boolean Tests
    
    // Approximate
    // Determine if two numbers are within 0.001 of each other
    func isApproximately(_ num1: Double, _ num2: Double) -> Bool {
        if num1 - num2 < 0.00001 && num1 - num2 > -0.00001 {
            return true
        }
        else {
            return false
        }
    }
    
    // Divisibility
    // Determine if a number is divisible by another within 0.001
    func isDivisible(_ num1: Double, _ num2: Double) -> Bool {
        
        let remainder = num1.truncatingRemainder(dividingBy: num2)
        
        if abs(remainder) < 0.00001 || (abs(remainder) > num2-0.00001 && abs(remainder) < num2+0.00001) {
            return true
        }
        else {
            return false
        }
    }
}
