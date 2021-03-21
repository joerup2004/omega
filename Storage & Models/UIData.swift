//
//  UIData.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/7/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation

class UIData {
    
    static let uiData = UIData()
    
    
    // MARK: Button Layout
    let numCol1 = ["7","4","1","0"]
    let numCol2 = ["8","5","2","."]
    let numCol3 = ["9","6","3","+/-"]
    let opCol = ["÷","×","-","+"]
    
    let sections = ["1st","2nd","3rd","4th","5th"/*,"6th","7th"*/]
    
    let specialColumns = [
        [
            ["(","^2","√","sin"],
            [")","^3","³√","cos"],
            ["/","^","ˣ√","tan"],
            ["%","^-1","10^","log"],
            ["EXP","π","e","ln"]
        ],
        [
            ["(","10^","log","sin⁻¹"],
            [")","e^","ln","cos⁻¹"],
            ["/","2^","log₂","tan⁻¹"],
            ["%","x^","logₓ","| |"],
            ["EXP","π","e","rand"]
        ],
        [
            ["(","^2","√","round"],
            [")","^3","³√","floor"],
            ["/","^","ˣ√","ceil"],
            ["%","nPr","nCr","| |"],
            ["EXP","!","mod","rand"]
        ],
        [
            ["(","sin","cos","tan"],
            [")","sin⁻¹","cos⁻¹","tan⁻¹"],
            ["/","csc","sec","cot"],
            ["%","csc⁻¹","sec⁻¹","cot⁻¹"],
            ["EXP","^2","^","√"]
        ],
        [
            ["(","sinh","cosh","tanh"],
            [")","sinh⁻¹","cosh⁻¹","tanh⁻¹"],
            ["/","csch","sech","coth"],
            ["%","csch⁻¹","sech⁻¹","coth⁻¹"],
            ["EXP","π","e","rand"]
        ],
//        [
//            ["(","x","^2","√"],
//            [")","y","^","ˣ√"],
//            ["/","z","sin","log"],
//            ["| |","u","cos","ln"],
//            ["EXP","v","tan","π"]
//        ],
//        [
//            ["a","g","m","s"],
//            ["b","h","n","t"],
//            ["c","j","p","u"],
//            ["d","k","q","v"],
//            ["f","l","r","w"]
//        ],
//        [
//            ["α","ϝ","λ","σ"],
//            ["β","ζ","μ","τ"],
//            ["γ","η","ν","φ"],
//            ["δ","θ","ξ","ψ"],
//            ["ε","ι","ρ","ω"]
//        ]
    ]
    
    let scrollRow = ["(",")","^2","√","/","EXP","%","π","e","^","ˣ√","sin","cos","tan","log","ln"]
    
    let portraitRow1 = ["(",")","^2","√","/"]
    let portraitRow2 = ["sin","EXP","^","ˣ√","%"]
    let portraitCol = ["cos","tan","log","ln"]
    
