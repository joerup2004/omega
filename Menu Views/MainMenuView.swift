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
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
        
            NavigationView {

                List {

                    Section {
                        Button {
                            withAnimation {
                                self.settings.calculatorType = "regular"
                                self.settings.showMenu = false
                            }
                        } label: {
                            MainMenuRowView(text: "Calculator", image: "divide.circle", themeColor: color(self.settings.theme.color1))
                        }
//                        Button {
//                            withAnimation {
//                                self.settings.calculatorType = "equation"
//                                self.settings.showMenu = false
//                            }
//                        } label: {
//                            MainMenuRowView(text: "Equation", image: "equal.circle", themeColor: color(self.settings.theme.color1))
//                        }
//                        Button {
//                            withAnimation {
//                                self.settings.calculatorType = "currency"
//                                self.settings.showMenu = false
//                            }
//                        } label: {
//                            MainMenuRowView(text: "Currency", image: "dollarsign.circle", themeColor: color(self.settings.theme.color1))
//                        }
                    }

                    Section {
                        NavigationLink(destination: CalculationListView(sourcePresentationMode: presentationMode).navigationBarItems(trailing: MenuX())) {
                            MainMenuRowView(text: "Past Calculations", image: "number.circle", themeColor: color(self.settings.theme.color2))
                        }
                    }

                    Section {
                        NavigationLink(destination: ThemeView(storeManager: storeManager)) {
                            MainMenuRowView(text: "Theme", image: "paintpalette", themeColor: color(self.settings.theme.color3))
                        }
                        NavigationLink(destination: SettingsView(storeManager: storeManager)) {
                            MainMenuRowView(text: "Settings", image: "gear", themeColor: color(self.settings.theme.color3))
                        }
                    }

                    Section {
//                        NavigationLink(destination: EmptyView()) {
//                            MainMenuRowView(text: "PROmega Calculator", image: "giftcard", themeColor: color(self.settings.theme.color3))
//                        }
                        Link(destination: URL(string: "https://www.buymeacoffee.com/joerup2004")!) {
                            NavigationLink(destination: EmptyView()) {
                                MainMenuRowView(text: "Buy me a Coffee", image: "bag", themeColor: color(self.settings.theme.color1))
                            }
                        }
                    }

                    Section {
                        NavigationLink(destination: InformationView()) {
                            MainMenuRowView(text: "Guide", image: "info", themeColor: color(self.settings.theme.color2))
                        }
                        NavigationLink(destination: AboutView()) {
                            MainMenuRowView(text: "About", image: "circle", themeColor: color(self.settings.theme.color2))
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarTitle("Omega")
                .navigationBarItems(trailing: MenuX())
                
                AboutView()
            }
            .phoneOnlyStackNavigationView(geometry)
            .accentColor(color(self.settings.theme.color1))
        }
    }
}

struct MenuX: View {
    
    @ObservedObject var settings = Settings.settings
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.settings.showMenu = false
                }
            }) {
                Image(systemName: "xmark.circle")
                    .imageScale(.large)
                    .foregroundColor(Color.init(red: 150/255, green: 150/255, blue: 150/255))
            }
        }
    }
}

extension View {
    func phoneOnlyStackNavigationView(_ geometry: GeometryProxy) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone || geometry.size.height >= geometry.size.width {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
