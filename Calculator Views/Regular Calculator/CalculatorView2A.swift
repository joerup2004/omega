//
//  CalculatorView2A.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/20/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

// Calculator View 2A
// Regular Landscape
struct CalculatorView2A: View {
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing:0) {
                
                TextView(width: geometry.size.width, height: geometry.size.height*0.25, landscapeMode: true)
                    .padding(.top,geometry.size.width*0.015)
                    .padding(.bottom,geometry.size.width*0.01)
                
                HStack(spacing:0) {
                    
                    VStack(spacing:0) {
                            
                        HStack(spacing:0) {
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.specialColumns[settings.buttonSection][0], id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: true)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.specialColumns[settings.buttonSection][1], id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: true)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.specialColumns[settings.buttonSection][2], id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: true)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.specialColumns[settings.buttonSection][3], id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: true)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.specialColumns[settings.buttonSection][4], id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: true)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                        }
                        
                        HStack(spacing:0) {
                            
                            ForEach(self.uiData.sections[0...0], id: \.self) { button in
                                ButtonView(button: button, backgroundColor: settings.buttonSection == Int(String(button.first!))!-1 ? color([50,50,50]) : color([30,30,30]), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.0075)
                            }
                            .padding(.horizontal,geometry.size.width*0.004)
                            
                            ScrollView(.horizontal) {
                                HStack(spacing:0) {
                                    ForEach(self.uiData.sections[1...], id: \.self) { button in
                                        ButtonView(button: button, backgroundColor: settings.buttonSection == Int(String(button.first!))!-1 ? color([50,50,50]) : color([30,30,30]), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.03, displayNext: false)
                                            .padding(.bottom,geometry.size.height*0.0075)
                                    }
                                    .padding(.horizontal,geometry.size.width*0.004)
                                }
                            }
                            .frame(height: geometry.size.height/7.5)
                        }
                    }
                    .frame(width: geometry.size.width*0.54, alignment: .center)
                    .padding(.trailing, geometry.size.width*0.004)
                    
                    VStack(spacing:0) {
                        
                        HStack(spacing:0) {
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.numCol1, id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.numCol2, id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.numCol3, id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                            
                            VStack(spacing:0) {
                                
                                ForEach(self.uiData.opCol, id: \.self) { button in
                                    ButtonView(button: button, backgroundColor: color(self.settings.theme.color2), width: geometry.size.width*0.1, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.0075)
                                }
                                .padding(.horizontal,geometry.size.width*0.004)
                            }
                        }
                        .frame(width: geometry.size.width*0.432, alignment: .center)
                        
                        HStack(spacing:0) {

                            ButtonView(button: "C", backgroundColor: color([15,15,15]), width: geometry.size.width*0.136, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.0075)
                                    .padding(.horizontal,geometry.size.width*0.004)
                            
                            ButtonView(button: "⭠", backgroundColor: color([15,15,15]), width: geometry.size.width*0.136, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.0075)
                                    .padding(.horizontal,geometry.size.width*0.004)
                            
                            ButtonView(button: "=", backgroundColor: color([15,15,15]), width: geometry.size.width*0.136, height: geometry.size.height/7.5, fontSize: geometry.size.width*0.04, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.0075)
                                    .padding(.horizontal,geometry.size.width*0.004)
                        }
                        .frame(width: geometry.size.width*0.432, alignment: .center)
                    }
                    .frame(width: geometry.size.width*0.432, alignment: .center)
                }
            }
            .frame(width: geometry.size.width*0.98, alignment: .center)
            .padding(.horizontal,geometry.size.width*0.01)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, color([20,20,20])]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}
