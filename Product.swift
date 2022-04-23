//
//  File.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 17.04.22.
//

import Foundation
import SwiftUI

class Product {
	init(name: String, description: String = "", value: Double, picture_string: String = "", type: product_type = product_type.Empty) {
		self.name = name
		self.source = description
		self.value = value
		self.type = type
		
		if picture_string != "" {
			let data = Data(base64Encoded: picture_string)
			let picture_temp = UIImage(data: data ?? Data([0])) ?? UIImage()
			picture = picture_temp.resize(UIScreen.main.bounds.width, UIScreen.main.bounds.height) ?? UIImage()
		}
	}
	
	var name: String
	var source: String
	var value: Double
	var picture: UIImage = UIImage()
	var type: product_type = product_type.Empty
}
