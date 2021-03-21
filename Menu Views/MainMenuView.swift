//
//  MainMenuView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/4/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct MainMenuView: View {
    
    var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                    
                ScrollView {
                    
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
                    
                    Button(action: {
                        withAnimation {
                            self.settings.calculatorType = "regular"
                            self.settings.showMenu = false
                        }
                    }) {
                        MainMenuRowView(text: "Calculator", image: "candybarphone", themeColor: color(self.settings.theme.color1), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
                    }
                    .padding(.vertical, 5)
                    
                    NavigationLink(destination: CalculationListView()) {
                        
                        MainMenuRowView(text: "Calculations", image: "number", themeColor: color(self.settings.theme.color2), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
                    }
                    .padding(.vertical, 5)
                    
                    NavigationLink(destination: InformationView()) {
                        
                        MainMenuRowView(text: "Guide", image: "info", themeColor: color(self.settings.theme.color3), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
                    }
                    .padding(.vertical, 5)
                    
                    NavigationLink(destination: ThemeView()) {
                        
                        MainMenuRowView(text: "Theme", image: "paintpalette", themeColor: color(self.settings.theme.color1), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
                    }
                    .padding(.vertical, 5)
                    
                    NavigationLink(destination: SettingsView()) {
                    
                        MainMenuRowView(text: "Settings", image: "gear", themeColor: color(self.settings.theme.color2), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
                    }
                    .padding(.vertical, 5)
                    
//                    NavigationLink(destination: AboutView()) {
//
//                        MainMenuRowView(text: "About", image: "circle", themeColor: color(self.settings.theme.color3), width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98)
//                    }
//                    .padding(.vertical, 5)
                    
                    Spacer()
                    
                }
                .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.98 )
                .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.01)
            }
            .navigationBarHidden(true)
            .navigationBarTitle("Menu")
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .accentColor(color(self.settings.theme.color1))
    }
}

