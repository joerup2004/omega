//
//  CalculationListView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import Foundation

struct CalculationListView: View {
    
    @ObservedObject var calc = Calculations.calc
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var list = 0
    
    var inSheet: Bool = false
    var sourcePresentationMode: Binding<PresentationMode>
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
            
                HStack {
                    
                    Spacer()
                    
                    Button(action: {
                        self.list = 0
                    }) {
                        ZStack {
                            
                            Rectangle()
                                .frame(width: geometry.size.width*0.2, height: 25, alignment: .center)
                                .foregroundColor(Color.init(white: self.list == 0 ? 0.4 : 0.2))
                                .cornerRadius(10)
                            
                            Text("Recent")
                                .foregroundColor(.white)
                                .font(.custom("HelveticaNeue-Bold", size: 16))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.list = 1
                    }) {
                        ZStack {
                            
                            Rectangle()
                                .frame(width: geometry.size.width*0.2, height: 25, alignment: .center)
                                .foregroundColor(Color.init(white: self.list == 1 ? 0.4 : 0.2))
                                .cornerRadius(10)
                            
                            Text("Saved")
                                .foregroundColor(.white)
                                .font(.custom("HelveticaNeue-Bold", size: 16))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                    
                if (self.list == 0 && !self.calc.calculations.isEmpty) || (self.list == 1 && !self.calc.savedCalculations.isEmpty) {
                    
                    List {
                        
                        if self.list == 0 && !self.calc.calculations.isEmpty {
                                
                            ForEach(self.calc.calculations.reversed(), id: \.id) { calculation in
                        
                                CalculationRowView(calculation: calculation, saved: false, inSheet: inSheet, sourcePresentationMode: sourcePresentationMode)
                                    .frame(height: 90)
                            }
                            .onDelete(perform: self.deleteCalcFromList)
                        }
                        else if self.list == 1 && !self.calc.savedCalculations.isEmpty {
                        
                            ForEach(self.calc.savedCalculations.reversed(), id: \.saveID) { calculation in
                                
                                CalculationRowView(calculation: calculation, saved: true, inSheet: inSheet, sourcePresentationMode: sourcePresentationMode)
                                    .frame(height: 90)
                            }
                            .onDelete(perform: self.deleteCalcFromSavedList)
                        }
                    }
                    .listStyle(DefaultListStyle())
                }
                else {
                    
                    HStack {
                        
                        Spacer()
                    
                        Text("None")
                            .foregroundColor(Color.init(white: 0.7))
                            .font(.system(size: 20))
                        
                        Spacer()
                    }
                    .padding(.top, 50)
                }
                
                Spacer()
            }
            .id(UUID())
            .navigationBarTitle("Past Calculations")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func deleteCalcFromList(at offset: IndexSet) {
        let deleteIndexes = offset.map { self.calc.calculations[$0].id }
        for index in deleteIndexes {
            let indexToDelete = self.calc.calculations.count - 1 - index
            self.calc.deleteCalculation(calculation: self.calc.calculations[indexToDelete])
        }
    }
    
    func deleteCalcFromSavedList(at offset: IndexSet) {
        let deleteIndexes = offset.map { self.calc.savedCalculations[$0].saveID }
        for index in deleteIndexes {
            let indexToDelete = self.calc.savedCalculations.count - 1 - index
            self.calc.deleteCalculation(calculation: self.calc.savedCalculations[indexToDelete])
        }
    }
}
