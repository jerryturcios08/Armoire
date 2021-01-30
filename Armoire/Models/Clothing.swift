//
//  Clothing.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import UIKit

struct Clothing {
    var image: UIImage // Needs a different implementation
    var name: String
    var brand: String
    var quantity: Int
    var color: String
    var isFavorite: Bool
    var description: String?
    var size: String?
    var material: String?
    var url: String?
    var dateCreated = Date()
    var dateUpdated: Date? = nil

    static var example: Clothing {
        Clothing(
            image: UIImage(named: "PinkDress")!,
            name: "Pink Dress",
            brand: "MSK",
            quantity: 1,
            color: "#000000",
            isFavorite: true,
            description: "My favorite pink dress.",
            size: "Small",
            material: "Cotton",
            url: Date().convertToDayMonthYearFormat()
        )
    }
}
