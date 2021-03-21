//
//  ThemeIcon.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeIcon: View {
    
    var theme: Theme
    var size: CGFloat
    var selected: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Rectangle()
                    .frame(width: geometry.size.height, height: geometry.size.height, alignment: .center)
                    .foregroundColor(Color.init(white: self.selected ? 0.7 : 0.25))
                    .cornerRadius(10)
        
                Rectangle()
                    .frame(width: geometry.size.height*0.95, height: geometry.size.height*0.95, alignment: .center)
                    .foregroundColor(Color.init(white: 0.15))
                    .cornerRadius(10)
                
                Rectangle()
                    .frame(width: geometry.size.height*0.57, height: geometry.size.height*0.57, alignment: .center)
                    .foregroundColor(color(self.theme.color1))
                    .cornerRadius(6)
                    .padding(.top, geometry.size.height*0.42)
                    .padding(.bottom, geometry.size.height*0.15)
                    .padding(.leading, geometry.size.height*0.15)
                    .padding(.trailing, geometry.size.height*0.42)
                
                Rectangle()
                    .frame(width: geometry.size.height*0.2, height: geometry.size.height*0.57, alignment: .center)
                    .foregroundColor(color(self.theme.color2))
                    .cornerRadius(5)
                    .padding(.top, geometry.size.height*0.42)
                    .padding(.bottom, geometry.size.height*0.15)
                    .padding(.leading, geometry.size.height*0.8)
                    .padding(.trailing, geometry.size.height*0.15)
                
                Rectangle()
                    .frame(width: geometry.size.height*0.85, height: geometry.size.height*0.21, alignment: .center)
                    .foregroundColor(color(self.theme.color3))
                    .cornerRadius(5)
                    .padding(.top, geometry.size.height*0.15)
                    .padding(.bottom, geometry.size.height*0.8)
                    .padding(.leading, geometry.size.height*0.15)
                    .padding(.trailing, geometry.size.height*0.15)
                
            }
            .frame(width: self.size, height: self.size, alignment: .center)
        }
        .frame(width: self.size, height: self.size, alignment: .center)
    }
}
