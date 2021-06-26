//
//  ThemeUnlockView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/22/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import StoreKit

struct ThemeUnlockView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var themeData = ThemeData.data
    var uiData = UIData.uiData
    
    @StateObject var storeManager: StoreManager
    
    var body: some View {
            
        NavigationView {
            
            ScrollView {
                
                VStack {
                    
                    ForEach(reorderProducts(storeManager.myProducts), id: \.self) { product in
                        
                        HStack {
                            
                            Image("Omega_\(getThemeSetName(product.localizedTitle).replacingOccurrences(of:" ",with:""))")
                                .resizable()
                                .frame(width: 90, height: 90)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.init(white: 0.4), lineWidth: 5)
                                )
                                .cornerRadius(10)
                                .padding(7.5)
                            
                            VStack(alignment: .leading) {
                                
                                Text(getThemeSetName(product.localizedTitle))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text("Theme Set")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if !themeData.locked(getFirstTheme(setName: getThemeSetName(product.localizedTitle))) {
                                HStack {
                                    Text("Unlocked")
                                    Image(systemName: "checkmark")
                                }
                                .font(.title3)
                                .foregroundColor(.gray)
                            }
                            else {
                                Button {
                                    storeManager.purchaseProduct(product: product)
                                    print("Buying \(product.localizedTitle)")
                                } label: {
                                    VStack {
                                        Text("BUY")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .lineLimit(0)
                                            .minimumScaleFactor(0.5)
                                        Text("$\(product.price)")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                            .lineLimit(0)
                                            .minimumScaleFactor(0.5)
                                    }
                                    .frame(width: 80, height: 80)
                                    .background(Color.init(white: 0.3))
                                    .cornerRadius(15)
                                    .padding(.horizontal, 10)
                                }
                            }
                        }
                        .cornerRadius(10)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("Unlock Themes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: {
                    storeManager.restoreProducts()
                }) {
                    Text("Restore")
                },
                trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
            )
        }
    }
    
    func reorderProducts(_ products: [SKProduct]) -> [SKProduct] {
        return [products[3],products[4],products[5],products[0],products[2],products[1]]
    }
    
    func getThemeSetName(_ fullName: String) -> String {
        var name = ""
        let exp = Expression.expression
        var index = exp.stringCharIndex(string: fullName, character: "\"", position: "first") + 1
        while exp.stringCharGet(string: fullName, index: index) != "\"" {
            name += String(exp.stringCharGet(string: fullName, index: index))
            index += 1
        }
        return name
    }
    
    func getFirstTheme(setName: String) -> Theme {
        for category in uiData.themes {
            if category.name == setName {
                return category.themes[0]
            }
        }
        return Theme(id: 0, name: "Test", category: "none", color1: [0,0,0], color2: [0,0,0], color3: [0,0,0], color4: [0,0,0], gray: 0.0)
    }
}
