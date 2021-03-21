//
//  SettingsSubRounding.swift
//  Calculator
//
//  Created by Joe Rupertus on 7/30/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsSubRounding: View {
    
    @ObservedObject var settings = Settings.settings
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("All results are rounded to this number of places")
                    .frame(alignment: .leading)
                    .font(.custom("HelveticaNeue", size: 20))
                    .foregroundColor(Color.init(white: 0.6))
                    .minimumScaleFactor(0.5)
                    .padding(.all, 15)
                
                Spacer()
            }
        
            List {
                
                ForEach(5..<11) { num in
                    
                    Button(action: {
                        self.settings.roundPlaces = num
                    }) {
                        HStack {
                            
                            Text(String(num))
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            
                            Spacer()
                            
                            if self.settings.roundPlaces == num {
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
        .navigationBarTitle("Rounding Places")
    }
}
