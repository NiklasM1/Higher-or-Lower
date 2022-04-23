//
//  Menu.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 23.04.22.
//

import SwiftUI

struct Menu: View {
	@State private var active = [false, false, false, false]
	
    var body: some View {
		VStack {
			ForEach((0..<3), id:\.self) { i in
				Button {
					active[i] = true
				} label: {
					Text(texts[2][i])
				}
					.buttonStyle(GrowingButton())
					.padding()
			}
		}.fullScreenCover(isPresented: $active[0]) {
			searches(type: product_type.Views)
		}.fullScreenCover(isPresented: $active[1]) {
			searches(type: product_type.Search)
		}.fullScreenCover(isPresented: $active[2]) {
			searches(type: product_type.Price)
		}.fullScreenCover(isPresented: $active[3]) {
			searches(type: product_type.Empty)
		}
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
