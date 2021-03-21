//
//  SettingsSubRecCalc.swift
//  Calculator
//
//  Created by Joe Rupertus on 8/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsSubRecCalc: View {
    
    @ObservedObject var settings = Settings.settings
    
    let options = [10,20,30,40,50]
    
    var body: some View {
        
        VStack {
            
            HStack {
                    
                Text("Amount of calculations kept in Recent tab; any unsaved calculation prior to the last \(self.settings.recentCalcCount) will be deleted")
                    .frame(alignment: .leading)
                    .font(.custom("HelveticaNeue", size: 20))
                    .foregroundColor(Color.init(white: 0.6))
                    .minimumScaleFactor(0.5)
                    .padding(.all, 15)
                
                Spacer()
                
            }
        
            List {
                
                ForEach(self.options, id: \.self) { num in
                    
                    Button(action: {
                        self.settings.recentCalcCount = num
                    }) {
                        HStack {

                            Text(String(num))
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)

                            Spacer()

                            if self.settings.recentCalcCount == num {
                                Image(systemName: "checkmark")
                                    .font(.custom("HelveticaNeue", size: 20))
                                    .foregroundColor(Color.init(white: 0.8))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Recent Calculations")
    }
}
