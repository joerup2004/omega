//
//  CalculationListView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct CalculationListView: View {
    
    @ObservedObject var calc = Calculations.calc
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showClearAlert = false
    
    @State var list = 0
    
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
                        
                                CalculationRowView(calculation: calculation, saved: false, width: geometry.size.width > 800 ? CGFloat(800) : geometry.size.width*0.98)
                                    .listRowInsets(EdgeInsets())
                                
                            }
                            .animation(.easeInOut)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    self.showClearAlert = true
                                }) {
                                    ZStack {
                                        
                                        Rectangle()
                                            .frame(width: geometry.size.width*0.2, height: 25, alignment: .center)
                                            .foregroundColor(Color.init(white: 0.2))
                                            .cornerRadius(10)
                                        
                                        Text("Clear All")
                                            .foregroundColor(.white)
                                            .font(.custom("HelveticaNeue-Bold", size: 16))
                                    }
                                }
                                .alert(isPresented: self.$showClearAlert) {
                                    Alert(title: Text("Are you sure?"), message: Text("Clear all recent calculations"), primaryButton: .destructive(Text("Clear")) {
                                            self.calc.calculations = []
                                    }, secondaryButton: .cancel())
                                }
                                Spacer()
                            }
                            .animation(.easeInOut)
                        }
                        else if self.list == 1 && !self.calc.savedCalculations.isEmpty {
                        
                            ForEach(self.calc.savedCalculations.reversed(), id: \.saveID) { calculation in
                                
                                CalculationRowView(calculation: calculation, saved: true, width: geometry.size.width > 800 ? CGFloat(800) : geometry.size.width*0.98)
                                    .listRowInsets(EdgeInsets())
                                
                            }
                            .animation(.easeInOut)
                        }
                        
                        Spacer()
                    }
                    .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98 )
                    .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.01)
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
            }
            .id(UUID())
            .navigationBarTitle("Calculations")
            .onAppear { UITableView.appearance().separatorStyle = .none }
        }
    }
}
