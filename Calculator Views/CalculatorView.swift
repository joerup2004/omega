//
//  CalculatorView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/19/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct CalculatorView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @ViewBuilder var body: some View {
        
        ZStack {
        
            if self.settings.showMenu {
                
                MainMenuView(storeManager: storeManager)
                    .transition(AnyTransition.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                    .animation(.default)
                
            }
            else if self.settings.calculatorType == "regular" {
                
                GeometryReader { geometry in

                    // iPhone, Portrait Mode
                    if geometry.size.height > geometry.size.width && geometry.size.height < 1000 {

                        if !self.settings.layoutExpanded {
                            CalculatorView1()
                        }
                        else {
                            CalculatorView3A()
                        }
                    }

                    // iPhone, Landscape Mode
                    else if geometry.size.height < geometry.size.width && geometry.size.height < 500 {

                        CalculatorView2A()
                    }

                    // iPad, Portrait Mode
                    if geometry.size.height > geometry.size.width && geometry.size.height >= 1000 {
                        
                        if !self.settings.layoutExpanded {
                            CalculatorView1()
                        }
                        else {
                            CalculatorView3B()
                        }

                    }

                    // iPad, Landscape Mode
                    if geometry.size.height < geometry.size.width && geometry.size.height >= 500 {

                        CalculatorView2B()
                    }
                }
            }
            else if self.settings.calculatorType == "equation" {
                
                EquationView()
            }
            else if self.settings.calculatorType == "converter" {
                
                ConverterView()
            }
        }
    }
    
}
