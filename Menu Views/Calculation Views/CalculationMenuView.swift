//
//  CalculationMenuView.swift
//  Calculator
//
//  Created by Joe Rupertus on 5/24/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import UIKit
import Foundation

struct CalculationMenuView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var list = 0
    
    @ViewBuilder
    var body: some View {
            
        ZStack {
        
            NavigationView {
            
                CalculationListView()
            }
            .accentColor(color(self.settings.theme.color1))
            
            GeometryReader { geometry in
                
                VStack {
                        
                    HStack {
                                     
                        Spacer()
                        
                        Button(action: {
                            self.settings.showCalculations = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .imageScale(.large)
                                .foregroundColor(Color.init(red: 150/255, green: 150/255, blue: 150/255))
                                .padding(.all, geometry.size.width > geometry.size.height ? geometry.size.height*0.03 : geometry.size.height*0.025)
                        }
                    }
                    
                    Spacer()
                }
            }
        }
    }
}
