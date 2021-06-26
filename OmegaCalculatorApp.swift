//
//  OmegaCalculatorApp.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

@main
struct OmegaCalculatorApp: App {
    
    @StateObject var storeManager = StoreManager()
    
    let productIDs = [
            "com.rupertusapps.OmegaCalc.ThemeAnimals",
            "com.rupertusapps.OmegaCalc.ThemeFestive",
            "com.rupertusapps.OmegaCalc.ThemeFood",
            "com.rupertusapps.OmegaCalc.ThemeLand",
            "com.rupertusapps.OmegaCalc.ThemeSea",
            "com.rupertusapps.OmegaCalc.ThemeSky",
        ]
    
    var body: some Scene {
        WindowGroup {
            CalculatorView(storeManager: storeManager)
                .onAppear {
                    // Set the default settings if not set
                    defaultSettings()
                    // Set the theme to dark
                    ThemeManager.shared.handleTheme(darkMode: true, system: false)
                    // Add store manager
                    SKPaymentQueue.default().add(storeManager)
                    // Get store products from App Store Connect
                    self.storeManager.getProducts(productIDs: self.productIDs)
                }
        }
    }
}

class ThemeManager {
    static let shared = ThemeManager()

    private init () {}

    func handleTheme(darkMode: Bool, system: Bool) {
    
        guard !system else {
            UIApplication.shared.windows.first?.overrideUserInterfaceStyle = .unspecified
            return
        }
        UIApplication.shared.windows.first?.overrideUserInterfaceStyle = darkMode ? .dark : .light
    }

}
