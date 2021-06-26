//
//  CalculatorView3B.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/20/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

// Calculator View 3B
// Expanded Portrait, Wider
struct CalculatorView3B: View {
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
           
            VStack {
                
                TextView(width: geometry.size.width, height: geometry.size.height*0.32, landscapeMode: false)
                    .padding(.bottom,geometry.size.width*0.01)
                
                VStack(spacing:0) {
                    
                    HStack(spacing:0) {
                            
                        ForEach(self.uiData.altPortraitRow, id: \.self) { button in
                            ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.04, displayNext: false)
                                .padding(.bottom,geometry.size.height*0.007)
                        }
                        .padding(.horizontal,geometry.size.width*0.008)
                    }
                
                    HStack(spacing:0) {
                    
                        VStack(spacing:0) {
                            
                            ForEach(self.uiData.altPortraitCol1, id: \.self) { button in
                                ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.04, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.007)
                            }
                            .padding(.horizontal,geometry.size.width*0.008)
                        }
                        
                        VStack(spacing:0) {
                            
                            ForEach(self.uiData.altPortraitCol2, id: \.self) { button in
                                ButtonView(button: button, backgroundColor: color(self.settings.theme.color3), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.04, displayNext: false)
                                    .padding(.bottom,geometry.size.height*0.007)
                            }
                            .padding(.horizontal,geometry.size.width*0.008)
                        }
                        
                        VStack(spacing:0) {
                        
                            HStack(spacing:0) {
                                
                                VStack(spacing:0) {
                                    
                                    ForEach(self.uiData.numCol1, id: \.self) { button in
                                        ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                            .padding(.bottom,geometry.size.height*0.007)
                                    }
                                    .padding(.horizontal,geometry.size.width*0.008)
                                }
                                
                                VStack(spacing:0) {
                                    
                                    ForEach(self.uiData.numCol2, id: \.self) { button in
                                        ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                            .padding(.bottom,geometry.size.height*0.007)
                                    }
                                    .padding(.horizontal,geometry.size.width*0.008)
                                }
                                
                                VStack(spacing:0) {
                                    
                                    ForEach(self.uiData.numCol3, id: \.self) { button in
                                        ButtonView(button: button, backgroundColor: color(self.settings.theme.color1), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                            .padding(.bottom,geometry.size.height*0.007)
                                    }
                                    .padding(.horizontal,geometry.size.width*0.008)
                                }
                                
                                VStack(spacing:0) {
                                    
                                    ForEach(self.uiData.opCol, id: \.self) { button in
                                        ButtonView(button: button, backgroundColor: color(self.settings.theme.color2), width: geometry.size.width*0.15, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                            .padding(.bottom,geometry.size.height*0.007)
                                    }
                                    .padding(.horizontal,geometry.size.width*0.008)
                                }
                            }
                            
                            HStack(spacing:0) {
                            
                                ButtonView(button: "C", backgroundColor: color([15,15,15]), width: geometry.size.width*0.2, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.007)
                                        .padding(.horizontal,geometry.size.width*0.008)
                                
                                ButtonView(button: "⭠", backgroundColor: color([15,15,15]), width: geometry.size.width*0.2, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.007)
                                        .padding(.horizontal,geometry.size.width*0.008)
                                
                                ButtonView(button: "=", backgroundColor: color([15,15,15]), width: geometry.size.width*0.2, height: geometry.size.height/9.5, fontSize: geometry.size.height*0.06, displayNext: false)
                                        .padding(.bottom,geometry.size.height*0.007)
                                        .padding(.horizontal,geometry.size.width*0.008)
                            }
                        }
                    }
                }
                .frame(width: geometry.size.width*0.98, height: geometry.size.height*0.65, alignment: .center)
            }
            .frame(width: geometry.size.width*0.98, alignment: .center)
            .padding(.horizontal,geometry.size.width*0.008)
        }
        .background(LinearGradient(gradient: Gradient(colors: [.black, color([20,20,20])]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all))
    }
}
