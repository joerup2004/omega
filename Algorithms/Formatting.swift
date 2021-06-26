//
//  Formatting.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/21/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

// Formatting
// Form and format the text to be outputted
// The formatted text is then sent to TextView to be displayed
class Formatting: ObservableObject {
    
    static let formatting = Formatting()
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    
    var fullFormattingGuide = [[String]]()
    
    var size: CGFloat = 0
    var topPad: CGFloat = 0
    var bottomPad: CGFloat = 0
    var leftPad: CGFloat = 0
    var rightPad: CGFloat = 0
    var color: Color = Color.white
    var colorAlt: Color = Color.white
    var opacity: Double = 0
    var opacityAlt: Double = 0
    var vinculums: AnyView? = nil
    
    var guidelines = false
    
    
    // MARK: - Form

    // Form
    // Create a view for each piece of text
    func form(text: String, inputSize: CGFloat, position: String, index: Int, array: Array<String>, formatting: [[String]]) -> AnyView? {

        let item = text
        
        // Format the text view
        let totalWidth = format(item, inputSize: inputSize, position: position, index: index, array: array, formatting: formatting, padded: false)
        
        // Do not make views for items which are edited to nothing
        if (edit(item, index, array) == "" || edit(item, index, array) == " " || edit(item, index, array) == "  ") && item != "ª" {
            return nil
        }

        // Update the text view
        let textView = MakeUILabel(text: edit(item + " ", index, array), size: size, position: position, guidelines: guidelines)
        
        // Put everything together
        let view =
            AnyView(
                ZStack {
                    
                    vinculums
                        .foregroundColor(colorAlt)
                        .opacity(opacityAlt)
                        .frame(width: totalWidth > 0 ? totalWidth : 0, height: inputSize)
                    
                    textView
                        .foregroundColor(color)
                        .opacity(opacity)
                        .frame(height: inputSize)
                        .padding(.top, topPad)
                        .padding(.bottom, bottomPad)
                    
                }
                .frame(width: totalWidth > 0 ? totalWidth : 0, height: inputSize)
                .padding(.leading, leftPad)
                .padding(.trailing, rightPad)
                .fixedSize()
                .border(Color.blue, width: guidelines ? 0.3 : 0)
            )
        
        return view

    }
    
    
    // MARK: - Format
    
