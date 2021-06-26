//
//  CalculationView.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct CalculationView: View {
    
    @ObservedObject var hub = Hub.hub
    @ObservedObject var settings = Settings.settings
    @ObservedObject var calc = Calculations.calc
    @ObservedObject var formatting = Formatting.formatting
    @ObservedObject var calculation: Calculation
    var input = Input.input
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var editName = false
    @State var showSteps = false
    
    var index: Int
    
    var inSheet: Bool = false
    var sourcePresentationMode: Binding<PresentationMode>
    
    @ViewBuilder
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack {
                    
                    Spacer()
                
                    HStack {
                        
                        Spacer()
                        
                        Image(systemName: "number.square.fill")
                            .foregroundColor(color(self.settings.theme.color1))
                            .shadow(color: Color.init(white:0.5), radius: self.calculation.save ? 5 : 0)
                            .font(.system(size: 100))
                            .padding(.horizontal, geometry.size.width*0.01)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack {
                                if self.editName || self.calculation.name != "Calculation" {
                                    TextField("Calculation", text: self.$calculation.name, onCommit: {
                                        
                                        while self.calculation.name.last == " " {
                                            self.calculation.name.removeLast()
                                        }
                                        while self.calculation.name.first == " " {
                                            self.calculation.name.removeFirst()
                                        }
                                        if self.calculation.name.isEmpty {
                                            self.calculation.name = "Calculation"
                                        }
                                        
                                        self.updateCalculations(calculation: self.calculation)
                                        
                                        self.editName.toggle()
                                        
                                        print("(Calculation) Updated name to \(self.calculation.name)")
                                    })
                                    .font(.custom("HelveticaNeue", size: 30, relativeTo: .title2))
                                    .foregroundColor(self.calculation.name == "Calculation" ? .white : color(self.settings.theme.color1))
                                    .minimumScaleFactor(0.5)
                                }
                                else {
                                    Text(self.calculation.name)
                                        .font(.custom("HelveticaNeue", size: 30, relativeTo: .title2))
                                        .foregroundColor(self.calculation.name == "Calculation" ? .white : color(self.settings.theme.color1))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                    
                                    Button {
                                        self.editName.toggle()
                                        self.calculation.name = ""
                                    } label: {
                                        Image(systemName: "pencil")
                                            .imageScale(.medium)
                                            .foregroundColor(Color.init(white:0.6))
                                    }
                                    Spacer()
                                }
                            }
                            
                            Text(self.calculation.fullDate)
                                .foregroundColor(Color.init(white:0.6))
                                .font(.custom("HelveticaNeue", size: 18, relativeTo: .body))
                                .minimumScaleFactor(0.5)
                            
                            Text(self.calculation.fullTime)
                                .foregroundColor(Color.init(white:0.6))
                                .font(.custom("HelveticaNeue", size: 18, relativeTo: .body))
                                .minimumScaleFactor(0.5)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width*0.9 > 800 ? 800 : geometry.size.width*0.9)
                    
                    Spacer()
                }
                .frame(width: geometry.size.width*0.9 > 800 ? 800 : geometry.size.width*0.9)
            
                ZStack {

                    Rectangle()
                        .frame(width: geometry.size.width*0.85 > 800 ? 800-geometry.size.width*0.01 : geometry.size.width*0.90, height: 200, alignment: .center)
                        .foregroundColor(Color.init(white: 0.2))
                        .cornerRadius(20)
                
                    VStack {
                        
                        Spacer()
                        
                        TextViews(
                            array: self.calculation.topOutput,
                            formattingGuide: self.calculation.topFormattingGuide,
                            size: resize(array: self.calculation.topOutput, formattingGuide: self.calculation.topFormattingGuide, size: 40, width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, position: "none", landscape: false),
                            position: "top"
                        )
                        .foregroundColor(Color.init(white: 0.7))
                        .frame(width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, height: 40, alignment: .trailing)
                        .padding(.horizontal, 10)
                        
                        TextViews(
                            array: self.calculation.mainOutput,
                            formattingGuide: self.calculation.mainFormattingGuide,
                            size: resize(array: self.calculation.mainOutput, formattingGuide: self.calculation.mainFormattingGuide, size: 80, width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, position: "none", landscape: false),
                            position: "main"
                        )
                        .foregroundColor(Color.init(white: 1))
                        .frame(width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, height: 80, alignment: .trailing)
                        .padding(.horizontal, 10)
                        
                        TextViews(
                            array: self.calculation.bottomOutput,
                            formattingGuide: self.calculation.bottomFormattingGuide,
                            size: resize(array: self.calculation.bottomOutput, formattingGuide: self.calculation.bottomFormattingGuide, size: 35, width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, position: "none", landscape: false),
                            position: "bottom"
                        )
                        .foregroundColor(Color.init(white: 0.7))
                        .frame(width: geometry.size.width*0.8 > 800 ? 800-geometry.size.width*0.1 : geometry.size.width*0.8, height: 35, alignment: .trailing)
                        .padding(.horizontal, 10)
                        .onTapGesture {
                            self.input.swapAlternateResults(calculation: self.calculation)
                            self.updateCalculations(calculation: self.calculation)
                        }
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 5)
                    
                HStack(spacing:0) {
                    
                    Spacer()
                
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
                        VStack {
                            Spacer()
                            Image(systemName: (self.hub.mainOutput == self.calculation.mainOutput && self.hub.topOutput == self.calculation.topOutput && self.hub.bottomOutput == self.calculation.bottomOutput) || [["Error"],["∞"]].contains(self.calculation.result) ? "arrow.uturn.down.circle.fill" : "arrow.uturn.down.circle")
                                .imageScale(.large)
                                .foregroundColor(Color.init(white:0.6))
                            Text("Set")
                                .fixedSize()
                                .foregroundColor(Color.init(white:0.6))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width*0.19)
                        
                    // Insert
                    Button(action: {
                        if self.input.canInsert && ![["Error"],["∞"]].contains(self.calculation.result) {
                            self.input.insertCalculation(calculation: self.calculation)
                            self.settings.showCalculations = false
                            self.settings.showMenu = false
                        }
                    }) {
                        VStack {
                            Spacer()
                            Image(systemName: self.input.canInsert && ![["Error"],["∞"]].contains(self.calculation.result) ? "plus.circle" : "plus.circle.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.init(white:0.6))
                            Text("Insert")
                                .fixedSize()
                                .foregroundColor(Color.init(white:0.6))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width*0.19)
                    
                    // Edit
                    Button(action: {
                        self.input.editCalculation(calculation: self.calculation)
                        self.settings.showCalculations = false
                        self.settings.showMenu = false
                        
                    }) {
                        VStack {
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .imageScale(.large)
                                .foregroundColor(Color.init(white:0.6))
                            Text("Edit")
                                .fixedSize()
                                .foregroundColor(Color.init(white:0.6))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width*0.19)
                    
                    // Save
                    Button(action: {
                        self.calc.saveCalculation(calculation: self.calculation)
                    }) {
                        VStack {
                            Spacer()
                            Image(systemName: self.calculation.save ? "arrow.down.circle.fill" : "arrow.down.circle")
                                .imageScale(.large)
                                .foregroundColor(Color.init(white:0.6))
                            Text("Save")
                                .fixedSize()
                                .foregroundColor(Color.init(white:0.6))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width*0.19)
                    
                    // Delete
                    Button(action: {
                        self.calc.deleteCalculation(calculation: self.calculation)
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        VStack {
                            Spacer()
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(Color.init(white:0.6))
                            Text("Delete")
                                .fixedSize()
                                .foregroundColor(Color.init(white:0.6))
                            Spacer()
                        }
                    }
                    .frame(width: geometry.size.width*0.19)
                    
                    Spacer()
                }
                .padding(.vertical, 5)
                    
                
                // STEPS VIEW
                // NEEDS TESTING & FIXING BEFORE OFFICIAL RELEASE
//                ZStack {
//
//                    Rectangle()
//                        .frame(width: geometry.size.width*0.91,
//                               height: self.showSteps ? CGFloat(self.calculation.stepsExpressions.count)*geometry.size.height*0.09 + geometry.size.height*0.1 + geometry.size.width*0.01 : geometry.size.height*0.1 + geometry.size.width*0.01,
//                               alignment: .center)
//                        .foregroundColor(Color.init(white: 0.3))
//                        .cornerRadius(20)
//                        .animation(.spring())
//
//                    Rectangle()
//                        .frame(width: geometry.size.width*0.9,
//                               height: self.showSteps ? CGFloat(self.calculation.stepsExpressions.count)*geometry.size.height*0.09 + geometry.size.height*0.1 : geometry.size.height*0.1,
//                               alignment: .center)
//                        .foregroundColor(Color.init(white: 0.2))
//                        .cornerRadius(20)
//                        .animation(.spring())
//
//                    VStack(spacing:0) {
//
//                        Button(action: {
//                            self.showSteps.toggle()
//                        }) {
//                            HStack {
//
//                                Text("Steps")
//                                    .foregroundColor(color([150,150,150]))
//                                    .font(.custom("HelveticaNeue-Bold", size: 22))
//                                    .minimumScaleFactor(0.5)
//                                    .padding(.vertical, 2)
//
//                                Spacer()
//
//                                Image(systemName: self.showSteps ? "chevron.down" : "chevron.right")
//                                    .foregroundColor(color([150,150,150]))
//                            }
//                        }
//                        .frame(width: geometry.size.width*0.8, height: geometry.size.height*0.1, alignment: .center)
//                        .animation(.spring())
//
//                        if self.showSteps {
//
//                            ForEach(0 ..< self.calculation.stepsExpressions.count, id: \.self) { index in
//
//                                VStack {
//
//                                    Rectangle()
//                                        .frame(width: geometry.size.width*0.9, height: geometry.size.height*0.001, alignment: .center)
//                                        .foregroundColor(Color.init(white: 0.15))
//
//                                    Spacer()
//
//                                    TextViews(
//                                        array: self.calculation.stepsExpressions[index],
//                                        formattingGuide: self.formatting.createFormattingGuide(array: self.calculation.stepsExpressions[index]),
//                                        size: resize(array: self.calculation.stepsExpressions[index], formattingGuide: self.formatting.createFormattingGuide(array: self.calculation.stepsExpressions[index]), size: geometry.size.height*0.04, width: geometry.size.width*0.9, position: "top", landscape: false),
//                                        position: "top"
//                                    )
//                                    .foregroundColor(Color.init(white: index == self.calculation.stepsExpressions.count-1 ? 1 : 0.7))
//                                    .frame(width: geometry.size.width*0.8, height: geometry.size.height*0.05, alignment: .trailing)
//                                    .padding(.horizontal, 10)
//
//                                    Spacer()
//                                }
//                                .frame(height: geometry.size.height*0.09)
//                            }
//
//                            Spacer()
//                        }
//                    }
//                    .frame(width: geometry.size.width*0.9,
//                           height: self.showSteps ? CGFloat(self.calculation.stepsExpressions.count)*geometry.size.height*0.09 + geometry.size.height*0.1 : geometry.size.height*0.1,
//                           alignment: .center)
//                }
//                .padding(.vertical, 5)
//                .padding(.bottom, geometry.size.height*0.2)
                
                // END STEPS VIEW
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(trailing: !inSheet ? AnyView(MenuX()) : AnyView(Button(action: {
                    sourcePresentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                })
            )
        }
    }
    
    func updateCalculations(calculation: Calculation) {
        
        var index = 0
        while index < self.calc.calculations.count {
            
            if self.calc.calculations[index].uuid == calculation.uuid {
                
                self.calc.calculations[index] = calculation
                break
            }
            index += 1
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.calc.calculations) {
            UserDefaults.standard.set(encoded, forKey: "recentCalculations")
        }
        
        index = 0
        while index < self.calc.savedCalculations.count {
            
            if self.calc.savedCalculations[index].uuid == calculation.uuid {
                
                self.calc.savedCalculations[index] = calculation
                break
            }
            index += 1
        }
        if let encoded = try? encoder.encode(self.calc.savedCalculations) {
            UserDefaults.standard.set(encoded, forKey: "savedCalculations")
        }
    }
}
