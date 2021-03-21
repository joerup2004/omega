//
//  HeaderButtonView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct HeaderButtonView: View {
    
    @ObservedObject var settings = Settings.settings
    @ObservedObject var hub = Hub.hub
    var input = Input.input
    var uiData = UIData.uiData
    
    var width: CGFloat
    var height: CGFloat
    var mode: String
    
    @ViewBuilder
    var body: some View {
        
        if mode == "header" {
            
            GeometryReader { geometry in
                
                VStack {
                    
                    HStack(spacing: 0) {
                        
                        Button(action: {
                            withAnimation {
                                self.settings.showMenu = true
                            }
                        }) {
                            Image(systemName: "text.justify")
                                .font(.system(size: self.height*0.7))
                                .foregroundColor(color([150,150,150]))
                                .padding()
                        }
                        .frame(width: self.width*0.15)
                        
                        HStack {
                            
                            ZStack {
                                
                                if self.containsTrigFunction() || !self.settings.smartDegRad {
                                
                                    Button(action: {
                                        self.settings.radians.toggle()
                                        refresh()
                                    }) {
                                        ZStack {
                                            
                                            Rectangle()
                                                .foregroundColor(Color.init(white: 0.1))
                                                .frame(width: self.height*1.75, height: self.height)
                                                .cornerRadius(10)
                                            
                                            Text(self.settings.radians ? "RAD" : "DEG")
                                                .foregroundColor(Color.init(white: 0.7))
                                                .font(.custom("HelveticaNeue", size: self.height*0.5))
                                                .frame(width: self.height*1.5)
                                                .minimumScaleFactor(0.1)
                                                .lineLimit(0)
                                        }
                                    }
                                    .animation(self.settings.animateText ? .easeInOut : nil)
                                }
                            }
                            .frame(width: self.width*0.15)
                            
                            Spacer()
                        }
                        .frame(width: self.width*0.67, height: self.height)
                        .padding(.horizontal, self.width*0.02)
                        
                        Button(action: {
                            self.settings.showCalculations = true
                        }) {
                            Image(systemName: "chevron.down.circle")
                                .font(.system(size: self.height*0.7))
                                .foregroundColor(color([150,150,150]))
                                .padding()
                        }
                        .frame(width: self.width*0.15)
                        .sheet(isPresented: self.$settings.showCalculations) {
                            CalculationMenuView()
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
            .frame(width: width, height: height, alignment: .center)
        }
        
        else if mode == "leftColumn" {
            
            GeometryReader { geometry in
                        
                VStack {
                
                    Button(action: {
                        withAnimation {
                            self.settings.showMenu = true
                        }
                    }) {
                        Image(systemName: "text.justify")
                            .font(.system(size: self.height*0.25))
                            .foregroundColor(color([150,150,150]))
                            .padding()
                    }
                    .frame(width: self.width, height: self.height*0.25, alignment: .center)
                    .padding(.vertical, self.height*0.1)
                    
                    Button(action: {
                        self.settings.showCalculations = true
                    }) {
                        Image(systemName: "chevron.down.circle")
                            .font(.system(size: self.height*0.25))
                            .foregroundColor(color([150,150,150]))
                            .padding()
                    }
                    .frame(width: self.width, height: self.height*0.25, alignment: .center)
                    .sheet(isPresented: self.$settings.showCalculations) {
                        CalculationMenuView()
                    }
                    .padding(.vertical, self.height*0.1)
                    
                }
            }
            .frame(width: width, height: height, alignment: .center)
        }
        
        else if mode == "landscapeHeader" {
            
            GeometryReader { geometry in
            
                HStack {
                    
                    ZStack {
                        
                        if self.containsTrigFunction() || !self.settings.smartDegRad {
                    
                            Button(action: {
                                self.settings.radians.toggle()
                                refresh()
                            }) {
                                ZStack {
                                    
                                    Rectangle()
                                        .foregroundColor(Color.init(white: 0.1))
                                        .frame(width: self.height*1.2, height: self.height*0.8)
                                        .cornerRadius(self.height*0.2)
                                    
                                    Text(self.settings.radians ? "RAD" : "DEG")
                                        .foregroundColor(Color.init(white: 0.7))
                                        .font(.custom("HelveticaNeue", size: self.height*0.4))
                                        .frame(width: self.height)
                                        .minimumScaleFactor(0.1)
                                        .lineLimit(0)
                                }
                            }
                            .animation(self.settings.animateText ? .easeInOut : nil)
                        }
                    }
                    .frame(width: self.width*0.25)
                    .padding(.top, self.height*0.2)
                    
                    Spacer()
                }
                .frame(width: self.width, height: self.height)
                .padding(.leading, self.width*0.05)
            }
        }
    }
    
    // Contains Trig Function
    // Determine if the current outputs contain a trig function
    func containsTrigFunction() -> Bool {
        
        let trigFunctions = ["sin","cos","tan","csc","sec","cot","sin⁻¹","cos⁻¹","tan⁻¹","csc⁻¹","sec⁻¹","cot⁻¹","sinh","cosh","tanh","csch","sech","coth","sinh⁻¹","cosh⁻¹","tanh⁻¹","csch⁻¹","sech⁻¹","coth⁻¹"]
        
        for function in trigFunctions {
            
            if hub.mainOutput.contains(function) || hub.topOutput.contains(function) || hub.bottomOutput.contains(function) {
                return true
            }
        }
        
        return false
    }
}
