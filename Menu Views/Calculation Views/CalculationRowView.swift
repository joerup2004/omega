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
    
    var inSheet: Bool = false
    var sourcePresentationMode: Binding<PresentationMode>
    
    @ViewBuilder
    var body: some View {
        
        GeometryReader { geometry in
            
            NavigationLink(destination: CalculationView(calculation: self.calculation, index: self.calculation.id, inSheet: inSheet, sourcePresentationMode: sourcePresentationMode)) {
                    
                HStack(spacing: 0) {
                    
                    VStack(spacing: 0) {
                        
                        Spacer()
                        
                        Image(systemName: "number.square.fill")
                            .shadow(color: Color.init(white:0.5), radius: self.calculation.save ? 5 : 0)
                            .foregroundColor(color(self.settings.theme.color1))
                            .font(.system(size: 50))
                            .padding(.bottom, 1)
                        
                        if self.calc.currentDate(format: "date") != self.calculation.date {
                            Text(self.calculation.date)
                                .foregroundColor(Color.init(white: 0.7))
                                .font(.custom("Helvetica_Neue", size: 16, relativeTo: .body))
                                .frame(width: geometry.size.width*0.15, height: 15, alignment: .center)
                                .minimumScaleFactor(0.1)
                                .lineLimit(0)
                        }
                        else {
                            Text(self.calculation.time)
                                .foregroundColor(Color.init(white: 0.7))
                                .font(.custom("Helvetica_Neue", size: 16, relativeTo: .body))
                                .frame(width: geometry.size.width*0.15, height: 15, alignment: .center)
                                .minimumScaleFactor(0.1)
                                .lineLimit(0)
                        }
                        
                        Spacer()
                        
                    }
                    .frame(height: 90)
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        
                        Spacer()
                        
                        TextViews(
                            array: self.calculation.topOutput,
                            formattingGuide: self.calculation.topFormattingGuide,
                            size: resize(array: self.calculation.topOutput, formattingGuide: self.calculation.topFormattingGuide, size: 20, width: geometry.size.width*0.7, position: "none", landscape: false),
                            position: "top",
                            scrollable: false
                        )
                        .foregroundColor(Color.init(white: 0.7))
                        .frame(width: geometry.size.width*0.7, height: 20, alignment: .trailing)
                        .padding(.horizontal, 10)
                        
                        TextViews(
                            array: self.calculation.mainOutput,
                            formattingGuide: self.calculation.mainFormattingGuide,
                            size: resize(array: self.calculation.mainOutput, formattingGuide: self.calculation.mainFormattingGuide, size: 40, width: geometry.size.width*0.7, position: "none", landscape: false),
                            position: "main",
                            scrollable: false
                        )
                        .foregroundColor(Color.init(white: 1))
                        .frame(width: geometry.size.width*0.7, height: 40, alignment: .trailing)
                        .padding(.horizontal, 10)
                        
                        if self.calculation.name == "Calculation" {
                            TextViews(
                                array: self.calculation.bottomOutput,
                                formattingGuide: self.calculation.bottomFormattingGuide,
                                size: resize(array: self.calculation.bottomOutput, formattingGuide: self.calculation.bottomFormattingGuide, size: 16, width: geometry.size.width*0.7, position: "none", landscape: false),
                                position: "bottom",
                                scrollable: false
                            )
                            .foregroundColor(Color.init(white: 0.7))
                            .frame(width: geometry.size.width*0.7, height: 16, alignment: .trailing)
                            .padding(.horizontal, 10)
                        }
                        else {
                            Text(self.calculation.name)
                                .foregroundColor(color(self.settings.theme.color1))
                                .font(.custom("HelveticaNeue", size: 16, relativeTo: .headline))
                                .fontWeight(self.settings.buttonWeight == 0 ? .light : self.settings.buttonWeight == 2 ? .bold : .medium)
                                .frame(width: geometry.size.width*0.7, height: 16, alignment: .trailing)
                                .padding(.horizontal, 10)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 90)
                }
            }
        }
    }
}
