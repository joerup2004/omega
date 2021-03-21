//
//  Settings.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

class Settings: ObservableObject {
    
    static let settings = Settings()
    
    @Published var calculatorType = "regular"
    
    @Published var showMenu = false
    @Published var showCalculations = false
    
    @Published var buttonSection: Int = 0
    
    @Published var radians: Bool = UserDefaults.standard.bool(forKey: "radians") {
        didSet {
            UserDefaults.standard.set(self.radians, forKey: "radians")
            refresh()
        }
    }
    
    // Interface
    @Published var theme = getSavedTheme()
        ??
        Theme(id: 0,
            name: "Classic Blue",
            category: "Basic",
            color1: [040,130,240], // Light Blue
            color2: [230,120,020], // Orange
            color3: [030,080,180], // Dark Blue
            color4: [026,070,170], // Darker Blue
            gray: 0.7
        ) {
        didSet {
            UISwitch.appearance().onTintColor = UIColor(red: theme.color1[0]/255, green: theme.color1[1]/255, blue: theme.color1[2]/255, alpha: 1)
        }
    }
    @Published var layoutExpanded: Bool = UserDefaults.standard.bool(forKey: "layoutExpanded") {
        didSet {
            UserDefaults.standard.set(self.layoutExpanded, forKey: "layoutExpanded")
        }
    }
    
    // Results
    @Published var roundPlaces: Int = UserDefaults.standard.integer(forKey: "roundPlaces") {
        didSet {
            UserDefaults.standard.set(self.roundPlaces, forKey: "roundPlaces")
        }
    }
    @Published var displayAltResults: Bool = UserDefaults.standard.bool(forKey: "displayAltResults") {
        didSet {
            UserDefaults.standard.set(self.displayAltResults, forKey: "displayAltResults")
        }
    }
    @Published var displayAllAltResults: Bool = UserDefaults.standard.bool(forKey: "displayAllAltResults") {
        didSet {
            UserDefaults.standard.set(self.displayAllAltResults, forKey: "displayAllAltResults")
        }
    }
    
    // Buttons
    @Published var smartDegRad: Bool = UserDefaults.standard.bool(forKey: "smartDegRad") {
        didSet {
            UserDefaults.standard.set(self.smartDegRad, forKey: "smartDegRad")
        }
    }
    @Published var lightBut: Bool = UserDefaults.standard.bool(forKey: "lightBut") {
        didSet {
            UserDefaults.standard.set(self.lightBut, forKey: "lightBut")
        }
    }
    
    // Calculations
    @Published var recentCalcCount: Int = UserDefaults.standard.integer(forKey: "recentCalcCount") {
        didSet {
            UserDefaults.standard.set(self.recentCalcCount, forKey: "recentCalcCount")
        }
    }
    
    // Display
    @Published var animateText: Bool = UserDefaults.standard.bool(forKey: "animateText") {
        didSet {
            UserDefaults.standard.set(self.animateText, forKey: "animateText")
        }
    }
    @Published var light: Bool = UserDefaults.standard.bool(forKey: "light") {
        didSet {
            UserDefaults.standard.set(self.light, forKey: "light")
        }
    }
    
    // Text
    @Published var displayX10: Bool = UserDefaults.standard.bool(forKey: "displayX10") {
        didSet {
            UserDefaults.standard.set(self.displayX10, forKey: "displayX10")
            refresh()
        }
    }
    @Published var autoParFunction: Bool = UserDefaults.standard.bool(forKey: "autoParFunction") {
        didSet {
            UserDefaults.standard.set(self.autoParFunction, forKey: "autoParFunction")
            refresh()
        }
    }
    @Published var commaSeparators: Bool = UserDefaults.standard.bool(forKey: "commaSeparators") {
        didSet {
            UserDefaults.standard.set(self.commaSeparators, forKey: "commaSeparators")
            if commaSeparators == true && spaceSeparators == true {
                spaceSeparators = false
            }
            refresh()
        }
    }
    @Published var spaceSeparators: Bool = UserDefaults.standard.bool(forKey: "spaceSeparators") {
        didSet {
            UserDefaults.standard.set(self.spaceSeparators, forKey: "spaceSeparators")
            if spaceSeparators == true && commaSeparators == true {
                commaSeparators = false
            }
            refresh()
        }
    }
    @Published var commaDecimal: Bool = UserDefaults.standard.bool(forKey: "commaDecimal") {
        didSet {
            UserDefaults.standard.set(self.commaDecimal, forKey: "commaDecimal")
            refresh()
        }
    }
    @Published var degreeSymbol: Bool = UserDefaults.standard.bool(forKey: "degreeSymbol") {
        didSet {
            UserDefaults.standard.set(self.degreeSymbol, forKey: "degreeSymbol")
            refresh()
        }
    }
    
}

func defaultSettings() {
    
    let userDefaults = UserDefaults.standard
    let settings = Settings.settings
    
    if userDefaults.object(forKey: "layoutExpanded") == nil {
        if UIDevice.current.userInterfaceIdiom == .pad {
            settings.layoutExpanded = true
        }
        else {
            settings.layoutExpanded = false
        }
    }
    if userDefaults.object(forKey: "roundPlaces") == nil {
        settings.roundPlaces = 8
    }
    if userDefaults.object(forKey: "displayAltResults") == nil {
        settings.displayAltResults = true
    }
    if userDefaults.object(forKey: "displayAllAltResults") == nil {
        settings.displayAllAltResults = false
    }
    if userDefaults.object(forKey: "smartDegRad") == nil {
        settings.smartDegRad = true
    }
    if userDefaults.object(forKey: "lightBut") == nil {
        settings.lightBut = false
    }
    if userDefaults.object(forKey: "recentCalcCount") == nil {
        settings.recentCalcCount = 20
    }
    if userDefaults.object(forKey: "animateText") == nil {
        settings.animateText = true
    }
    if userDefaults.object(forKey: "light") == nil {
        settings.light = false
    }
    if userDefaults.object(forKey: "displayX10") == nil {
        settings.displayX10 = false
    }
    if userDefaults.object(forKey: "autoParFunction") == nil {
        settings.autoParFunction = false
    }
    if userDefaults.object(forKey: "commaSeparators") == nil {
        settings.commaSeparators = true
    }
    if userDefaults.object(forKey: "spaceSeparators") == nil {
        settings.spaceSeparators = false
    }
    if userDefaults.object(forKey: "commaDecimal") == nil {
        settings.commaDecimal = false
    }
    if userDefaults.object(forKey: "degreeSymbol") == nil {
        settings.degreeSymbol = true
    }
}
