//
//  TextView.swift
//  Calculator
//
//  Created by Joe Rupertus on 4/15/20.
//  Copyright © 2020 Joe Rupertus. All rights reserved.
//

// TextView manages the view for the output of the calculator

import SwiftUI
import UIKit

struct TextView: View {
    
	@ObservedObject var hub = Hub.hub
	@ObservedObject var settings = Settings.settings
	@ObservedObject var calc = Calculations.calc
	@ObservedObject var input = Input.input
    
    var width: CGFloat
    var height: CGFloat
	var landscapeMode: Bool
    
	@ViewBuilder
    var body: some View {
		
		if !landscapeMode {
			
			GeometryReader { geometry in
				
				VStack(alignment: .trailing, spacing: 0) {
					
					HeaderButtonView(width: geometry.size.width, height: geometry.size.height*0.15, mode: "header")
						.padding(.vertical, self.height*0.05)
					
					// MARK: Top Output
					TextViews(
						array: self.hub.topOutput,
						formattingGuide: self.hub.topFormattingGuide,
						size: resize(array: self.hub.topOutput, formattingGuide: self.hub.topFormattingGuide, size: self.height*0.15, width: self.width, position: "top", landscape: false),
						position: "top"
					)
					.foregroundColor(Color.init(white: 0.7))
					.frame(height: self.height*0.16, alignment: .trailing)
					.padding(.horizontal, self.width/17)
					.padding(.vertical, self.height*0.01)
					.onTapGesture {
						if self.hub.topOutput != [" "] && !self.hub.topOutput.isEmpty {
							self.input.prevInput(backspaceOnly: false)
						}
					}
					.animation(self.settings.animateText ? .easeInOut : nil)

					// MARK: Main Output
					TextViews(
						array: self.hub.mainOutput,
						formattingGuide: self.hub.mainFormattingGuide,
						size: resize(array: self.hub.mainOutput, formattingGuide: self.hub.mainFormattingGuide, size: self.height*0.32, width: self.width, position: "main", landscape: false),
						position: "main"
					)
					.foregroundColor(Color.white)
					.frame(height: self.height*0.35, alignment: .trailing)
					.padding(.horizontal, self.width/17)
					.padding(.vertical, self.height*0.01)
					.animation(self.settings.animateText ? .easeInOut : nil)

					// MARK: Bottom Output
					TextViews(
						array: self.hub.bottomOutput,
						formattingGuide: self.hub.bottomFormattingGuide,
						size: resize(array: self.hub.bottomOutput, formattingGuide: self.hub.bottomFormattingGuide, size: self.height*0.13, width: self.width, position: "bottom", landscape: false),
						position: "bottom"
					)
					.foregroundColor(Color.init(white: 0.7))
					.frame(height: self.height*0.15, alignment: .trailing)
					.padding(.horizontal, self.width/17)
					.padding(.vertical, self.height*0.01)
					.padding(.bottom, -self.height*0.03)
					.onTapGesture {
						!self.calc.calculations.isEmpty ? self.input.swapAlternateResults(calculation: self.calc.calculations.last!) : nil
					}
					.popover(isPresented: self.$input.showErrorPopUp) {
						Text(self.hub.extraMessagePopUp)
						.fixedSize()
					}
					.animation(self.settings.animateText ? .easeInOut : nil)
				}
				.padding(.bottom, self.height*0.05)
			}
			.frame(width: width, height: height, alignment: .center)
		}
		else {
			
			GeometryReader { geometry in
				
				HStack(spacing: 0) {
					
					HeaderButtonView(width: geometry.size.width*0.1, height: geometry.size.height, mode: "leftColumn")
					
					VStack(alignment: .leading) {
						
						HeaderButtonView(width: geometry.size.width*0.3, height: geometry.size.height*0.4, mode: "landscapeHeader")
						
						// MARK: Bottom Output
						TextViews(
							array: self.hub.bottomOutput,
							formattingGuide: self.hub.bottomFormattingGuide,
							size: resize(array: self.hub.bottomOutput, formattingGuide: self.hub.bottomFormattingGuide, size: self.height*0.4, width: self.width, position: "bottom", landscape: true),
							position: "bottom"
						)
						.foregroundColor(Color.init(white: 0.7))
						.frame(width: geometry.size.width*0.25, height: self.height*0.4, alignment: .leading)
						.padding(.trailing, self.width/17)
						.padding(.leading, self.width*0.03)
						.padding(.vertical, self.height*0.1)
						.onTapGesture {
							!self.calc.calculations.isEmpty ? self.input.swapAlternateResults(calculation: self.calc.calculations.last!) : nil
						}
						.popover(isPresented: self.$input.showErrorPopUp) {
							Text(self.hub.extraMessagePopUp)
							.fixedSize()
						}
						.animation(self.settings.animateText ? .easeInOut : nil)
					}
					.frame(width: self.width*0.3, height: self.height, alignment: .leading)
					
					VStack(alignment: .trailing) {
						
						Spacer()
						
						// MARK: Top Output
						TextViews(
							array: self.hub.topOutput,
							formattingGuide: self.hub.topFormattingGuide,
							size: resize(array: self.hub.topOutput, formattingGuide: self.hub.topFormattingGuide, size: self.height*0.3, width: self.width*0.9, position: "top", landscape: true),
							position: "top"
						)
						.foregroundColor(Color.init(white: 0.7))
						.frame(width: geometry.size.width*0.5, height: self.height*0.3, alignment: .trailing)
						.padding(.leading, self.width/17)
						.padding(.trailing, self.width*0.05)
						.onTapGesture {
							if self.hub.topOutput != [" "] && !self.hub.topOutput.isEmpty {
								self.input.prevInput(backspaceOnly: false)
							}
						}
						.animation(self.settings.animateText ? .easeInOut : nil)

						// MARK: Main Output
						TextViews(
							array: self.hub.mainOutput,
							formattingGuide: self.hub.mainFormattingGuide,
							size: resize(array: self.hub.mainOutput, formattingGuide: self.hub.mainFormattingGuide, size: self.height*0.6, width: self.width*0.9, position: "main", landscape: true),
							position: "main"
						)
						.foregroundColor(Color.white)
						.frame(width: geometry.size.width*0.5, height: self.height*0.6, alignment: .trailing)
						.padding(.leading, self.width/17)
						.padding(.trailing, self.width*0.05)
						.animation(self.settings.animateText ? .easeInOut : nil)

						Spacer()
					}
					.frame(width: self.width*0.6, height: self.height, alignment: .trailing)
					.padding(.trailing, -self.width*0.03)
				}
				.frame(width: self.width, height: self.height, alignment: .center)
				.padding(.bottom, self.height*0.05)
			}
			.frame(width: width, height: height, alignment: .center)
		}
    }
}
	
