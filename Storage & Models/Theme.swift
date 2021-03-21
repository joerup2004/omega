//
//  Theme.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/7/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class Theme: ObservableObject, Codable {
    
    var id: Int
    var name: String
    
    var category: String
    var categoryID: Int
    
    var color1: [CGFloat]
    var color2: [CGFloat]
    var color3: [CGFloat]
    var color4: [CGFloat]
    
    var gray: Double
    
    init(id: Int, name: String, category: String, color1: [CGFloat], color2: [CGFloat], color3: [CGFloat], color4: [CGFloat], gray: Double) {
        self.id = id
        self.name = name
        self.category = category
        self.categoryID = id%4
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
        self.color4 = color4
        self.gray = gray
    }
}

func color(_ rgb: [CGFloat]) -> Color {
    
    if rgb.count != 3 {
        return Color.black
    }
    
    let red = Double(rgb[0])
    let green = Double(rgb[1])
    let blue = Double(rgb[2])
    
    let color = Color.init(red: red/255, green: green/255, blue: blue/255)
    
    return color
}

func getSavedTheme() -> Theme? {
 
    if let savedTheme = UserDefaults.standard.object(forKey: "theme") as? Data {
        
        let decoder = JSONDecoder()
        
        if let theme = try? decoder.decode(Theme.self, from: savedTheme) {
            return theme
        }
    }
    return nil
}

//func randomTheme() {
//
//    let settings = Settings.settings
//    let uiData = UIData.uiData
//
//    var randomCategory = Int.random(in: 0...7)
//    var randomTheme = Int.random(in: 0...3)
//
//    while (randomCategory == 0 && randomTheme == 3) || settings.theme.id == uiData.themes[randomCategory].themes[randomTheme].id {
//        randomCategory = Int.random(in: 0...7)
//        randomTheme = Int.random(in: 0...3)
//    }
//
//    uiData.themes[0].themes[3].color1 = uiData.themes[randomCategory].themes[randomTheme].color1
//    uiData.themes[0].themes[3].color2 = uiData.themes[randomCategory].themes[randomTheme].color2
//    uiData.themes[0].themes[3].color3 = uiData.themes[randomCategory].themes[randomTheme].color3
//    uiData.themes[0].themes[3].color4 = uiData.themes[randomCategory].themes[randomTheme].color4
//    uiData.themes[0].themes[3].gray = uiData.themes[randomCategory].themes[randomTheme].gray
//
//    if !uiData.themes[randomCategory].themes[randomTheme].name.contains("Random") {
//        uiData.themes[0].themes[3].name = uiData.themes[randomCategory].themes[randomTheme].name + " (Random)"
//    }
//
//    if settings.theme.name.contains("Random") {
//        settings.theme = uiData.themes[0].themes[3]
//        randomThemeIcon(settings.theme)
//    }
//}
//
//
//func randomThemeIcon(_ theme: Theme) {
//
//    if UIApplication.shared.supportsAlternateIcons {
//        var name = theme.name
//        for _ in 0...8 {
//            name.removeLast()
//        }
//        print(name)
//        UIApplication.shared.setAlternateIconName(name) { error in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                print("App Icon changed to \(name)!")
//            }
//        }
//    }
//}
