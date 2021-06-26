//
//  InformationView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 9/30/20.
//  Copyright © 2020 Rupertus. All rights reserved.
//

import SwiftUI

struct InformationView: View {
    
    var settings = Settings.settings
    @State var information = Information.information
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack {
            
                    Spacer()
                        .frame(height: 10)
                    
                    VStack(alignment: .leading) {
                    
                        Text("How to Use Omega Calculator")
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                        
                        Text("Use Omega Calculator as you would use any other calculator. Press the buttons to input an expression and the equals button to calculate a result.")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                    
                        NavigationLink(destination: InfoGeneralView()) {
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color.init(white: 0.15))
                                    .cornerRadius(20)
                                
                                HStack {
                                    
                                    Text("General Info & Tips")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color.white)
                                        .padding(.leading, 20)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(Color.init(red: 150/255, green: 150/255, blue: 150/255))
                                        .padding(.trailing, 20)
                                }
                                .frame(height: 80)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        Text("Button Guides")
                            .font(.headline)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.init(white: 0.6))
                            .padding(.horizontal, 10)
                    }
                    
                    ForEach(self.information.info, id: \.id) { category in
                        
                        NavigationLink(destination: InfoCategoryView(category: category)) {
                            
                            ZStack {
                                
                                Rectangle()
                                    .foregroundColor(Color.init(white: 0.15))
                                    .cornerRadius(20)
                                
                                VStack {
                                    
                                    HStack {
                                        
                                        HStack(spacing:0) {
                                            VStack(spacing:0) {
                                                ButtonView(button: category.info[category.displayedInfo[0]].name, backgroundColor: color(self.information.buttonColor(buttonType: category.info[category.displayedInfo[0]].buttonType)), width: 30, height: 30, fontSize: 16, displayNext: false, active: false)
                                                    .padding(.all,1)
                                                ButtonView(button: category.info[category.displayedInfo[2]].name, backgroundColor: color(self.information.buttonColor(buttonType: category.info[category.displayedInfo[2]].buttonType)), width: 30, height: 30, fontSize: 16, displayNext: false, active: false)
                                                    .padding(.all,1)
                                            }
                                            VStack(spacing:0) {
                                                ButtonView(button: category.info[category.displayedInfo[1]].name, backgroundColor: color(self.information.buttonColor(buttonType: category.info[category.displayedInfo[1]].buttonType)), width: 30, height: 30, fontSize: 16, displayNext: false, active: false)
                                                    .padding(.all,1)
                                                ButtonView(button: category.info[category.displayedInfo[3]].name, backgroundColor: color(self.information.buttonColor(buttonType: category.info[category.displayedInfo[3]].buttonType)), width: 30, height: 30, fontSize: 16, displayNext: false, active: false)
                                                    .padding(.all,1)
                                            }
                                        }
                                        .padding(.leading, 5)
                                        .padding(.trailing, 10)
                                    
                                        Text(category.name)
                                            .font(.title2)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.white)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(Color.init(red: 150/255, green: 150/255, blue: 150/255))
                                            .padding(.trailing, 20)
                                        
                                    }
                                    .padding(.vertical, 10)
                                }
                                .padding(.horizontal, geometry.size.width*0.01)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: geometry.size.height*0.1)
                }
                .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.96 )
                .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.02)
            }
        }
        .navigationBarTitle("Guide")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
