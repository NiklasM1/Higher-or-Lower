//
//  File.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 17.04.22.
//

import Foundation
import SwiftUI

let call_size: Int = 10
var minimum: Int = 1
var maximum: Int = 10

let products_empty: [Product] = [Product(name: "error", value: 0),
								 Product(name: "error", value: 0)]

enum product_type: String {
	case views
	case search
	case price
	case empty
}

class Product {
	init(name: String, description: String = "", value: Double, picture_string: String = "", type: product_type = product_type.empty) {
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
	var type: product_type = product_type.empty
}


extension UIImage {
	func resize(_ width: CGFloat, _ height:CGFloat) -> UIImage? {
		let widthRatio  = width / size.width
		let heightRatio = height / size.height
		let ratio = widthRatio > heightRatio ? heightRatio : widthRatio
		let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
		let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage
	}
}
