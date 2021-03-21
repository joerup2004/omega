//
//  CalculationRowView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct CalculationRowView: View {
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    @ObservedObject var calc = Calculations.calc
    var input = Input.input
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var calculation: Calculation
    @State var saved: Bool
    var width: CGFloat
    
    @ViewBuilder
    var body: some View {
                
        ZStack {
            
            Rectangle()
                .frame(width: self.width*0.96, height: 100+self.width*0.01, alignment: .center)
                .foregroundColor(Color.init(white: self.calculation.save ? 0.6 : 0.3))
                .cornerRadius(20)
            
            Rectangle()
                .frame(width: self.width*0.95, height: 100, alignment: .center)
                .foregroundColor(Color.init(white: 0.2))
                .cornerRadius(20)
                
            HStack(spacing: 0) {
                
                VStack {
                    
                    Spacer()
                    
                    Image(systemName: "number.square.fill")
                        .foregroundColor(color(self.settings.theme.color1))
                        .font(.system(size: 50))
                    
                    Spacer()
                    
                    if self.calc.currentDate(format: "date") != self.calculation.date {
                      
                        Text(self.calculation.date)
                            .foregroundColor(Color.init(white: 0.7))
                            .font(.custom("HelveticaNeue", size: 15))
                            .frame(width: self.width*0.15, height: 15, alignment: .center)
                            .minimumScaleFactor(0.1)
                            .lineLimit(0)
                    }
                    else {
                        
                        Text(self.calculation.time)
                            .foregroundColor(Color.init(white: 0.7))
                            .font(.custom("HelveticaNeue", size: 15))
                            .frame(width: self.width*0.15, height: 15, alignment: .center)
                            .minimumScaleFactor(0.1)
                            .lineLimit(0)
                    }
                    
                    Spacer()
                    
                }
                .frame(width: self.width*0.15, height: 90, alignment: .leading)
                .padding(.leading, self.width*0.02)
                
                VStack(spacing: 1) {
                    
                    Spacer()
                    
                    TextViews(
                        array: self.calculation.topOutput,
                        formattingGuide: self.calculation.topFormattingGuide,
                        size: resize(array: self.calculation.topOutput, formattingGuide: self.calculation.topFormattingGuide, size: 20, width: self.width*0.65, position: "top", landscape: false),
                        position: "top"
                    )
                        .foregroundColor(Color.init(white: 0.7))
                        .frame(width: self.width*0.65, height: 20, alignment: .trailing)
                        .padding(.horizontal, 10)
                    
                    TextViews(
                        array: self.calculation.mainOutput,
                        formattingGuide: self.calculation.mainFormattingGuide,
                        size: resize(array: self.calculation.mainOutput, formattingGuide: self.calculation.mainFormattingGuide, size: 40, width: self.width*0.65, position: "main", landscape: false),
                        position: "main"
                    )
                        .foregroundColor(Color.init(white: 1))
                        .frame(width: self.width*0.65, height: 40, alignment: .trailing)
                        .padding(.horizontal, 10)
                    
                    if self.calculation.name == "Calculation" {
                        TextViews(
                            array: self.calculation.bottomOutput,
                            formattingGuide: self.calculation.bottomFormattingGuide,
                            size: resize(array: self.calculation.bottomOutput, formattingGuide: self.calculation.bottomFormattingGuide, size: 16, width: self.width*0.65, position: "bottom", landscape: false),
                            position: "bottom"
                        )
                            .foregroundColor(Color.init(white: 0.7))
                            .frame(width: self.width*0.65, height: 16, alignment: .trailing)
                            .padding(.horizontal, 10)
                    }
                    else {
                        Text(self.calculation.name)
                            .foregroundColor(color(self.settings.theme.color1))
                            .font(.custom(self.settings.light ? "HelveticaNeue" : "HelveticaNeue-Bold", size: 16))
                            .frame(width: self.width*0.65, height: 16, alignment: .trailing)
                            .padding(.horizontal, 10)
                    }
                    
                    Spacer()
                }
                .frame(width: self.width*0.65, height: 75, alignment: .center)
                
                Image(systemName: "chevron.right")
                    .imageScale(.large)
                    .foregroundColor(color(self.settings.theme.color1))
                    .frame(width: self.width*0.1, height: 75, alignment: .center)
                    
            }
            .frame(width: self.width*0.9, height: 100, alignment: .center)
            
            NavigationLink(destination: CalculationView(calculation: self.calculation, index: self.calculation.id)) {
                
                EmptyView()
                    .contextMenu {
                    
                    // Set
                    Button(action: {
                        
                        if [["Error"],["∞"]].contains(self.calculation.result) {
                            
                        }
                        else if self.hub.mainOutput == self.calculation.mainOutput && self.hub.topOutput == self.calculation.topOutput && self.hub.bottomOutput == self.calculation.bottomOutput {
                            
                            self.settings.showCalculations = false
                            self.settings.showMenu = false
                        }
                        else {
                            
                            self.input.setResult(calculation: self.calculation)
                            self.settings.showCalculations = false
                            self.settings.showMenu = false
                        }
                        
                    }) {
                        HStack {
                            
                            Text("Set")
                                .fixedSize()
                                .font(.custom("HelveticaNeue", size: 16))
                                .foregroundColor(color([150,150,150]))
                            
                            if (self.hub.mainOutput == self.hub.mainOutput && self.hub.topOutput == self.hub.topOutput && self.hub.bottomOutput == self.hub.bottomOutput) || [["Error"],["∞"]].contains(self.hub.result) {
                            
                                Image(systemName: "arrow.uturn.down.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(color([150,150,150]))
                            }
                            else {
                                Image(systemName: "arrow.uturn.down.circle")
                                .imageScale(.large)
                                .foregroundColor(color([150,150,150]))
                            }
                        }
                    }
                    
                    Spacer()
                        
                    // Insert
                    Button(action: {
                        
                        if self.input.canInsert && ![["Error"],["∞"]].contains(self.calculation.result) {
                            self.input.insertCalculation(calculation: self.calculation)
                            self.settings.showCalculations = false
                            self.settings.showMenu = false
                        }
                        
                    }) {
                        HStack {
                            
                            if self.input.canInsert && ![["Error"],["∞"]].contains(self.hub.result) {
                                Image(systemName: "plus.circle")
                                    .imageScale(.large)
                                    .foregroundColor(color([150,150,150]))
                            }
                            else {
                                Image(systemName: "plus.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(color([150,150,150]))
                            }
                            
                            Text("Insert")
                                .fixedSize()
                                .font(.custom("HelveticaNeue", size: 16))
                                .foregroundColor(color([150,150,150]))
                        }
                    }
                    
                    Spacer()
                    
                    // Edit
                    Button(action: {
                        
                        self.input.editCalculation(calculation: self.calculation)
                        self.settings.showCalculations = false
                        self.settings.showMenu = false
                        
                    }) {
                        HStack {
                            
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(color([150,150,150]))
                            
                            Text("Edit")
                                .fixedSize()
                                .font(.custom("HelveticaNeue", size: 16))
                                .foregroundColor(color([150,150,150]))
                        }
                    }
                    
                    Spacer()
                    
                    // Save
                    Button(action: {
                        
                        self.calc.saveCalculation(calculation: self.calculation)
                        
                    }) {
                        HStack {
                            
                            if self.calculation.save {
                                Image(systemName: "arrow.down.circle.fill")
                                    .imageScale(.large)
                                    .foregroundColor(color([150,150,150]))
                            }
                            else {
                                Image(systemName: "arrow.down.circle")
                                .imageScale(.large)
                                .foregroundColor(color([150,150,150]))
                            }
                            
                            Text("Save")
                                .fixedSize()
                                .font(.custom("HelveticaNeue", size: 16))
                                .foregroundColor(color([150,150,150]))
                        }
                    }
                    
                    Spacer()
                    
                    // Delete
                    Button(action: {
                        
                        self.calc.deleteCalculation(calculation: self.calculation)
                        self.presentationMode.wrappedValue.dismiss()
                        
                    }) {
                        HStack {
                            
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(color([150,150,150]))
                            
                            Text("Delete")
                                .fixedSize()
                                .font(.custom("HelveticaNeue", size: 16))
                                .foregroundColor(color([150,150,150]))
                        }
                    }
                }
            }
//            .buttonStyle(PlainButtonStyle())
            .frame(width: 0)
            .opacity(0)
        }
        .frame(width: self.width, height: 100+self.width*0.01, alignment: .center)
        .padding(.vertical, 2)
    }
}