    let altPortraitRow = ["(",")","π","e","%","/"]
    let altPortraitCol1 = ["^2","^","sin","cos","tan"]
    let altPortraitCol2 = ["√","ˣ√","EXP","log","ln"]
    
    
    // MARK: Themes
    let themes = [
        
        ThemeCategory(id: 0, name: "Basic", themes: [
            
                Theme(id: 0,
                      name: "Classic Blue",
                      category: "Basic",
                      color1: [040,130,240], // Light Blue
                      color2: [230,120,020], // Orange
                      color3: [030,080,180], // Dark Blue
                      color4: [026,070,170], // Darker Blue
                      gray: 0.7
                ),
            
                Theme(id: 1,
                      name: "Classic Pink",
                      category: "Basic",
                      color1: [245,135,208], // Light Pink
                      color2: [255,144,070], // Orange
                      color3: [229,037,210], // Hot Pink
                      color4: [220,035,203], // Hotter Pink
                      gray: 0.7
                ),
                
                Theme(id: 2,
                      name: "Light",
                      category: "Basic",
                      color1: [200,200,200], // White
                      color2: [100,100,100], // Dark Gray
                      color3: [150,150,150], // Gray
                      color4: [145,145,145], // Darker Gray
                      gray: 0.4
                ),
                
                Theme(id: 3,
                      name: "Dark",
                      category: "Basic",
                      color1: [020,020,020], // Black
                      color2: [035,035,035], // Gray
                      color3: [027,027,027], // Dark Gray
                      color4: [025,025,025], // Darker Gray
                      gray: 0.7
                ),
            ]
        ),
        
        ThemeCategory(id: 1, name: "The Land", themes: [
            
                Theme(id: 4,
                      name: "Grassy",
                      category: "Nature",
                      color1: [065,233,087], // Lime Green
                      color2: [240,210,087], // Yellow
                      color3: [034,132,047], // Dark Green
                      color4: [030,127,042], // Darker Green
                      gray: 0.7
                ),
                
                Theme(id: 5,
                      name: "Mountain",
                      category: "The Land",
                      color1: [201,169,218], // Light Purple
                      color2: [101,141,159], // Dark Teal
                      color3: [095,058,115], // Dark Purple
                      color4: [090,054,109], // Darker Purple
                      gray: 0.7
                ),
                
                Theme(id: 6,
                      name: "Desert",
                      category: "The Land",
                      color1: [210,176,147], // Tan
                      color2: [135,155,142], // Dull Green
                      color3: [196,124,083], // Brown Orange
                      color4: [190,118,076], // Dark Brown Orange
                      gray: 0.85
                ),
                
                Theme(id: 7,
                      name: "Floral",
                      category: "The Land",
                      color1: [184,043,216], // Purple
                      color2: [218,236,056], // Yellow Green
                      color3: [132,032,213], // Dark Purple
                      color4: [126,029,205], // Darker Purple
                      gray: 0.7
                ),
            ]
        ),
        
        ThemeCategory(id: 2, name: "The Sea", themes: [
                
                Theme(id: 8,
                      name: "Aquatic",
                      category: "The Sea",
                      color1: [115,215,235], // Light Blue
                      color2: [242,065,011], // Scarlet
                      color3: [025,143,166], // Teal
                      color4: [020,136,160], // Darker Teal
                      gray: 0.7
                ),
                
                Theme(id: 9,
                      name: "Scuba",
                      category: "The Sea",
                      color1: [000,030,150], // Blue
                      color2: [000,090,030], // Dark Green
                      color3: [000,025,100], // Dark Blue
                      color4: [000,020,095], // Darker Blue
                      gray: 0.7
                ),
                
                Theme(id: 10,
                      name: "Sailboat",
                      category: "The Sea",
                      color1: [224,055,055], // Red
                      color2: [209,171,145], // Beige
                      color3: [002,191,212], // Light Blue
                      color4: [001,186,206], // Light Blue
                      gray: 0.9
                ),
                
                Theme(id: 11,
                      name: "Coral",
                      category: "The Sea",
                      color1: [053,138,159], // Blue-Gray
                      color2: [144,083,205], // Purple
                      color3: [053,074,159], // Indigo
                      color4: [050,070,154], // Dark Indigo
                      gray: 0.7
                ),
            ]
        ),
        
        ThemeCategory(id: 3, name: "The Sky", themes: [
        
                Theme(id: 12,
                      name: "Galaxy",
                      category: "The Sky",
                      color1: [150,010,200], // Purple
                      color2: [231,020,243], // Magenta
                      color3: [000,002,154], // Blue
                      color4: [000,002,150], // Dark Blue
                      gray: 0.7
                ),
                
                Theme(id: 13,
                      name: "Sunset",
                      category: "The Sky",
                      color1: [252,031,090], // Pinkish Red
                      color2: [236,075,236], // Magenta
                      color3: [252,141,031], // Orangey Yellow
                      color4: [245,137,030], // Orangier Yellow
                      gray: 0.85
                ),
                
                Theme(id: 14,
                      name: "Moonlight",
                      category: "The Sky",
                      color1: [212,212,212], // White
                      color2: [000,007,060], // Dark Blue
                      color3: [000,004,035], // Darker Blue
                      color4: [000,003,030], // Darkest Blue
                      gray: 0.7
                ),
                
                Theme(id: 15,
                      name: "Alien",
                      category: "The Sky",
                      color1: [089,239,169], // Light Green
                      color2: [074,183,205], // Light Blue
                      color3: [184,136,202], // Light Purple
                      color4: [178,130,195], // Light Purple
                      gray: 0.8
                ),
            ]
        ),
        
        ThemeCategory(id: 4, name: "Festive", themes: [

                Theme(id: 16,
                      name: "Hearts",
                      category: "Festive",
                      color1: [214,020,191], // Pink
                      color2: [148,023,169], // Purple
                      color3: [201,014,092], // Red
                      color4: [198,013,089], // Dark Red
                      gray: 0.7
                ),
                
                Theme(id: 17,
                      name: "Patriotic",
                      category: "Festive",
                      color1: [210,210,210], // White
                      color2: [200,000,000], // Red
                      color3: [000,000,186], // Blue
                      color4: [000,000,180], // Darker Blue
                      gray: 0.7
                ),
                
                Theme(id: 18,
                      name: "Pumpkin",
                      category: "Festive",
                      color1: [249,133,044], // Orange
                      color2: [145,057,025], // Chestnut
                      color3: [225,060,000], // Scarlet
                      color4: [219,055,000], // Dark Scarlet
                      gray: 0.75
                ),
                
                Theme(id: 19,
                      name: "Holiday",
                      category: "Festive",
                      color1: [157,000,000], // Red
                      color2: [210,210,210], // White
                      color3: [005,142,005], // Dark Green
                      color4: [004,138,004], // Darker Green
                      gray: 0.75
                ),
            ]
        ),
        
        ThemeCategory(id: 5, name: "Animals", themes: [
        
                Theme(id: 20,
                      name: "Caterpillar",
                      category: "Animals",
                      color1: [000,207,242], // Aqua
                      color2: [157,212,040], // Yellow Green
                      color3: [020,135,170], // Dark Aqua
                      color4: [016,130,165], // Darker Aqua
                      gray: 0.75
                ),
                
                Theme(id: 21,
                      name: "Turtle",
                      category: "Animals",
                      color1: [142,179,152], // Dull Green
                      color2: [210,239,218], // Very Light Green
                      color3: [004,081,032], // Dark Green
                      color4: [003,075,027], // Darker Green
                      gray: 0.7
                ),
                
                Theme(id: 22,
                      name: "Robin",
                      category: "Animals",
                      color1: [060,208,225], // Light Blue
                      color2: [234,061,002], // Scarlet
                      color3: [004,135,087], // Teal
                      color4: [004,130,084], // Darker Teal
                      gray: 0.75
                ),
                
                Theme(id: 23,
                      name: "Unicorn",
                      category: "Animals",
                      color1: [253,091,145], // Pink
                      color2: [054,010,118], // Indigo
                      color3: [195,188,205], // White
                      color4: [190,183,199], // Light Gray
                      gray: 0.9
                ),
            ]
        ),
        
        ThemeCategory(id: 6, name: "Food", themes: [
            
                Theme(id: 24,
                      name: "Watermelon",
                      category: "Food",
                      color1: [228,051,090], // Red Violet
                      color2: [104,223,024], // Lime Green
                      color3: [023,170,006], // Dark Green
                      color4: [020,161,005], // Darker Green
                      gray: 0.85
                ),
                
                Theme(id: 25,
                      name: "Cookie",
                      category: "Food",
                      color1: [201,149,047], // Dough
                      color2: [125,090,014], // Brown
                      color3: [043,031,016], // Chocolate
                      color4: [039,027,014], // Dark Chocolate
                      gray: 0.7
                ),
                
                Theme(id: 26,
                      name: "Pineapple",
                      category: "Food",
                      color1: [200,168,000], // Yellow
                      color2: [115,056,002], // Brown
                      color3: [010,141,016], // Green
                      color4: [009,138,015], // Dark Green
                      gray: 0.75
                ),
                
                Theme(id: 27,
                      name: "Jelly",
                      category: "Food",
                      color1: [210,043,144], // Rose
                      color2: [112,016,106], // Fuschia
                      color3: [038,016,112], // Dark Blue
                      color4: [036,015,108], // Darker Blue
                      gray: 0.7
                ),
            ]
        ),
        
        ThemeCategory(id: 7, name: "Colorful", themes: [
        
                Theme(id: 28,
                      name: "Warm",
                      category: "Colorful",
                      color1: [244,061,063], // Pinkish Red
                      color2: [232,094,024], // Orange
                      color3: [156,014,010], // Dark Red
                      color4: [150,013,009], // Darker Red
                      gray: 0.7
                ),
                
                Theme(id: 29,
                      name: "Cool",
                      category: "Water",
                      color1: [180,230,240], // Light Blue
                      color2: [200,020,200], // Magenta
                      color3: [000,180,200], // Light Blue
                      color4: [000,175,190], // Light Blue
                      gray: 0.85
                ),
                
                Theme(id: 30,
                      name: "Pastel",
                      category: "Colorful",
                      color1: [200,225,176], // Light Green
                      color2: [176,176,225], // Light Blue
                      color3: [225,200,176], // Light Orange
                      color4: [219,195,171], // Light Orange
                      gray: 0.9
                ),
                
                Theme(id: 31,
                      name: "Vibrant",
                      category: "Colorful",
                      color1: [075,215,235], // Light Blue
                      color2: [255,038,004], // Red
                      color3: [213,004,254], // Purple
                      color4: [208,004,248], // Darker Purple
                      gray: 0.7
                ),
            ]
        ),
    ]
}
