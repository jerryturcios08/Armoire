//
//  Folder.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import Foundation

struct Folder: Codable {
    var title: String
    var description: String?
    var isFavorite: Bool
    var clothes = [Clothing]()
}
