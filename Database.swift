//
//  File.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 16.04.22.
//

import Foundation
import MySQLDriver

var con: MySQL.Connection?
var table: MySQL.Table?

func setupConnection(type: String) -> (Int, Int) {
	do {
		con = try MySQL.Connection(addr: "spacem.cc", user:"HigherOrLower", passwd:"oJ1@K91Hl[", dbname:"HigherOrLower", port: 3307)
		try con?.open()
		if con == nil {
			print("Failed to open Connection")
			abort()
		}
		table = con!.getTable(type)
		if table == nil {
			print("Failed to get Table")
			abort()
		}
		
		return getLimits()
	} catch {
		print(error)
	}
	
	return (0, 0)
}

func getRandNum(minimum: Int, maximum: Int, count: Int = 50) -> [Int] {
	var set = Set<Int>()
	while set.count < min(count, maximum-minimum) {
		set.insert(Int.random(in: minimum...maximum))
	}
	return Array(set)
}

func getProducts(type: String, index: Int) -> Product {
	var result: Product = Product(name: "error", description: "", value: 0, picture_string: "", type: product_type.empty)
	
	do {
		let rows: MySQL.ResultSet = try table!.select(Where: ["id=", index, "LIMIT", call_size])?[0] ?? []
//		let rows: MySQL.ResultSet = try table!.select(Where: ["id=", 1, "LIMIT", call_size])?[0] ?? []
		
		for i in 0..<rows.count {
			
			let product	= Product(name: rows[i]["name"] as! String,
								  description: rows[i]["source"] as? String ?? "",
								  value: rows[i]["value"] as! Double,
								  picture_string: String(data: Data(rows[i]["picture"] as? [UInt8] ?? [0]), encoding: .utf8) ?? "",
								  type: product_type.empty)
			result = product
		}
	} catch {
		print(error)
	}
	
	return result
}

private func getLimits() -> (Int, Int) {
	var minimum = 0
	var maximum = 0
	
	do {
		let rows = try table!.select(["min(id) as min", "max(id) as max"], Where: ["id>", "0"]) ?? [[]]
		
		if(rows.count > 0 && rows[0].count > 0) {
			minimum = rows[0][0]["min"] as! Int
			maximum = rows[0][0]["max"] as! Int
		}
	} catch {
		print(error)
	}
	
	return (minimum, maximum)
}
