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
    var description: String?
    var quantity: Int
    var color: String
    var isFavorite: Bool
    var size: String?
    var brand: String?
    var material: String?
    var url: String?
    var dateCreated = Date()
    var dateUpdated: Date? = nil
}
