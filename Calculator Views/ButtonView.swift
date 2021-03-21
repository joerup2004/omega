//
//  ButtonView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/14/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

// ButtonView manages the view for each button in the calculator

import SwiftUI

struct ButtonView: View {
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    var input = Input.input
    var uiData = UIData.uiData
    
    var button: String
    var backgroundColor: Color
    var width: CGFloat
    var height: CGFloat
    var fontSize: CGFloat
    var displayNext: Bool
    var active = true
    
    var body: some View {
        
        Button(action: {
        }) {
            VStack(spacing: 0) {
                
                Text(self.buttonText(button))
                    .font(.custom(self.settings.lightBut ? "HelveticaNeue" : "HelveticaNeue-Bold", size: fontSize))
                    .foregroundColor(color([255,255,255]))
                    .minimumScaleFactor(0.1)
                    .lineLimit(0)
                    .frame(width: self.width*0.75)
                
            }
            .frame(width: self.width, height: self.height, alignment: .center)
            .background(self.backgroundColor)
            .cornerRadius((self.width+self.height)/2 * 0.4)
            .onTapGesture() {active == true ? self.pressButton(button: self.button, pressType: "tap") : nil}
            .onLongPressGesture() {active == true ? self.pressButton(button: self.button, pressType: "hold") : nil}
        }
    }
    
    
    // MARK: - Button Press
    
    func pressButton(button:String,pressType:String) {
        
        // Play click sound
//        if button == "=" {
//            playSound(sound: "click.mp3")
//        }
        
        if ["1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th"].contains(button) {
            settings.buttonSection = Int(String(button.first!))!-1
            return
        }
        
        // Make sure the inputted button is not a disabled button
        if hub.disabledButtons.contains(button) {
            print("(Button disabled: \"\(button)\")")
            return
        }
        
        // Queue a parentheses if button is an auto par button
        if hub.autoParButtons.contains(button) {
            print("(Auto par: before \"\(button)\")")
            input.queueInput(button: "(", pressType: "tap", record: false)
        }
    
        // Send the button data to the calculate class
        input.queueInput(button: button, pressType: pressType, record: true)
        
        // Take down the menu
        self.settings.showMenu = false
        
    }
    
    
    // MARK: - Button Text
    
    func buttonText(_ button: String) -> String {
        
        var text = button
        
        if text == "." && self.settings.commaDecimal {
            text = ","
        }
        
        return text
    }
    
}

