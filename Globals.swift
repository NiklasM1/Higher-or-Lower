//
//  File.swift
//  HigherOrLower
//
//  Created by Niklas Mischke on 23.04.22.
//

import Foundation
import SwiftUI

let products_empty: [Product] = [Product(name: "error", value: 0),
                                 Product(name: "error", value: 0)]

let texts = [["has", "costs", "has", ""],
             ["views", "", "average monthly searches", ""],
             ["Views", "Search", "Price", ""]]



enum product_type: String {
    case Views
    case Search
    case Price
    case Empty
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
