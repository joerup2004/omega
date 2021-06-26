//
//  ThemeView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/25/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct ThemeView: View {
    
    @State var unlock: Bool = false
    
    @StateObject var storeManager: StoreManager
    
    var uiData = UIData.uiData
    
    var body: some View {
        
        GeometryReader { geometry in
            
            if geometry.size.height > geometry.size.width {
                ThemeViewA(unlock: self.$unlock)
            }
            else {
                ThemeViewB(unlock: self.$unlock)
            }
        }
        .navigationBarTitle("Themes")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
        .sheet(isPresented: self.$unlock) {
            ThemeUnlockView(storeManager: storeManager)
        }
    }
}

struct ThemeViewA: View {
    
    @ObservedObject var settings = Settings.settings
    var themeData = ThemeData.data
    var uiData = UIData.uiData
    
    @Binding var unlock: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                Button {
                    self.unlock.toggle()
                } label: {
                    Text("Unlock")
                        .font(.headline)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
        
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
                                        if !themeData.locked(theme) {
                                            themeData.setTheme(theme)
                                        }
                                        else {
                                            self.unlock.toggle()
                                        }
                                    }) {
                                        VStack {
                                                
                                            ThemeIcon(theme: theme, size: geometry.size.width*0.2, locked: themeData.locked(theme), selected: self.settings.theme.name == theme.name)
                                                
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
            }
        }
    }
}

struct ThemeViewB: View {
    
    @ObservedObject var settings = Settings.settings
    var themeData = ThemeData.data
    var uiData = UIData.uiData
    
    @Binding var unlock: Bool
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                Button {
                    self.unlock.toggle()
                } label: {
                    Text("Unlock")
                        .font(.headline)
                }
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                HStack(spacing:0) {
                
                    VStack {
            
                        ForEach(themeData.getThemes(column: 0), id: \.id) { category in
                            
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
                                                if !themeData.locked(theme) {
                                                    themeData.setTheme(theme)
                                                }
                                                else {
                                                    self.unlock.toggle()
                                                }
                                            }) {
                                                VStack {
                                                    
                                                    ThemeIcon(theme: theme, size: geometry.size.width*0.1, locked: themeData.locked(theme), selected: self.settings.theme.name == theme.name)
                    
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
            
                        ForEach(themeData.getThemes(column: 1), id: \.id) { category in

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
                                                if !themeData.locked(theme) {
                                                    themeData.setTheme(theme)
                                                }
                                                else {
                                                    self.unlock.toggle()
                                                }
                                            }) {
                                                VStack {

                                                    ThemeIcon(theme: theme, size: geometry.size.width*0.1, locked: themeData.locked(theme), selected: self.settings.theme.name == theme.name)

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
}

class ThemeData {
    
    public static let data = ThemeData()
    
    @ObservedObject var settings = Settings.settings
    var uiData = UIData.uiData
    
    func getThemes(column: Int) -> [ThemeCategory] {
        
        var columnThemes = [ThemeCategory]()
        
        for theme in uiData.themes {
            if theme.id % 2 == column {
                columnThemes += [theme]
            }
        }
        return columnThemes
    }
    
    func setTheme(_ theme: Theme) {
        
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
    }
    
    func locked(_ theme: Theme) -> Bool {
        
        let unlockedCategories = ["Basic","Colorful"]
        
        return !UserDefaults.standard.bool(forKey: "com.rupertusapps.OmegaCalc.Theme\(theme.category.replacingOccurrences(of:"The ",with:""))") && !unlockedCategories.contains(theme.category)
    }
}
