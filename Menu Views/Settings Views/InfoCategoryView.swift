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
                
                VStack {
                    
                    Spacer()
                        .frame(height: 10)
                        
                    Text(category.desc)
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.92, alignment: .leading)
                        .padding(10)
                        
                    ForEach(category.info, id: \.id) { info in
                            
                        ZStack {
                            
                            Rectangle()
                                .foregroundColor(Color.init(white: 0.15))
                                .cornerRadius(20)
                        
                            VStack(alignment: .leading, spacing: 0) {
                            
                                HStack {
                                    
                                    ButtonView(button: info.name, backgroundColor: color(self.information.buttonColor(buttonType: info.buttonType)), width: 70, height: 70, fontSize: 36, displayNext: false)
                                        .padding(.trailing, 5)
                                    
                                    VStack(alignment: .leading) {
                                        
                                        Text(info.fullName)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .font(.title)
                                        
                                        Text(info.description)
                                            .fixedSize(horizontal: false, vertical: true)
                                            .foregroundColor(Color.init(white:0.6))
                                            .font(.subheadline)
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
                .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.96 )
                .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.02)
            }
        }
        .navigationBarTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
    }
}


