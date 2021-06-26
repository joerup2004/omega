//
//  AboutView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 3/11/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI
import StoreKit

struct AboutView: View {
    
    var settings = Settings.settings
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    @State var presentShare = false
    
    var body: some View {
        
        GeometryReader { geometry in
                
            List {
                
                if geometry.size.width > 800 {
                    HStack {
                        Image("Omega_\(self.settings.theme.name.replacingOccurrences(of:" ",with:"_"))")
                            .resizable()
                            .frame(width: geometry.size.width*0.15, height: geometry.size.width*0.15)
                            .cornerRadius(20)
                        HStack {
                            Text("Omega Calculator")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .lineLimit(0)
                                .minimumScaleFactor(0.00001)
                            Spacer()
                        }
                        .frame(width: geometry.size.width*0.5)
                        .padding(.leading, 20)
                        Spacer()
                    }
                    .padding(10)
                    .padding(.vertical, 3)
                }
                else {
                    VStack {
                        HStack {
                            Spacer()
                            Image("Omega_\(self.settings.theme.name.replacingOccurrences(of:" ",with:"_"))")
                                .resizable()
                                .frame(width: geometry.size.width*0.3, height: geometry.size.width*0.3)
                                .cornerRadius(20)
                                .padding(.top, 10)
                            Spacer()
                        }
                        Text("Omega Calculator")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .lineLimit(0)
                            .minimumScaleFactor(0.00001)
                        Spacer()
                    }
                    .padding(10)
                    .padding(.vertical, 3)
                }
                    
                VStack {
                    HStack {
                        Text("About")
                            .font(.headline)
                            .foregroundColor(Color.init(white: 0.8))
                        Spacer()
                    }
                    Text("Omega Calculator is an intuitive and powerful calculator that can be used for any mathematical computation you need to perform. The calculator includes basic operations, exponents, roots, fractions, logarithms, trig functions, probability, and much more. With Omega’s innovative approach to input complex expressions, performing a multitude of tasks is easily possible. You can view and save your past calculations for future use, as well as customize your experience with display settings and over 30 color themes to choose from.")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.subheadline)
                        .foregroundColor(Color.init(white: 0.5))
                        .padding(.top, 1)
                }
                .padding(10)
                .padding(.vertical, 3)
                
                HStack {
                    Text("Version")
                        .font(.headline)
                        .foregroundColor(Color.init(white: 0.8))
                    Spacer()
                    Text(appVersion ?? "")
                }
                .padding(10)
                .padding(.vertical, 3)
                
                Link(destination: URL(string: "https://joerup2004.github.io/omega/support/support.html")!) {
                    NavigationLink(destination: EmptyView()) {
                        VStack {
                            HStack {
                                Text("Support")
                                    .font(.headline)
                                    .foregroundColor(Color.init(white: 0.8))
                                Image(systemName: "paperplane")
                                    .imageScale(.small)
                                Spacer()
                            }
                            HStack {
                                Text("Report bugs, ask questions, give feedback.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.init(white: 0.5))
                                    .padding(.top, 1)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(10)
                .padding(.vertical, 3)
                
                Link(destination: URL(string: "https://joerup2004.github.io/omega/privacy/privacy.html")!) {
                    NavigationLink(destination: EmptyView()) {
                        VStack {
                            HStack {
                                Text("Privacy Policy")
                                    .font(.headline)
                                    .foregroundColor(Color.init(white: 0.8))
                                Image(systemName: "hand.raised")
                                    .imageScale(.small)
                                Spacer()
                            }
                            HStack {
                                Text("See how you're protected while using Omega.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.init(white: 0.5))
                                    .padding(.top, 1)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(10)
                .padding(.vertical, 3)
                
                Button {
                    if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: scene)
                    }
                } label: {
                    NavigationLink(destination: EmptyView()) {
                        VStack {
                            HStack {
                                Text("Rate the App")
                                    .font(.headline)
                                    .foregroundColor(Color.init(white: 0.8))
                                Image(systemName: "star")
                                    .imageScale(.small)
                                Spacer()
                            }
                            HStack {
                                Text("Give us a rating or review.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.init(white: 0.5))
                                    .padding(.top, 1)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(10)
                .padding(.vertical, 3)
                
                Button {
                    self.presentShare.toggle()
                } label: {
                    NavigationLink(destination: EmptyView()) {
                        VStack {
                            HStack {
                                Text("Share the App")
                                    .font(.headline)
                                    .foregroundColor(Color.init(white: 0.8))
                                Image(systemName: "square.and.arrow.up")
                                    .imageScale(.small)
                                Spacer()
                            }
                            HStack {
                                Text("Show Omega to your friends and others.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.init(white: 0.5))
                                    .padding(.top, 1)
                                Spacer()
                            }
                        }
                    }
                }
                .padding(10)
                .padding(.vertical, 3)
                .sheet(isPresented: self.$presentShare, content: {
                    ActivityViewController(activityItems: [URL(string: "https://apps.apple.com/us/app/omega-calculator/id1528068503")!])
                })
                
                VStack {
                    HStack {
                        Text("More Apps")
                            .font(.headline)
                            .foregroundColor(Color.init(white: 0.8))
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        Link(destination: URL(string: "https://apps.apple.com/is/app/planetaria/id1546887479")!) {
                            VStack {
                                Image("Planetaria")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(20)
                                Text("Planetaria")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.vertical, 5)
                }
                .padding(10)
                .padding(.vertical, 3)
            }
            .listStyle(InsetGroupedListStyle())
            .accentColor(color(self.settings.theme.color1))
        }
        .navigationBarTitle("About")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
    }
}


struct ActivityViewController: UIViewControllerRepresentable {

    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityViewController>) {}

}