    // Format
    // Determine the format for each piece of text
    func format(_ item: String, inputSize: CGFloat, position: String, index: Int, array: Array<String>, formatting: [[String]], padded: Bool) -> CGFloat {
        
        // Create the formatting guide
        let formattingGuide = index < formatting.count ? formatting[index] : [""]
        
        // Find the previous and next items in the array if they exist
        var next: String? = nil
        var prev: String? = nil
        var prev2: String? = nil
        var prev3: String? = nil
        var nextV: String? = nil
        var prevV: String? = nil
        
        let edited = edit(item, index, array)
        
        let skippers = ["v","§","`","¶","“","/","‘","Ó","Ò"]
        
        var nextIndex = index+1
        while nextIndex < array.count {
            let item = array[nextIndex]
            if next == nil {
                next = array[nextIndex]
            }
            if !skippers.contains(item) && !item.contains("#") {
                nextV = array[nextIndex]
                break
            }
            nextIndex += 1
        }
        var prevIndex = index-1
        while prevIndex >= 0 {
            let item = array[prevIndex]
            if prev == nil {
                prev = array[prevIndex]
            }
            if !skippers.contains(item) && !item.contains("#") {
                prevV = array[prevIndex]
                break
            }
            prevIndex -= 1
        }
        if index-2 >= 0 {
            prev2 = array[index-2]
        }
        if index-3 >= 0 {
            prev3 = array[index-3]
        }
        
        // MARK: Set Sizes and Padding
        
        // Reset the formatting for the character
        size = inputSize
        bottomPad = 0
        topPad = 0
        leftPad = 0
        rightPad = 0
        vinculums = nil
        
        var leftPad1: CGFloat = 0
        var rightPad1: CGFloat = 0
        
        // Set the formatting for the character
        var formattingIndex = 0
        while formattingIndex < formattingGuide.count {
            let format = formattingGuide[formattingIndex]
            
            // Exponent
            if format == "EXP" {
                bottomPad += size*0.5
                size *= 0.5
                if prev != "√" {
                    leftPad1 = -size*0.05
                    if next != "v" && !(next ?? "").contains(" ̅") {
                        rightPad1 = -size*0.05
                    }
                }
                if prev == "^" || item == "^" {
                    leftPad1 = -size*0.25
                }
            }
            
            // Radical Index
            if format == "RINX" {
                bottomPad += size*0.55
                size *= 0.45
                if prev2 == "^" {
                    leftPad1 = -size*0.4
                }
                else {
                    leftPad1 = -size*0.05
                }
                if nextV == "√" && item != "v" {
                    rightPad1 = -size*0.6
                }
                else {
                    if prev2 == "^" {
                        rightPad1 = 0
                    }
                    else if !(next ?? "").contains(" ̅") {
                        rightPad1 = -size*0.05
                    }
                }
            }

            // Radical
            if format == "RADC" {
                bottomPad += size*(settings.textWeight == 0 ? 0.165 : self.settings.textWeight == 1 ? 0.155 : 0.175)
                size *= 1.0205
                if prev != "#2" {
                    if prev3 == "^" {
                        leftPad = -size*0.1
                    }
                    else if (prev ?? "").contains(" ̅") {
                        leftPad = -size*0.4
                    }
                    else {
                        leftPad = -size*0.15
                    }
                }
                else {
                    if prev3 == "^" {
                        leftPad = -size*0.25
                    }
                    else if prevV == "(" {
                        leftPad = -size*0.15
                    }
                    else {
                        leftPad = -size*0.05
                    }
                }
                if index != array.count-1 {
                    rightPad = -1*size*0.2
                }
            }
            
            // Radicand (Under Root)
            if format == "ROOT" {
                vinculum()
                topPad += size*0.07
                size *= 0.93
            }
            
            // Log Index
            if format == "LINX" {
                topPad += size*0.5
                size *= 0.5
                if prev != "√" {
                    if prev == "log" {
                        leftPad1 = -size*0.2
                    }
                    else {
                        leftPad1 = -size*0.05
                    }
                    if !(next ?? "").contains(" ̅") {
                       rightPad1 = -size*0.05
                    }
                }
            }
            
            // Numerator
            if format == "NUME" {
                bottomPad += size*0.4
                size *= 0.6
                if prev != "√" {
                    leftPad1 = -size*0.075
                    if !(next ?? "").contains(" ̅") {
                        rightPad1 = -size*0.075
                    }
                }
                if prev == "“" {
                    leftPad1 = size*0.1
                    if prev2 == "^" {
                        leftPad1 = -size*0.4
                    }
                }
            }
            
            // Fraction Bar
            if format == "FRAC" {
                leftPad += -size*0.2
                rightPad += -size*0.2
            }
            
            // Denominator
            if format == "DNOM" {
                topPad += size*0.4
                size *= 0.6
                if prev != "√" {
                    leftPad1 = -size*0.075
                    if !(next ?? "").contains(" ̅") {
                        rightPad1 = -size*0.075
                    }
                }
                if next == "‘" {
                    rightPad1 = size*0.1
                }
                if nextV == "√" {
                    rightPad1 = -size*0.7
                }
            }
            
            // Permutation/Combination n
            if format == "PCn" {
                topPad += size*0.5
                size *= 0.5
                if nextV == "P" || nextV == "C" {
                    rightPad1 = -size*0.3
                }
                if prev == "Ó" {
                    leftPad1 = size*0.2
                }
            }
            
            // Permutation/Combination r
            if format == "PCr" {
                topPad += size*0.5
                size *= 0.5
                if prevV == "P" {
                    leftPad1 = -size*0.4
                }
                else if prevV == "C" {
                    leftPad1 = -size*0.3
                }
                if next == "Ò" {
                    rightPad1 = size*0.2
                }
            }
            
            // Infinity
            if format == "INF" {
                bottomPad += size*0.25
                rightPad = -size*0.2
                size *= 1.5
            }
            
            formattingIndex += 1
        }
        
        // Degree Symbol
        if item == "º" {
            leftPad1 = -size*0.3
        }
        
        // Exponential
        if item == "E" {
            leftPad1 = -size*0.2
            if (nextV != nil && nextV != ")" && nextV != "﹚" && next != "^") || (next == "§" || next == "¶") {
                rightPad1 = -size*0.2
            }
            topPad += size*0.1
            size *= 0.85
        }
        else if item == "×10" {
            leftPad1 = -size*0.27
        }
        
        // Repeater
        if item.contains(" ̅") {
            leftPad1 = -size*0.155 - size*0.55 * CGFloat(item.count)
            vinculum()
        }
        
        // Parentheses after function
        if item == "(" && prevV != nil {
            if (hub.functions+[")"]).contains(prevV!) {
                leftPad1 = -size*0.2
            }
        }
        
        leftPad += leftPad1
        rightPad += rightPad1
        
        // Shrink parentheses
        if item.contains("(") {
            let shrink = shrinkParentheses(text: "(", index: index, array: array)
            rightPad = -size*shrink
        }
        else if item.contains(")") {
            let shrink = shrinkParentheses(text: ")", index: index, array: array)
            leftPad = -size*shrink
        }
        else if item.contains("﹚") {
            let shrink = shrinkParentheses(text: "﹚", index: index, array: array)
            leftPad = -size*shrink
        }
        else if item.contains("|\\") {
            let shrink = shrinkParentheses(text: "|\\", index: index, array: array)
            rightPad = -size*shrink
            leftPad += size*0.1
        }
        else if item.contains("\\|") {
            let shrink = shrinkParentheses(text: "\\|", index: index, array: array)
            leftPad = -size*shrink
            rightPad += size*0.1
        }
        
        // Set the color and opacity
        if position == "main" {
            if item == "﹚" {
                color = Color.init(white:0.7)
                opacity = 0.3
                colorAlt = Color.white
                opacityAlt = 1
            }
            else if edited.contains("∂") {
                opacity = 0//.7
                colorAlt = Color.white
                opacityAlt = 1
            }
            else {
                color = Color.white
                opacity = 1
                colorAlt = Color.white
                opacityAlt = 1
            }
        }
        else {
            if edited.contains("∂") {
                opacity = 0
                colorAlt = Color.init(white: 0.7)
                opacityAlt = 1
            }
            else {
                color = Color.init(white: 0.7)
                opacity = 1
                colorAlt = Color.init(white: 0.7)
                opacityAlt = 1
            }
        }
        
        // Edit the item text
        let editedText = edit(item + " ", index, array)
        
        // Return if empty
        if (editedText == "" || editedText == " " || editedText == "   ") && item != "å" && item != "ª" {
            return 0
        }
        
        // Create a label (used for resize function) and return the width
        let label = UILabel()
        label.text = editedText
        label.font = UIFont(name: "HelveticaNeue-Bold", size: size)
        label.textAlignment = .center
        label.numberOfLines = 1

        let displayWidth = label.intrinsicContentSize.width
        let paddedWidth = label.intrinsicContentSize.width + leftPad + rightPad
        
        if padded {
            return paddedWidth
        }
        return displayWidth
    }
    
    
    // MARK: - Create Formatting Guide
    // Create formatting guide
    func createFormattingGuide(array: [String]) -> [[String]] {
        
        if array.isEmpty {
            return [[""]]
        }
        
        var arrayFormattingGuide = [[String]]()
        var formattingGuide = [String]()
        var formattingGuideAddAfter = [String]()
        
        arrayFormattingGuide = [[""]]
        
        var index = 0
        while index < array.count {
            
            let item = array[index]
            
            // Remove single-use formatters
            if formattingGuide.last == "RADC" || formattingGuide.last == "FRAC" {
                formattingGuide.removeLast()
            }
            
            // Add add-afters
            if !formattingGuideAddAfter.isEmpty {
                formattingGuide += formattingGuideAddAfter
                formattingGuideAddAfter = []
            }
            
            // Update the formatting guide
            if item == "^" {
                formattingGuide += ["EXP"]
            }
            else if item == "v" {
                if formattingGuide.contains("EXP") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "EXP")!))
                }
            }
            else if item == "§" {
                formattingGuide += ["RINX"]
            }
            else if item == "√" {
                formattingGuide += ["RADC"]
                formattingGuideAddAfter += ["ROOT"]
                if formattingGuide.contains("RINX") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "RINX")!))
                }
            }
            else if item == "`" {
                if formattingGuide.contains("ROOT") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "ROOT")!))
                }
            }
            else if item == "log" {
                formattingGuideAddAfter += ["LINX"]
            }
            else if item == "¶" {
                if formattingGuide.contains("LINX") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "LINX")!))
                }
            }
            else if item == "“" {
                formattingGuide += ["NUME"]
            }
            else if item == "/" {
                formattingGuide += ["FRAC"]
                formattingGuideAddAfter += ["DNOM"]
                if formattingGuide.contains("NUME") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "NUME")!))
                }
            }
            else if item == "‘" {
                if formattingGuide.contains("DNOM") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "DNOM")!))
                }
            }
            else if item == "Ó" {
                formattingGuide += ["PCn"]
            }
            else if item == "P" || item == "C" {
                formattingGuideAddAfter += ["PCr"]
                if formattingGuide.contains("PCn") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "PCn")!))
                }
            }
            else if item == "Ò" {
                if formattingGuide.contains("PCr") {
                    formattingGuide.remove(at: formattingGuide.distance(from: formattingGuide.startIndex, to: formattingGuide.lastIndex(of: "PCr")!))
                }
            }
            else if item == "∞" {
                formattingGuide = ["INF"]
            }
            else if item == "=" {
                formattingGuide = []
                formattingGuideAddAfter = []
            }
            
            arrayFormattingGuide += [formattingGuide]
            
            index += 1
        }
        
        return arrayFormattingGuide
    }

    
    // MARK: - Edit
    
    // Edit
    // Edit text to remove behind-the-scenes indicators
    func edit(_ text: String, _ index: Int, _ array: Array<String>) -> String {
        
        var newText = text
        if newText.last == " " {
            newText.removeLast()
        }
        
        if newText == "~" {
            return ""
        }
        else if newText == "^" && index != array.count-1 {
            if index+2 < array.count {
                if array[index+2] == "√" {
                    return text
                }
            }
            if index+1 < array.count {
                if array[index+1] == "v" || array[index+1] == "`" {
                    return text
                }
            }
            return ""
        }
        else if newText == "v" {
            return ""
        }
        else if newText == "§" {
            return ""
        }
        else if newText == "`" {
            return ""
        }
        else if newText == "¶" {
            return ""
        }
        else if newText == "“" {
            return ""
        }
        else if newText == "‘" {
            return ""
        }
        else if newText == "Ó" {
            return ""
        }
        else if newText == "Ò" {
            return ""
        }
        else if newText == "xb" {
            return ""
        }
        else if newText == "﹚" {
            return ") "
        }
        else if newText == "|\\" {
            return "|"
        }
        else if newText == "\\|" {
            return "|"
        }
        else if newText == "ª" {
            return "  "
        }
        else if newText.contains(" ̅") {
            var newerText = newText.replacingOccurrences(of: " ̅", with: "0")
            newerText.removeLast()
            return "∂" + newerText
        }
        else if newText == "#2" {
            if index-1 >= 0 && index+1 < array.count {
                if array[index-1] == "§" && array[index+1] == "√" {
                    return ""
                }
            }
            return text
        }
        else if newText.contains("#") {
            return ""
        }
        else if newText == "å" {
            return ""
        }
        else {
            return text
        }
    }
    
    
    // a
    // Add a tilda to the array to signify the beginning
    func a(_ array: Array<String>) -> Array<String> {
        
        var newArray = array
        
        if newArray.isEmpty {
            newArray = [" "]
        }
        
        newArray.insert("~", at: newArray.startIndex)
        
        return newArray
    }
    
    
    // Shrink Parentheses
    // Shrink parentheses if there is only a single item between them
    func shrinkParentheses(text: String, index: Int, array: [String]) -> CGFloat {
        
        var shrink: CGFloat = 0.25
        
        if text == "(" || text == "|\\" {
            var parIndex = index+1
            while parIndex < array.count {
                
                let item = array[parIndex]
                
                if (hub.operators+hub.operators2+hub.functions+["(","E"]).contains(item) {
                    shrink = 0.1
                    break
                }
                
                if item.contains(")") || item.contains("﹚") || item.contains("\\|") {
                    if parIndex == index+1 {
                        shrink = 0
                    }
                    break
                }
            
                parIndex += 1
            }
        }
        
        else if text == ")" || text == "﹚" || text == "\\|" {
            var parIndex = index-1
            while parIndex >= 0 {
                
                let item = array[parIndex]
                
                if (hub.operators+hub.operators2+hub.functions+[")","﹚","E"]).contains(item) {
                    shrink = 0.1
                    break
                }
                
                if item.contains("(") || item.contains("|\\") {
                    if parIndex == index-1 {
                        shrink = 0
                    }
                    break
                }
            
                parIndex -= 1
            }
        }
        
        if text.contains("|") {
            shrink *= 0.6
        }
        
        return shrink
    }
    
    
    // MARK: - Special Views
    
    // MARK: Vinculum
    // Create a vinculum for radical
    func vinculum(percent: Double = 1) {
        
        let vinculumView = AnyView(
            ZStack {
                vinculums
                
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: size*(self.settings.textWeight == 0 ? 0.06 : self.settings.textWeight == 1 ? 0.09 : 0.11), alignment: .center)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.top, topPad)
                        .padding(.bottom, bottomPad)
                    Spacer()
                }
                .frame(height: size+bottomPad+topPad)
                .border(Color.red, width: guidelines ? 0.3 : 0)
            }
        )

        vinculums = vinculumView
    }
}


// MARK: - Make UI Label

// Make UI Label
// Create the label which will hold the text
struct MakeUILabel: UIViewRepresentable {
    
    @ObservedObject var settings = Settings.settings
    
    var text: String
    var size: CGFloat
    var position: String
    var guidelines: Bool = false
    
    func makeUIView(context: Context) -> UILabel {
        
        let view = UILabel()
        return view
        
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        
        uiView.text = text
        uiView.font = UIFont(name: "HelveticaNeue\(self.settings.textWeight == 0 ? "-Light" : self.settings.textWeight == 2 ? "-Bold" : "")", size: size)
        uiView.textAlignment = .center
        uiView.numberOfLines = 1
        uiView.textColor = position == "main" ? .white: .init(white: 0.7, alpha: 1)
        
        uiView.frame = CGRect(x:0, y:0, width: uiView.intrinsicContentSize.width, height: uiView.intrinsicContentSize.height)
        uiView.lineBreakMode = NSLineBreakMode(rawValue: 1)!
        
        // TEST MODE
        if guidelines {
            uiView.layer.borderColor = UIColor.green.cgColor
            uiView.layer.borderWidth = 0.3
        }
    }
}
