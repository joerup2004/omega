//
//  InfoCategory.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import Foundation

class InfoCategory {
    
    var id: Int
    var name: String
    var desc: String
    
    var info: [InfoData]
    
    var displayedInfo: [Int]
    
    init(id: Int, name: String, desc: String, info: [InfoData], displayedInfo: [Int]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.info = info
        self.displayedInfo = displayedInfo
    }
}
