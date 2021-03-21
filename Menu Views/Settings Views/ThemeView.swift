//
//  ThemeView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if geometry.size.height > geometry.size.width {
                ThemeViewA()
            }
            else {
                ThemeViewB()
            }
        }
        .navigationBarTitle("Themes")
    }
}

struct ThemeViewA: View {
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
        
                ForEach(self.uiData.themes, id: \.id) { category in
                    
                    ZStack {
                        
                        Rectangle()
                            .frame(width: geometry.size.width*0.95)
                            .foregroundColor(Color.init(white: 0.17))
                            .cornerRadius(20)
                    
                        VStack {
                            
                            Text(category.name)
                                .font(.custom("HelveticaNeue-Bold", size: 18))
                                .lineLimit(0)
                                .minimumScaleFactor(0.7)
                                .foregroundColor(Color.init(white: 0.8))
                            
                            HStack {
                            
                                ForEach(category.themes, id: \.id) { theme in
                                    
                                    Button(action: {
                                    
                                        self.settings.theme = theme
            
                                        let encoder = JSONEncoder()
                                        if let encoded = try? encoder.encode(self.settings.theme) {
                                            UserDefaults.standard.set(encoded, forKey: "theme")
                                        }
                                        
                                        if UIApplication.shared.supportsAlternateIcons {
                                            UIApplication.shared.setAlternateIconName(theme.name) { error in
                                                if let error = error {
                                                    print(error.localizedDescription)
                                                } else {
                                                    print("App Icon changed to \(theme.name)!")
                                                }
                                            }
                                        }
            
                                    }) {
                                        VStack {
            
                                            ThemeIcon(theme: theme, size: geometry.size.width*0.2, selected: self.settings.theme.id == theme.id)
            
                                            Text(theme.name.contains("Random") ? "Random" : theme.name)
                                                .font(.custom("HelveticaNeue", size: 16))
                                                .lineLimit(0)
                                                .minimumScaleFactor(0.7)
                                                .foregroundColor(Color.init(white: 0.7))
                                                .frame(width: geometry.size.width*0.2, alignment: .center)
                                        }
                                        .frame(width: geometry.size.width*0.2)
                                        .padding(.horizontal, geometry.size.width*0.01)
                                    }
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width*0.95, height: geometry.size.width*0.4)
                    .padding(.vertical, geometry.size.height*0.005)
                    .padding(.horizontal, geometry.size.width*0.025)
                }
                .padding(.bottom, geometry.size.height*0.1)
            }
        }
    }
}

struct ThemeViewB: View {
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                HStack(spacing:0) {
                
                    VStack {
            
                        ForEach(self.getThemes(column: 0), id: \.id) { category in
                            
                            ZStack {
                                
                                Rectangle()
                                    .frame(width: geometry.size.width*0.48)
                                    .foregroundColor(Color.init(white: 0.17))
                                    .cornerRadius(20)
                            
                                VStack {
                                    
                                    Text(category.name)
                                        .font(.custom("HelveticaNeue-Bold", size: 18))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.7)
                                        .foregroundColor(Color.init(white: 0.8))
                                    
                                    HStack {
                                    
                                        ForEach(category.themes, id: \.id) { theme in
                                            
                                            Button(action: {
                                            
                                                self.settings.theme = theme
                    
                                                let encoder = JSONEncoder()
                                                if let encoded = try? encoder.encode(self.settings.theme) {
                                                    UserDefaults.standard.set(encoded, forKey: "theme")
                                                }
                                                
                                                if UIApplication.shared.supportsAlternateIcons {
                                                    UIApplication.shared.setAlternateIconName(theme.name) { error in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        } else {
                                                            print("App Icon changed to \(theme.name)!")
                                                        }
                                                    }
                                                }
                    
                                            }) {
                                                VStack {
                    
                                                    ThemeIcon(theme: theme, size: geometry.size.width*0.1, selected: self.settings.theme.id == theme.id)
                    
                                                    Text(theme.name.contains("Random") ? "Random" : theme.name)
                                                        .font(.custom("HelveticaNeue", size: 16))
                                                        .lineLimit(0)
                                                        .minimumScaleFactor(0.7)
                                                        .foregroundColor(Color.init(white: 0.7))
                                                        .frame(width: geometry.size.width*0.1, alignment: .center)
                                                }
                                                .frame(width: geometry.size.width*0.1)
                                                .padding(.horizontal, geometry.size.width*0.005)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: geometry.size.width*0.5, height: geometry.size.width*0.2)
                            .padding(.vertical, geometry.size.height*0.005)
                        }
                    }
                    .padding(.bottom, geometry.size.height*0.1)
                    
                    VStack {
            
                        ForEach(self.getThemes(column: 1), id: \.id) { category in
                            
                            ZStack {
                                
                                Rectangle()
                                    .frame(width: geometry.size.width*0.48)
                                    .foregroundColor(Color.init(white: 0.17))
                                    .cornerRadius(20)
                            
                                VStack {
                                    
                                    Text(category.name)
                                        .font(.custom("HelveticaNeue-Bold", size: 18))
                                        .lineLimit(0)
                                        .minimumScaleFactor(0.7)
                                        .foregroundColor(Color.init(white: 0.8))
                                    
                                    HStack {
                                    
                                        ForEach(category.themes, id: \.id) { theme in
                                            
                                            Button(action: {
                                            
                                                self.settings.theme = theme
                    
                                                let encoder = JSONEncoder()
                                                if let encoded = try? encoder.encode(self.settings.theme) {
                                                    UserDefaults.standard.set(encoded, forKey: "theme")
                                                }
                                                
                                                if UIApplication.shared.supportsAlternateIcons {
                                                    UIApplication.shared.setAlternateIconName(theme.name) { error in
                                                        if let error = error {
                                                            print(error.localizedDescription)
                                                        } else {
                                                            print("App Icon changed to \(theme.name)!")
                                                        }
                                                    }
                                                }
                    
                                            }) {
                                                VStack {
                    
                                                    ThemeIcon(theme: theme, size: geometry.size.width*0.1, selected: self.settings.theme.id == theme.id)
                    
                                                    Text(theme.name.contains("Random") ? "Random" : theme.name)
                                                        .font(.custom("HelveticaNeue", size: 16))
                                                        .lineLimit(0)
                                                        .minimumScaleFactor(0.7)
                                                        .foregroundColor(Color.init(white: 0.7))
                                                        .frame(width: geometry.size.width*0.1, alignment: .center)
                                                }
                                                .frame(width: geometry.size.width*0.1)
                                                .padding(.horizontal, geometry.size.width*0.005)
                                            }
                                        }
                                    }
                                }
                            }
                            .frame(width: geometry.size.width*0.5, height: geometry.size.width*0.2)
                            .padding(.vertical, geometry.size.height*0.005)
                        }
                    }
                    .padding(.bottom, geometry.size.height*0.1)
                }
            }
        }
    }
    
    func getThemes(column: Int) -> [ThemeCategory] {
        
        var columnThemes = [ThemeCategory]()
        
        for theme in uiData.themes {
            if theme.id % 2 == column {
                columnThemes += [theme]
            }
        }
        return columnThemes
    }
}
