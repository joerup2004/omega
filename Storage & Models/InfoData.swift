//
//  InfoData.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import Foundation

class InfoData {
    
    var formatting = Formatting.formatting
    
    var id: Int
    var name: String
    var fullName: String
    var buttonType: Int
    
    var category: String
    
    var description: String
    
    var example1Q: TextViews
    var example1A: TextViews
    var example2Q: TextViews
    var example2A: TextViews
    
    
    init(id:Int,name:String,fullName:String,category:String,description:String,example1Q:[String],example1A:[String],example2Q:[String],example2A:[String]) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.buttonType = id%3 + 1
        self.category = category
        self.description = description
        self.example1Q = TextViews(array: example1Q+["="], formattingGuide: formatting.createFormattingGuide(array: example1Q+["="]), size: 16, position: "top")
        self.example1A = TextViews(array: example1A, formattingGuide: formatting.createFormattingGuide(array: example1A), size: 16, position: "main")
        self.example2Q = TextViews(array: example2Q+["="], formattingGuide: formatting.createFormattingGuide(array: example2Q+["="]), size: 16, position: "top")
        self.example2A = TextViews(array: example2A, formattingGuide: formatting.createFormattingGuide(array: example2A), size: 16, position: "main")
    }
}
