//
//  AboutView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 3/11/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    
    var settings = Settings.settings
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack(alignment: .center) {
                    
                    if geometry.size.height > geometry.size.width {
                        VStack(spacing:0) {
                            Image("Omega_\(self.settings.theme.name.replacingOccurrences(of:" ",with:"_"))")
                                .resizable()
                                .frame(width: geometry.size.width > 800 ? 150 : geometry.size.width*0.4, height: geometry.size.width > 800 ? 150 : geometry.size.width*0.4, alignment: .center)
                                .cornerRadius(20)
                                .padding(.top, 30)
                            
                            Text("Omega Calculator")
                                .font(.custom("HelveticaNeue", size: geometry.size.width*0.15))
                                .padding(.horizontal, geometry.size.width*0.05)
                                .lineLimit(0)
                                .minimumScaleFactor(0.00001)
                                .padding(.vertical, 10)
                        }
                    }
                    else {
                        HStack {
                            Image("Omega_\(self.settings.theme.name.replacingOccurrences(of:" ",with:"_"))")
                                .resizable()
                                .frame(width: geometry.size.width > 800 ? 150 : geometry.size.width*0.15, height: geometry.size.width > 800 ? 150 : geometry.size.width*0.15, alignment: .center)
                                .cornerRadius(20)
                            
                            Text("Omega Calculator")
                                .font(.custom("HelveticaNeue", size: 100))
                                .frame(width: geometry.size.width > 800 ? 400 : geometry.size.width*0.40)
                                .padding(.leading, geometry.size.width*0.01)
                                .lineLimit(0)
                                .minimumScaleFactor(0.00001)
                        }
                        .padding(.horizontal, geometry.size.width*0.1)
                        .padding(.bottom, 10)
                        .padding(.top, 30)
                    }
                    
                    Text("Omega Calculator is an intuitive and powerful calculator that can be used for any mathematical computation you need to perform. The calculator includes basic operations, exponents, roots, fractions, logarithms, trig functions, probability, and much more. With Omega’s innovative approach to input complex expressions, performing a multitude of tasks is easily possible. You can view and save your past calculations for future use, as well as customize your experience with display settings and over 30 color themes to choose from. Get started with Omega for free today!")
                        .font(.custom("HelveticaNeue", size: 18))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    Text("To get help or support, please visit Omega's website:")
                        .font(.custom("HelveticaNeue", size: 18))
                        .foregroundColor(color([250,250,250]))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                    Link("Omega Calculator Website", destination: URL(string: "https://joerup2004.github.io/omega/")!)
                        .font(.custom("HelveticaNeue-Bold", size: 24))
                        .padding(.horizontal, 10)
                        .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
