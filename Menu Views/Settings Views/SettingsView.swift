//
//  SettingsView.swift
//  Calculator
//
//  Created by Joe Rupertus on 6/6/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settings = Settings.settings
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
    
        GeometryReader { geometry in
                
            List {
                
                Section(header:
                    Text("Interface")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
                    Toggle(isOn: self.$settings.layoutExpanded) {
                        VStack(alignment: .leading) {
                            Text("Expanded Layout")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Extra buttons in portrait mode")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                }
                
                Section(header:
                    Text("Results")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {

                    NavigationLink(destination: SettingsSubRounding()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Round Places")
                                    .font(.custom("HelveticaNeue", size: 20))
                                    .foregroundColor(Color.init(white: 0.8))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                                Text("All results are rounded to this number of places")
                                    .font(.custom("HelveticaNeue", size: 12))
                                    .foregroundColor(Color.init(white: 0.6))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                            }
                            Spacer()
                            Text(String(self.settings.roundPlaces))
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                                .padding(.horizontal,geometry.size.width*0.02)
                        }
                    }
                    
                    Toggle(isOn: self.$settings.displayAltResults) {
                        VStack(alignment: .leading) {
                            Text("Alternate Results")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Also give answer in other terms if relevant, such as π or fraction")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    if self.settings.displayAltResults {
                        Toggle(isOn: self.$settings.displayAllAltResults) {
                            VStack(alignment: .leading) {
                                Text("All Alternate Results")
                                    .font(.custom("HelveticaNeue", size: 20))
                                    .foregroundColor(Color.init(white: 0.8))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                                Text("Also give answer in other terms if possible, such as π or fraction")
                                    .font(.custom("HelveticaNeue", size: 12))
                                    .foregroundColor(Color.init(white: 0.6))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    }
                }
                
                Section(header:
                    Text("Buttons")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
                    Toggle(isOn: self.$settings.smartDegRad) {
                        VStack(alignment: .leading) {
                            Text("Smart Deg/Rad Button")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Will only display while trig functions are being used")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.lightBut) {
                        VStack(alignment: .leading) {
                            Text("Light Button Text")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Light Non-bolded Text for Buttons")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                }
                
                Section(header:
                    Text("Calculations")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
                    NavigationLink(destination: SettingsSubRecCalc()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Recent Calculations")
                                    .font(.custom("HelveticaNeue", size: 20))
                                    .foregroundColor(Color.init(white: 0.8))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                                Text("Amount of calculations kept in Recent tab")
                                    .font(.custom("HelveticaNeue", size: 12))
                                    .foregroundColor(Color.init(white: 0.6))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(0)
                            }
                            Spacer()
                            Text(String(self.settings.recentCalcCount))
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                                .padding(.horizontal,geometry.size.width*0.02)
                        }
                    }
                }
                    
                Section(header:
                    Text("Display")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
                    Toggle(isOn: self.$settings.animateText) {
                        VStack(alignment: .leading) {
                            Text("Text Animations")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Slide Animation When Something is Entered")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.light) {
                        VStack(alignment: .leading) {
                            Text("Light Text")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Light Non-bolded Text for Calculations")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                }
                
                Section(header:
                    Text("Content")
                        .font(.custom("HelveticaNeue-Bold", size: 18))
                        .foregroundColor(Color.init(white: 0.9))
                        .padding(.vertical, 10)
                        .textCase(nil)
                ) {
                    
                    Toggle(isOn: self.$settings.displayX10) {
                        VStack(alignment: .leading) {
                            Text("×10^ for Exponential")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Instead of \"E\"")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.autoParFunction) {
                        VStack(alignment: .leading) {
                            Text("Function Parentheses")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Add parentheses after trig functions & logarithms")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.commaSeparators) {
                        VStack(alignment: .leading) {
                            Text("Thousands Separators")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Separators between every 3 places")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.spaceSeparators) {
                        VStack(alignment: .leading) {
                            Text("Thousands Spaces")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Spaces between every 3 places")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.commaDecimal) {
                        VStack(alignment: .leading) {
                            Text("Comma Decimal Point")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Use comma to indicate decimal")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                    
                    Toggle(isOn: self.$settings.degreeSymbol) {
                        VStack(alignment: .leading) {
                            Text("Degree Symbol")
                                .font(.custom("HelveticaNeue", size: 20))
                                .foregroundColor(Color.init(white: 0.8))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                            Text("Display degree symbol when in DEG mode")
                                .font(.custom("HelveticaNeue", size: 12))
                                .foregroundColor(Color.init(white: 0.6))
                                .minimumScaleFactor(0.5)
                                .lineLimit(0)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: color(self.settings.theme.color1)))
                }
            }
        }
        .navigationBarTitle("Settings")
        .accentColor(color(self.settings.theme.color1))
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
