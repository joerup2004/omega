//
//  MainMenuRowView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MainMenuRowView: View {
    
    var text: String
    var image: String
    var themeColor: Color
    
    var body: some View {
        
        HStack {
                
            Image(systemName: self.image)
                .frame(width: 40, height: 40)
                .foregroundColor(self.themeColor)
            
            Text(self.text)
                .foregroundColor(color([200,200,200]))
                .font(.headline)
                .lineLimit(0)
                .minimumScaleFactor(0.5)
                .padding(4)
        }
    }
}
