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
    
    @Published var calculatorType: String = UserDefaults.standard.string(forKey: "calculatorType") ?? "regular" {
        didSet {
            UserDefaults.standard.set(self.calculatorType, forKey: "calculatorType")
        }
    }
    
    @Published var showMenu = false
    @Published var showCalculations = false
    
    @Published var buttonSection: Int = 0
    
    @Published var radians: Bool = UserDefaults.standard.bool(forKey: "radians") {
        didSet {
            UserDefaults.standard.set(self.radians, forKey: "radians")
            refresh()
        }
    }
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
    
    // MARK: - Interface
    @Published var textWeight: Int = UserDefaults.standard.integer(forKey: "textWeight") {
        didSet {
            UserDefaults.standard.set(self.textWeight, forKey: "textWeight")
        }
    }
    @Published var buttonWeight: Int = UserDefaults.standard.integer(forKey: "buttonWeight") {
        didSet {
            UserDefaults.standard.set(self.buttonWeight, forKey: "buttonWeight")
        }
    }
    @Published var layoutExpanded: Bool = UserDefaults.standard.bool(forKey: "layoutExpanded") {
        didSet {
            UserDefaults.standard.set(self.layoutExpanded, forKey: "layoutExpanded")
        }
    }
    @Published var shrinkLimit: Int = UserDefaults.standard.integer(forKey: "shrinkLimit") {
        didSet {
            UserDefaults.standard.set(self.shrinkLimit, forKey: "shrinkLimit")
        }
    }
    @Published var smartDegRad: Bool = UserDefaults.standard.bool(forKey: "smartDegRad") {
        didSet {
            UserDefaults.standard.set(self.smartDegRad, forKey: "smartDegRad")
        }
    }
    
    // MARK: - Text
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
    
    // MARK: - Results
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
    
    // MARK: - Calculations
    @Published var recentCalcCount: Int = UserDefaults.standard.integer(forKey: "recentCalcCount") {
        didSet {
            UserDefaults.standard.set(self.recentCalcCount, forKey: "recentCalcCount")
        }
    }
    
}

func defaultSettings() {
    
    let userDefaults = UserDefaults.standard
    let settings = Settings.settings
    
    if userDefaults.object(forKey: "calculatorType") == nil {
        settings.calculatorType = "regular"
    }
    
    // Interface
    if userDefaults.object(forKey: "textWeight") == nil {
        if userDefaults.object(forKey: "light") != nil {
            settings.textWeight = userDefaults.bool(forKey: "light") ? 0 : 2
        }
        else {
            settings.textWeight = 1
        }
    }
    if userDefaults.object(forKey: "buttonWeight") == nil {
        if userDefaults.object(forKey: "lightBut") != nil {
            settings.buttonWeight = userDefaults.bool(forKey: "lightBut") ? 0 : 2
        }
        else {
            settings.buttonWeight = 1
        }
    }
    if userDefaults.object(forKey: "layoutExpanded") == nil {
        if UIDevice.current.userInterfaceIdiom == .pad {
            settings.layoutExpanded = true
        }
        else {
            settings.layoutExpanded = false
        }
    }
    if userDefaults.object(forKey: "shrinkLimit") == nil {
        settings.shrinkLimit = 2
    }
    if userDefaults.object(forKey: "smartDegRad") == nil {
        settings.smartDegRad = false
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
        settings.degreeSymbol = false
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
    if userDefaults.object(forKey: "recentCalcCount") == nil {
        settings.recentCalcCount = 20
    }
    
    // Give pre-1.5 users 3 free theme sets
    // We're removing the text animations setting, so this is being used to figure out who had the app pre-1.5
    // If they have this value stored in UserDefaults, it means they had the app before the update
    // NOTE: Remove this in a few months or so!!! 6/22/21
    if userDefaults.object(forKey: "animateText") != nil {
        UserDefaults.standard.removeObject(forKey: "animateText")
        UserDefaults.standard.setValue(true, forKey: "com.rupertusapps.OmegaCalc.ThemeLand")
        UserDefaults.standard.setValue(true, forKey: "com.rupertusapps.OmegaCalc.ThemeSea")
        UserDefaults.standard.setValue(true, forKey: "com.rupertusapps.OmegaCalc.ThemeSky")
    }
}
