//
//  SettingsView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI
import CoreAudio

struct SettingsView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @StateObject var storeManager: StoreManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
    
        GeometryReader { geometry in
                
            List {
                
                Section(header:
                    Text("Interface")
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
//                    SettingsLink(destination: ThemeView(storeManager: storeManager),
//                                 title: "Theme",
//                                 extra: AnyView(HStack {
//                                            Image(systemName: "square.fill")
//                                                .foregroundColor(color(settings.theme.color1))
//                                            Image(systemName: "square.fill")
//                                                .foregroundColor(color(settings.theme.color2))
//                                            Image(systemName: "square.fill")
//                                                .foregroundColor(color(settings.theme.color3))
//                                        })
//                    )
                    
                    SettingsPicker(value: self.$settings.textWeight,
                                   title: "Text Font Weight",
                                   displayOptions: ["l.square","m.square","b.square"]
                                )
                    SettingsPicker(value: self.$settings.buttonWeight,
                                   title: "Button Font Weight",
                                   displayOptions: ["l.square","m.square","b.square"]
                                )
                    SettingsToggle(toggle: self.$settings.layoutExpanded,
                                   title: "Expanded Portrait Layout"
                                )
                    // Placeholder: Shrink limit
                    SettingsToggle(toggle: self.$settings.smartDegRad,
                                   title: "Smart DEG/RAD Button"
                                )
                }
                
                Section(header:
                    Text("Content")
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    SettingsBoolPicker(value: self.$settings.displayX10,
                                       title: "Exponential Notation",
                                       displayOptions: ["   E   ","×10^"]
                    )
                    SettingsToggle(toggle: self.$settings.autoParFunction,
                                   title: "Auto Parentheses After Trig/Logs"
                                )
                    SettingsToggle(toggle: self.$settings.commaSeparators,
                                   title: "Thousands Separators"
                                )
                    SettingsToggle(toggle: self.$settings.spaceSeparators,
                                   title: "Thousands Spaces"
                                )
                    SettingsToggle(toggle: self.$settings.commaDecimal,
                                   title: "Comma Decimal Point"
                                )
                    SettingsToggle(toggle: self.$settings.degreeSymbol,
                                   title: "Trig Function Degrees Symbol"
                                )
                }
                
                Section(header:
                    Text("Results")
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    SettingsPicker(value: self.$settings.roundPlaces,
                                   title: "Round Places",
                                   displayOptions: ["5.circle","6.circle","7.circle","8.circle","9.circle","10.circle"],
                                   offset: 5
                                )
                    SettingsToggle(toggle: self.$settings.displayAltResults,
                                   title: "Show Alternate Results"
                                )
                    if self.settings.displayAltResults {
                        SettingsToggle(toggle: self.$settings.displayAllAltResults,
                                       title: "Show All Alternate Results"
                                    )
                    }
                }
                
                Section(header:
                    Text("Past Calculations")
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    SettingsPicker(value: self.$settings.recentCalcCount,
                                   title: "Recent Calculation Storage Limit",
                                   displayOptions: ["10.circle","20.circle","30.circle","40.circle","50.circle"],
                                   offset: 10,
                                   increment: 10
                                )
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .navigationBarTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
        .accentColor(color(self.settings.theme.color1))
    }
}