// Text Views
// Concatenate all of the text in the array and change formatting of certain parts
struct TextViews: View {

	var array: Array<String>
	var formattingGuide: [[String]]
	var size: CGFloat
	var position: String

	@ObservedObject var formatting = Formatting.formatting
	
	var body: some View {
		
		ZStack {
			
			Rectangle()
				.opacity(0)
				.frame(width: 0.001, height: self.size)
			
			HStack(spacing:0) {
				
				ForEach(self.formatting.a(array).indices, id: \.self) { index in
						
					self.formatting.form(
						
						text: self.formatting.a(self.array)[index],
						inputSize: self.size,
						position: self.position,
						index: index,
						array: self.formatting.a(self.array),
						formatting: formattingGuide
					)
				}
			}
		}
		.frame(height: self.size)
	}
}


// Resize text if it does not fit
func resize(array: Array<String>, formattingGuide: [[String]], size: CGFloat, width: CGFloat, position: String, landscape: Bool) -> CGFloat {
	
	var totalWidth: CGFloat = 0
	var newSize = size
	
	let formatting = Formatting.formatting

	// Loop through the array and add the widths of each item to the total
	var index = 0
	while index < formatting.a(array).count {

		let itemWidth = formatting.format(formatting.a(array)[index], inputSize: newSize, position: position, index: index, array: formatting.a(array), formatting: formattingGuide, makeView: false)

		totalWidth += itemWidth

		index += 1
	}
	
	// If the width is almost greater than the screen width, shrink and repeat
	if totalWidth > ( !landscape ? width*0.85 : position == "bottom" ? width*0.25 : width*0.65 ) {
		newSize = resize(array: array, formattingGuide: formattingGuide, size: size-1, width: width, position: position, landscape: landscape)
	}
	
	return newSize
}
