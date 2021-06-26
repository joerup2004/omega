////
////  SettingsSubShrink.swift
////  OmegaCalculator
////
////  Created by Joe Rupertus on 6/22/21.
////  Copyright © 2021 Rupertus. All rights reserved.
////
//
//import SwiftUI
//
//struct SettingsSubShrink: View {
//
//    @ObservedObject var settings = Settings.settings
//
//    var body: some View {
//
//        VStack {
//
//            HStack {
//
//                Text("Text is shrunk")
//                    .frame(alignment: .leading)
//                    .font(.custom("HelveticaNeue", size: 20))
//                    .foregroundColor(Color.init(white: 0.6))
//                    .minimumScaleFactor(0.5)
//                    .padding(.all, 15)
//
//                Spacer()
//            }
//
//            List {
//
//                Button(action: {
//                    self.settings.scrollResults = true
//                }) {
//                    HStack {
//                        
//                        Text(String(num))
//                            .font(.custom("HelveticaNeue", size: 20))
//                            .foregroundColor(Color.init(white: 0.8))
//                            .minimumScaleFactor(0.5)
//                            .linaeLimit(0)
//
//                        Spacer()
//
//                        if self.settings.roundPlaces == num {
//                            Image(systemName: "checkmark")
//                                .font(.custom("HelveticaNeue", size: 20))
//                                .foregroundColor(Color.init(white: 0.8))
//                                .minimumScaleFactor(0.5)
//                                .lineLimit(0)
//                        }
//                    }
//                }
//            }
//        }
//        .navigationBarTitle("Rounding Places")
//    }
//}
