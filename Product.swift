//
//  File.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 17.04.22.
//

import Foundation

let call_size: Int = 10
var minimum: Int = 1
var maximum: Int = 10

let products_empty: [Product] = [Product(name: "temp", description: "temp", value: 0, picture: "", type: product_type.empty),
								  Product(name: "temp", description: "temp", value: 0, picture: "", type: product_type.empty)]

enum product_type: String {
	case views
	case search
	case price
	case empty
}

class Product {
	init(name: String, description: String, value: Double, picture: String, type: product_type) {
		self.name = name
		self.description = description
		self.value = value
		self.picture = picture
		self.type = type
	}
	
	var name: String
	var description: String
	var value: Double
	var picture: String
	var type: product_type
}
