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
    var width: CGFloat
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .frame(width: width*0.9+2, height: 102, alignment: .center)
                .foregroundColor(color([100,100,100]))
                .cornerRadius(20)
            
            Rectangle()
                .frame(width: width*0.9, height: 100, alignment: .center)
                .foregroundColor(color([30,30,30]))
                .cornerRadius(20)
            
            HStack(spacing: 0) {
                    
                Image(systemName: self.image)
                    .frame(width: self.width*0.15, height: 100, alignment: .center)
                    .foregroundColor(self.themeColor)
                    .font(.system(size: 40))
                    .minimumScaleFactor(0.8)
                    .padding(.leading, 10)
                
                Text(self.text)
                    .frame(width: self.width*0.55, height: 100, alignment: .leading)
                    .foregroundColor(color([200,200,200]))
                    .font(.custom("HelveticaNeue", size: 36))
                    .padding(.leading, self.width*0.05)
                    .lineLimit(0)
                    .minimumScaleFactor(0.5)
                
                Spacer()
            }
            .frame(width: width*0.9+2, height: 102, alignment: .center)
        }
        .padding(.horizontal,width*0.05-1)
    }
}
