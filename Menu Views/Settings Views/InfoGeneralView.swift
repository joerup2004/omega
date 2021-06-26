//
//  InfoGeneralView.swift
//  OmegaCalculator
//
//  Created by Joe Rupertus on 6/21/21.
//  Copyright © 2021 Rupertus. All rights reserved.
//

import SwiftUI

struct InfoGeneralView: View {
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ScrollView {
                
                VStack {
                
                    Spacer()
                        .frame(width: geometry.size.width, height: 10)
                        
                    Text("""
                        \n• Press the clear button to remove everything from the screen.
                        \n• Press the backspace button to undo the last thing inputted.
                        \n• Press and hold a button to automatically add parentheses, or use the parentheses button.
                        \n• Use parentheses to put more than one number in an exponent, root, etc.
                        \n• For some operations, parentheses are automatically added to achieve what you're most likely trying to do.
                        \n• Press and hold the open parenthesis to put the entire expression in parentheses.
                        \n• Some items can be applied either before or after the previously imputted item; for example, you could enter either "√" + "6" or "6" + "√" to get the square root of 6.
                        \n• View past calculations by pressing the down arrow or the Calculations tab.
                        """)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(color([200,200,200]))
                        .padding(10)
                        .padding(.bottom, 20)
                        .font(.headline)
                }
                .frame(width: geometry.size.width > 800 ? 800 : geometry.size.width*0.96 )
                .padding(.horizontal, geometry.size.width > 800 ? (geometry.size.width-800)/2 : geometry.size.width*0.02)
            }
        }
        .navigationBarTitle("General Info & Tips")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: MenuX())
    }
}

struct InfoGeneralView_Previews: PreviewProvider {
    static var previews: some View {
        InfoGeneralView()
    }
}
