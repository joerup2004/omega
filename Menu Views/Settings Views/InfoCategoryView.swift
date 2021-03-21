//
//  InfoCategoryView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 10/1/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import SwiftUI

struct InfoCategoryView: View {
    
    var information = Information.information
    
    var category: InfoCategory
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                Spacer()
                    .frame(height: 10)
                
                VStack(alignment: .leading) {
                    Text("Button Guide: \(category.name)")
                        .font(.custom("HelveticaNeue-Bold", size: 24))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                    
                    Text(category.desc)
                        .font(.custom("HelveticaNeue", size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                        .padding(.top, -12)
                    
                    Spacer()
                        .frame(width: geometry.size.width)
                }
                    
                ForEach(category.info, id: \.id) { info in
                        
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(Color.init(white: 0.1))
                            .cornerRadius(20)
                    
                        VStack(alignment: .leading, spacing: 0) {
                        
                            HStack {
                                
                                ButtonView(button: info.name, backgroundColor: color(self.information.buttonColor(buttonType: info.buttonType)), width: 70, height: 70, fontSize: 36, displayNext: false)
                                    .padding(.trailing, 5)
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(info.fullName)
                                        .font(.custom("HelveticaNeue", size: 40))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                    
                                    Text(info.description)
                                        .font(.custom("HelveticaNeue", size: 16))
                                        .foregroundColor(Color.init(white:0.6))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                }
                                
                                Spacer()
                            }
                            .padding(.bottom, 5)
                            
                            HStack(spacing:0) {
                                info.example1Q
                                info.example1A
                            }
                            .padding(.bottom, 5)
                            HStack(spacing:0) {
                                info.example2Q
                                info.example2A
                            }
                            .padding(.bottom, 5)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    }
                }
            }
            .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98 )
            .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.01)
        }
        .navigationBarTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


