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
    
    @State var dropdown: Bool = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
            
                Spacer()
                    .frame(height: 10)
                
                VStack(alignment: .leading) {
                
                    Text("How to Use Omega Calculator")
                        .font(.custom("HelveticaNeue-Bold", size: 24))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(10)
                    
                    Text("Use Omega Calculator as you would use any other calculator. Press the buttons to input an expression and the equals button to calculate a result.")
                        .font(.custom("HelveticaNeue", size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        self.dropdown.toggle()
                    }) {
                        HStack {
                            Text("General Info & Tips")
                                .font(.custom("HelveticaNeue-Bold", size: 20))
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                            Image(systemName: self.dropdown ? "chevron.down" : "chevron.up")
                        }
                        .foregroundColor(color([150,150,150]))
                    }
                    .padding(.horizontal, 10)
                
                    if self.dropdown {
                        Text("""
                            \n• Press the clear button to remove everything from the screen.
                            \n• Press the backspace button to undo the last thing inputted.
                            \n• Press and hold a button to automatically add parentheses, or use the parentheses button.
                            \n• Use parentheses to put more than one number in an exponent, root, etc.
                            \n• For some operations, parentheses are automatically added to achieve what you're most likely trying to do.
                            \n• Press and hold the open parenthesis to put the entire expression in parentheses.
                            \n• Some items can be applied either before or after the previously imputted item; for example, you could enter either "√" + "6" or "6" + "√" to get the square root of 6.
                            \n• View past calculations by pressing the down arrow or the Calculations tab.
                            """)
                            .font(.custom("HelveticaNeue", size: 18))
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(color([200,200,200]))
                            .padding(10)
                            .padding(.bottom, 20)
                    }
                    else {
                        Text("")
                            .padding(.bottom, 20)
                    }
                    
                    Text("Button Guides")
                        .font(.custom("HelveticaNeue-Bold", size: 20))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(color([150,150,150]))
                        .padding(.horizontal, 10)
                }
                
                ForEach(self.information.info, id: \.id) { category in
                    
                    NavigationLink(destination: InfoCategoryView(category: category)) {
                        
                        ZStack {
                            
                            Rectangle()
                                .foregroundColor(Color.init(white: 0.1))
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
                                        .font(.custom("HelveticaNeue", size: 30))
                                        .foregroundColor(Color.white)
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.5)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .imageScale(.large)
                                        .foregroundColor(Color.init(red: 150/255, green: 150/255, blue: 150/255))
                                        .padding(.horizontal, 10)
                                    
                                }
                                .padding(.vertical, 10)
                            }
                            .padding(.horizontal, geometry.size.width*0.01)
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    Text("Support")
                        .font(.custom("HelveticaNeue-Bold", size: 20))
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(color([150,150,150]))
                        .padding(10)
                    
                    Text("• Get support or report an unknown error or bug here: ")
                        .font(.custom("HelveticaNeue", size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 10)
                    Link("Omega Calculator Website", destination: URL(string: "https://joerup2004.github.io/omega/")!)
                        .font(.custom("HelveticaNeue", size: 18))
                        .padding(.horizontal, 10)
                    
                    Spacer()
                        .frame(width: geometry.size.width)
                }
                .padding(.bottom, geometry.size.height*0.1)
            }
            .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98 )
            .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.01)
        }
        .navigationBarTitle("Guide")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
