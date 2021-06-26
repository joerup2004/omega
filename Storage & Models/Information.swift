//
//  Information.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import Foundation
import Combine
import UIKit

class Information: ObservableObject {
    
    static let information = Information()
    
    var settings = Settings.settings
    
    @Published var info = [
        
        InfoCategory(
            id: 0,
            name: "Operations",
            desc: "These basic operations are the essential parts of a calculator.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "+",
                    fullName: "Addition",
                    category: "Operations",
                    description: "",
                    example1Q: ["2","+","3"],
                    example1A: ["5"],
                    example2Q: ["13.1","+","6.12","+","3.2"],
                    example2A: ["22.42"]
                ),
                
                InfoData(
                    id: 1,
                    name: "-",
                    fullName: "Subtraction",
                    category: "Operations",
                    description: "",
                    example1Q: ["14","-","3"],
                    example1A: ["11"],
                    example2Q: ["6.23","-","26.95","-","3.1"],
                    example2A: ["-23.82"]
                ),
                
                InfoData(
                    id: 2,
                    name: "×",
                    fullName: "Multiplication",
                    category: "Operations",
                    description: "",
                    example1Q: ["4","×","-12"],
                    example1A: ["-48"],
                    example2Q: ["9.1","×","7.23","×","-4"],
                    example2A: ["-263.172"]
                ),
                
                InfoData(
                    id: 3,
                    name: "÷",
                    fullName: "Division",
                    category: "Operations",
                    description: "",
                    example1Q: ["364","÷","14"],
                    example1A: ["26"],
                    example2Q: ["618.075","÷","-67","÷","7.5"],
                    example2A: ["-1.23"]
                ),
                
                InfoData(
                    id: 4,
                    name: "%",
                    fullName: "Percent",
                    category: "Operations",
                    description: "",
                    example1Q: ["24%"],
                    example1A: ["0.24"],
                    example2Q: ["37%","×","364"],
                    example2A: ["133.2"]
                ),
                
                InfoData(
                    id: 5,
                    name: "/",
                    fullName: "Fraction",
                    category: "Operations",
                    description: "",
                    example1Q: ["“","4","/","7","‘"],
                    example1A: ["0.57142857"],
                    example2Q: ["“","1","/","2","‘","+","“","3","/","4","‘"],
                    example2A: ["1.25"]
                ),
                
                InfoData(
                    id: 6,
                    name: "| |",
                    fullName: "Absolute Value",
                    category: "Operations",
                    description: "The distance a number is from zero",
                    example1Q: ["|\\","-4","\\|"],
                    example1A: ["4"],
                    example2Q: ["|\\","3","×","6","-","26","\\|"],
                    example2A: ["8"]
                ),
                
                InfoData(
                    id: 7,
                    name: "mod",
                    fullName: "Modulo",
                    category: "Operations",
                    description: "The remainder of the division of two numbers",
                    example1Q: ["8","mod","3"],
                    example1A: ["2"],
                    example2Q: ["634","mod","41"],
                    example2A: ["19"]
                ),
                
            ],
            displayedInfo: [0,1,2,3]
        ),
        
        InfoCategory(
            id: 1,
            name: "Exponents & Roots",
            desc: "Exponents and roots are quintessential parts of math, giving you much more power.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "^2",
                    fullName: "Square",
                    category: "Exponents & Roots",
                    description: "Raises the number to the 2nd power",
                    example1Q: ["17","^","2","v"],
                    example1A: ["289"],
                    example2Q: ["(","-4.78",")","^","2","v"],
                    example2A: ["22.8484"]
                ),
                
                InfoData(
                    id: 1,
                    name: "^3",
                    fullName: "Cube",
                    category: "Exponents & Roots",
                    description: "Raises the number to the 3rd power",
                    example1Q: ["6","^","3"],
                    example1A: ["216"],
                    example2Q: ["(","-1.54","-","2.1",")","^","3","v"],
                    example2A: ["-48.228544"]
                ),
                
                InfoData(
                    id: 2,
                    name: "^",
                    fullName: "Exponent",
                    category: "Exponents & Roots",
                    description: "Raises the number to any power",
                    example1Q: ["4","^","10"],
                    example1A: ["1048576"],
                    example2Q: ["(","2","+","3",")","^","2","+","3","v"],
                    example2A: ["3125"]
                ),
                
                InfoData(
                    id: 3,
                    name: "EXP",
                    fullName: "Exponential Notation",
                    category: "Exponents & Roots",
                    description: "Multiplies the number by the given power of 10",
                    example1Q: ["2.4","E","3"],
                    example1A: ["2400"],
                    example2Q: ["6.45×10","^","-4","v"],
                    example2A: ["0.000645"]
                ),
                
                InfoData(
                    id: 4,
                    name: "^-1",
                    fullName: "Inverse",
                    category: "Exponents & Roots",
                    description: "Raises the number to the -1 power, or 1/number",
                    example1Q: ["4","^","-1","v"],
                    example1A: ["0.25"],
                    example2Q: ["8.100000074","^","-1","v"],
                    example2A: ["0.123456789"]
                ),
                
                InfoData(
                    id: 5,
                    name: "√",
                    fullName: "Square Root",
                    category: "Exponents & Roots",
                    description: "Finds the square root of the number",
                    example1Q: ["§","#2","√","1156","`"],
                    example1A: ["34"],
                    example2Q: ["§","#2","√","3.2","×","20","`"],
                    example2A: ["8"]
                ),
                
                InfoData(
                    id: 6,
                    name: "³√",
                    fullName: "Cube Root",
                    category: "Exponents & Roots",
                    description: "Finds the cube root of the number",
                    example1Q: ["§","3","√","343","`"],
                    example1A: ["7"],
                    example2Q: ["§","3","√","-2120","-","624","`"],
                    example2A: ["-14"]
                ),
                
                InfoData(
                    id: 7,
                    name: "ˣ√",
                    fullName: "n Root",
                    category: "Exponents & Roots",
                    description: "Finds any root of the number",
                    example1Q: ["§","10","√","1024","`"],
                    example1A: ["2"],
                    example2Q: ["§","4","√","3.40","-","8.2","`"],
                    example2A: ["Error"]
                ),
                
            ],
            displayedInfo: [0,5,2,3]
        ),
        
        InfoCategory(
            id: 2,
            name: "Logarithms",
            desc: "Logarithms are used to calculate what power of a base a certain number is equal to. This section also includes exponent bases.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "log",
                    fullName: "Base 10 Logarithm",
                    category: "Logarithms",
                    description: "Finds the power of 10 equal to the number",
                    example1Q: ["log","#10","¶","10000"],
                    example1A: ["4"],
                    example2Q: ["log","#10","¶","31.622777"],
                    example2A: ["1.5"]
                ),
                
                InfoData(
                    id: 1,
                    name: "ln",
                    fullName: "Natural Logarithm",
                    category: "Logarithms",
                    description: "Finds the power of e equal to the number",
                    example1Q: ["ln","¶","162754.79"],
                    example1A: ["12"],
                    example2Q: ["ln","¶","100"],
                    example2A: ["4.6051702"]
                ),
                
                InfoData(
                    id: 2,
                    name: "log₂",
                    fullName: "Base 2 Logarithm",
                    category: "Logarithms",
                    description: "Finds the power of 2 equal to the number",
                    example1Q: ["log","2","¶","65536"],
                    example1A: ["16"],
                    example2Q: ["log","2","¶","34"],
                    example2A: ["5.0874628"]
                ),
                
                InfoData(
                    id: 3,
                    name: "logₓ",
                    fullName: "Base n Logarithm",
                    category: "Logarithms",
                    description: "Finds the power of any base equal to the number",
                    example1Q: ["log","4","¶","16777216"],
                    example1A: ["12"],
                    example2Q: ["log","13","¶","169"],
                    example2A: ["2"]
                ),
                
                InfoData(
                    id: 4,
                    name: "10^",
                    fullName: "Base 10 Power",
                    category: "Logarithms",
                    description: "Raises 10 to the power of the number given",
                    example1Q: ["10","^","9","v"],
                    example1A: ["1000000000"],
                    example2Q: ["10","^","-2","v"],
                    example2A: ["0.01"]
                ),
                
                InfoData(
                    id: 5,
                    name: "e^",
                    fullName: "Base e Power",
                    category: "Logarithms",
                    description: "Raises e to the power of the number given",
                    example1Q: ["e","^","2.54","v"],
                    example1A: ["12.679671"],
                    example2Q: ["e","^","-6.4","v"],
                    example2A: ["0.00166156"]
                ),
                
                InfoData(
                    id: 6,
                    name: "2^",
                    fullName: "Base 2 Power",
                    category: "Logarithms",
                    description: "Raises 2 to the power of the number given",
                    example1Q: ["2","^","13","v"],
                    example1A: ["8192"],
                    example2Q: ["2","^","§","#2","√","2","v"],
                    example2A: ["2.6651441"]
                ),
                
                InfoData(
                    id: 7,
                    name: "x^",
                    fullName: "Base n Power",
                    category: "Logarithms",
                    description: "Raises any number to the power of the number given",
                    example1Q: ["4","^","19","v"],
                    example1A: ["2.7487791×10","^","11","v"],
                    example2Q: ["(","8","-","2",")","^","4","^","2","v","v"],
                    example2A: ["2.8211099","E","12"]
                ),
                
            ],
            displayedInfo: [0,5,2,1]
        ),
        
        InfoCategory(
            id: 3,
            name: "Trigonometry",
            desc: "Trigonometry deals with the relationships between angles in a triangle. There are many variations of trig functions listed.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "sin",
                    fullName: "Sine",
                    category: "Trigonometry",
                    description: "The opposite/hypotenuse of an angle; y/r",
                    example1Q: ["sin","90","º"],
                    example1A: ["1"],
                    example2Q: ["sin","“","2π","/","3","‘"],
                    example2A: ["0.8660254"]
                ),
                
                InfoData(
                    id: 1,
                    name: "cos",
                    fullName: "Cosine",
                    category: "Trigonometry",
                    description: "The adjacent/hypotenuse of an angle; x/r",
                    example1Q: ["cos","90","º"],
                    example1A: ["0"],
                    example2Q: ["cos","“","2π","/","3","‘"],
                    example2A: ["-0.5"]
                ),
                
                InfoData(
                    id: 2,
                    name: "tan",
                    fullName: "Tangent",
                    category: "Trigonometry",
                    description: "The opposite/adjacent of an angle; y/x",
                    example1Q: ["tan","90","º"],
                    example1A: ["∞"],
                    example2Q: ["tan","“","2π","/","3","‘"],
                    example2A: ["-1.7320508"]
                ),
                
                InfoData(
                    id: 3,
                    name: "cot",
                    fullName: "Cotangent",
                    category: "Trigonometry",
                    description: "The adjacent/opposite of an angle; x/y",
                    example1Q: ["cot","90","º"],
                    example1A: ["0"],
                    example2Q: ["cot","“","2π","/","3","‘"],
                    example2A: ["-0.57735027"]
                ),
                
                InfoData(
                    id: 4,
                    name: "sec",
                    fullName: "Secant",
                    category: "Trigonometry",
                    description: "The hypotenuse/adjacent of an angle; r/x",
                    example1Q: ["sec","90","º"],
                    example1A: ["∞"],
                    example2Q: ["sec","“","2π","/","3","‘"],
                    example2A: ["-2"]
                ),
                
                InfoData(
                    id: 5,
                    name: "csc",
                    fullName: "Cosecant",
                    category: "Trigonometry",
                    description: "The hypotenuse/opposite of an angle; r/y",
                    example1Q: ["csc","90","º"],
                    example1A: ["1"],
                    example2Q: ["csc","“","2π","/","3","‘"],
                    example2A: ["1.1547005"]
                ),
                
                InfoData(
                    id: 6,
                    name: "sin⁻¹",
                    fullName: "Inverse Sine",
                    category: "Trigonometry",
                    description: "The angle whose sin is the given value",
                    example1Q: ["sin⁻¹","(","0",")"],
                    example1A: ["0"],
                    example2Q: ["sin⁻¹","(","“","(","§","#2","√","3",")","`","/","2","‘",")"],
                    example2A: ["60"]
                ),
                
                InfoData(
                    id: 7,
                    name: "cos⁻¹",
                    fullName: "Inverse Cosine",
                    category: "Trigonometry",
                    description: "The angle whose cos is the given value",
                    example1Q: ["cos⁻¹","(","0",")"],
                    example1A: ["90"],
                    example2Q: ["cos⁻¹","(","“","(","§","#2","√","3",")","`","/","2","‘",")"],
                    example2A: ["30"]
                ),
                
                InfoData(
                    id: 8,
                    name: "tan⁻¹",
                    fullName: "Inverse Tangent",
                    category: "Trigonometry",
                    description: "The angle whose tan is the given value",
                    example1Q: ["tan⁻¹","(","0",")"],
                    example1A: ["0"],
                    example2Q: ["tan⁻¹","(","“","(","§","#2","√","3",")","`","/","2","‘",")"],
                    example2A: ["40.893395"]
                ),
                
                InfoData(
                    id: 9,
                    name: "cot⁻¹",
                    fullName: "Inverse Cotangent",
                    category: "Trigonometry",
                    description: "The angle whose cot is the given value",
                    example1Q: ["cot⁻¹","(","0",")"],
                    example1A: ["90"],
                    example2Q: ["cot⁻¹","(","“","(","2","§","#2","√","3","`",")","/","3","‘",")"],
                    example2A: ["40.893395"]
                ),
                
                InfoData(
                    id: 10,
                    name: "sec⁻¹",
                    fullName: "Inverse Secant",
                    category: "Trigonometry",
                    description: "The angle whose sec is the given value",
                    example1Q: ["sec⁻¹","(","0",")"],
                    example1A: ["Error"],
                    example2Q: ["sec⁻¹","(","“","(","2","§","#2","√","3","`",")","/","3","‘",")"],
                    example2A: ["30"]
                ),
                
                InfoData(
                    id: 11,
                    name: "csc⁻¹",
                    fullName: "Inverse Cosecant",
                    category: "Trigonometry",
                    description: "The angle whose csc is the given value",
                    example1Q: ["csc⁻¹","(","0",")"],
                    example1A: ["Error"],
                    example2Q: ["csc⁻¹","(","“","(","2","§","#2","√","3","`",")","/","3","‘",")"],
                    example2A: ["60"]
                ),
                
                InfoData(
                    id: 12,
                    name: "sinh",
                    fullName: "Hyperbolic Sine",
                    category: "Trigonometry",
                    description: "(eᵃ - e⁻ᵃ)/2, a is 2× the hyperbolic angle",
                    example1Q: ["sinh","90","º"],
                    example1A: ["2.3012989"],
                    example2Q: ["sin","“","2π","/","3","‘"],
                    example2A: ["3.9986913"]
                ),
                
                InfoData(
                    id: 13,
                    name: "cosh",
                    fullName: "Hyperbolic Cosine",
                    category: "Trigonometry",
                    description: "(eᵃ + e⁻ᵃ)/2, a is 2× the hyperbolic angle",
                    example1Q: ["cosh","90","º"],
                    example1A: ["2.5091785"],
                    example2Q: ["cosh","“","2π","/","3","‘"],
                    example2A: ["4.1218361"]
                ),
                
                InfoData(
                    id: 14,
                    name: "tanh",
                    fullName: "Hyperbolic Tangent",
                    category: "Trigonometry",
                    description: "(sinh a)/(cosh a), a is 2× the hyperbolic angle",
                    example1Q: ["tanh","90","º"],
                    example1A: ["0.91715234"],
                    example2Q: ["tanh","“","2π","/","3","‘"],
                    example2A: ["0.97012382"]
                ),
                
                InfoData(
                    id: 15,
                    name: "coth",
                    fullName: "Hyperbolic Cotangent",
                    category: "Trigonometry",
                    description: "(cosh a)/(tanh a), a is 2× the hyperbolic angle",
                    example1Q: ["coth","90","º"],
                    example1A: ["1.0903314"],
                    example2Q: ["coth","“","2π","/","3","‘"],
                    example2A: ["1.0307963"]
                ),
                
                InfoData(
                    id: 16,
                    name: "sech",
                    fullName: "Hyperbolic Secant",
                    category: "Trigonometry",
                    description: "1/(cosh a), a is 2× the hyperbolic angle",
                    example1Q: ["sech","90","º"],
                    example1A: ["0.39853682"],
                    example2Q: ["sech","“","2π","/","3","‘"],
                    example2A: ["0.24261033"]
                ),
                
                InfoData(
                    id: 17,
                    name: "csch",
                    fullName: "Hyperbolic Cosecant",
                    category: "Trigonometry",
                    description: "1/(sinh a), a is 2× the hyperbolic angle",
                    example1Q: ["csch","90","º"],
                    example1A: ["0.43453721"],
                    example2Q: ["csch","“","2π","/","3","‘"],
                    example2A: ["0.25008182"]
                ),
                
                InfoData(
                    id: 18,
                    name: "sinh⁻¹",
                    fullName: "Inverse Hyperbolic Sine",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose sinh is the given value",
                    example1Q: ["sinh⁻¹","(","0",")"],
                    example1A: ["0"],
                    example2Q: ["sinh⁻¹","(","20",")"],
                    example2A: ["211.393"]
                ),
                
                InfoData(
                    id: 19,
                    name: "cosh⁻¹",
                    fullName: "Inverse Hyperbolic Cosine",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose cosh is the given value",
                    example1Q: ["cosh⁻¹","(","0",")"],
                    example1A: ["Error"],
                    example2Q: ["cosh⁻¹","(","20",")"],
                    example2A: ["211.32138"]
                ),
                
                InfoData(
                    id: 20,
                    name: "tanh⁻¹",
                    fullName: "Inverse Hyperbolic Tangent",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose tanh is the given value",
                    example1Q: ["tanh⁻¹","(","0",")"],
                    example1A: ["0"],
                    example2Q: ["tanh⁻¹","(","20",")"],
                    example2A: ["Error"]
                ),
                
                InfoData(
                    id: 21,
                    name: "coth⁻¹",
                    fullName: "Inverse Hyperbolic Cotangent",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose coth is the given value",
                    example1Q: ["coth⁻¹","(","0",")"],
                    example1A: ["Error"],
                    example2Q: ["coth⁻¹","(","20",")"],
                    example2A: ["2.8671799"]
                ),
                
                InfoData(
                    id: 22,
                    name: "sech⁻¹",
                    fullName: "Inverse Hyperbolic Secant",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose sech is the given value",
                    example1Q: ["sech⁻¹","(","0",")"],
                    example1A: ["∞"],
                    example2Q: ["sech⁻¹","(","20",")"],
                    example2A: ["Error"]
                ),
                
                InfoData(
                    id: 23,
                    name: "csch⁻¹",
                    fullName: "Inverse Hyperbolic Cosecant",
                    category: "Trigonometry",
                    description: "The hyperbolic angle whose csch is the given value",
                    example1Q: ["csch⁻¹","(","0",")"],
                    example1A: ["∞"],
                    example2Q: ["csch⁻¹","(","20",")"],
                    example2A: ["2.8635967"]
                )
                
            ],
            displayedInfo: [0,7,4,14]
        ),
        
        InfoCategory(
            id: 4,
            name: "Probability",
            desc: "These tools for probability can be used to calculate statistical information or the chance of something happening.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "!",
                    fullName: "Factorial",
                    category: "Probability",
                    description: "The product of all integers from the given number to 1",
                    example1Q: ["4!"],
                    example1A: ["4","×","3","×","2","×","1"],
                    example2Q: ["4!"],
                    example2A: ["24"]
                ),
                
                InfoData(
                    id: 1,
                    name: "nPr",
                    fullName: "Permutations",
                    category: "Probability",
                    description: "The number of possible ordered arrangements of a set",
                    example1Q: ["Ó","7","P","4","Ò"],
                    example1A: ["“","7!","/","(","7","-","4",")!","‘"],
                    example2Q: ["Ó","7","P","4","Ò"],
                    example2A: ["840"]
                ),
                
                InfoData(
                    id: 2,
                    name: "nCr",
                    fullName: "Combinations",
                    category: "Probability",
                    description: "The number of possible combinations of a set",
                    example1Q: ["Ó","7","C","4","Ò"],
                    example1A: ["“","7!","/","(","(","7","-","4",")!","×","4!",")","‘"],
                    example2Q: ["Ó","7","C","4","Ò"],
                    example2A: ["35"]
                ),
                
                InfoData(
                    id: 3,
                    name: "rand",
                    fullName: "Random Number",
                    category: "Probability",
                    description: "Returns a random number between 0 and 1",
                    example1Q: ["rand"],
                    example1A: ["0.3617841993"],
                    example2Q: ["rand","×","37"],
                    example2A: ["29.90217216"]
                ),
            ],
            displayedInfo: [0,2,1,3]
        ),
        
        InfoCategory(
            id: 5,
            name: "Miscellaneous",
            desc: "Miscellaneous constants and functions.",
            info: [
                
                InfoData(
                    id: 0,
                    name: "π",
                    fullName: "Pi",
                    category: "Miscellaneous",
                    description: "Ratio of a circle's circumference to diameter (3.1415926…)",
                    example1Q: ["2","×","π"],
                    example1A: ["6.2831853"],
                    example2Q: ["8π","+","3π"],
                    example2A: ["34.557519"]
                ),
                
                InfoData(
                    id: 1,
                    name: "e",
                    fullName: "Euler's Number",
                    category: "Miscellaneous",
                    description: "Euler's Number, the constant e (2.7182818…)",
                    example1Q: ["4","×","e"],
                    example1A: ["10.873127"],
                    example2Q: ["e","^","4.5"],
                    example2A: ["90.017131"]
                ),
                
                InfoData(
                    id: 2,
                    name: " ̅",
                    fullName: "Repeating Decimal",
                    category: "Miscellaneous",
                    description: "Adds a repeating symbol to a decimal place",
                    example1Q: ["2.1"," ̅"],
                    example1A: ["2.1111111111"],
                    example2Q: ["3.045"," ̅ ̅"],
                    example2A: ["3.0454545454"]
                ),
                
                InfoData(
                    id: 3,
                    name: "round",
                    fullName: "Round",
                    category: "Miscellaneous",
                    description: "Rounds to the nearest integer",
                    example1Q: ["round","(","35.638475",")"],
                    example1A: ["36"],
                    example2Q: ["round","(","-6","×","8.1",")"],
                    example2A: ["-49"]
                ),
                
                InfoData(
                    id: 4,
                    name: "floor",
                    fullName: "Floor",
                    category: "Miscellaneous",
                    description: "Rounds a number down",
                    example1Q: ["floor","(","35.638475",")"],
                    example1A: ["35"],
                    example2Q: ["floor","(","-6","×","8.1",")"],
                    example2A: ["-49"]
                ),
                
                InfoData(
                    id: 5,
                    name: "ceil",
                    fullName: "Ceiling",
                    category: "Miscellaneous",
                    description: "Rounds a number up",
                    example1Q: ["ceil","(","35.638475",")"],
                    example1A: ["36"],
                    example2Q: ["ceil","(","-6","×","8.1",")"],
                    example2A: ["-48"]
                ),
                
            ],
            displayedInfo: [0,1,4,2]
        )
    
    ]
    
    func buttonColor(buttonType: Int) -> [CGFloat] {
        
        if buttonType == 1 {
            return self.settings.theme.color1
        }
        else if buttonType == 2 {
            return self.settings.theme.color2
        }
        else if buttonType == 3 {
            return self.settings.theme.color3
        }
        else {
            return [0,0,0]
        }
    }
}
