//
//  ThemeCategory.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation

class ThemeCategory {
    
    var id: Int
    var name: String
    
    var themes: [Theme]
    
    init(id: Int, name: String, themes: [Theme]) {
        self.id = id
        self.name = name
        self.themes = themes
    }
}
