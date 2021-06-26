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
            
        NavigationView {
        
            CalculationListView(inSheet: true, sourcePresentationMode: presentationMode)
                .navigationBarItems(trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundColor(.gray)
                    }
                )
        }
        .accentColor(color(self.settings.theme.color1))
    }
}
