//
//  CalculatorView1.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/20/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

// Calculator View 1
// Regular Portrait
struct CalculatorView1: View {
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
           
            VStack(spacing:0) {
                
                TextView(width: geometry.size.width, height: geometry.size.height*0.36, landscapeMode: false)
                    .padding(.top,-geometry.size.height*0.025)
                    .padding(.bottom,geometry.size.width*0.01)
                
                ScrollView(.horizontal) {
                    
                    HStack(spacing:0) {
                        
                        ForEach(self.uiData.scrollRow, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width/4.36, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.045, displayNext: false)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                }
                .frame(width: geometry.size.width*0.98, height: geometry.size.height/9.5, alignment: .center)
                .background(color(self.settings.theme.color4))
                .cornerRadius((geometry.size.width/4.36+geometry.size.height/10)/2 * 0.4)
                .padding(.horizontal,geometry.size.width*0.005)
                .padding(.bottom,geometry.size.height*0.008)
                
                HStack(spacing:0) {
                    
                    VStack(spacing:0) {
                        
                        ForEach(self.uiData.numCol1, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width/4.36, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                .padding(.bottom,geometry.size.height*0.005)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                    
                    VStack(spacing:0) {
                        
                        ForEach(self.uiData.numCol2, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width/4.36, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                .padding(.bottom,geometry.size.height*0.005)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                    
                    VStack(spacing:0) {
                        
                        ForEach(self.uiData.numCol3, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width/4.36, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                .padding(.bottom,geometry.size.height*0.005)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                    
                    VStack(spacing:0) {
                        
                        ForEach(self.uiData.opCol, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color2), width: geometry.size.width/4.36, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                .padding(.bottom,geometry.size.height*0.005)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                }
                
                HStack(spacing:0) {
                
                    ButtonView(button: "C", backgroundColor: color([15,15,15]), width: geometry.size.width*0.315, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                            .padding(.horizontal,geometry.size.width*0.008)
                    
                    ButtonView(button: "⭠", backgroundColor: color([15,15,15]), width: geometry.size.width*0.315, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                            .padding(.horizontal,geometry.size.width*0.008)
                    
                    ButtonView(button: "=", backgroundColor: color([15,15,15]), width: geometry.size.width*0.315, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                            .padding(.horizontal,geometry.size.width*0.008)
                }
                .padding(.top,geometry.size.height*0.002)
            }
            .frame(width: geometry.size.width*0.98, alignment: .center)
            .padding(.horizontal,geometry.size.width*0.008)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, color([20,20,20])]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}
