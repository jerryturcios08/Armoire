//
//  Clothing.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Clothing: Codable {
    @DocumentID var id: String? = nil
    var imageUrl: URL?
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
    var folder: DocumentReference?

    static var example: Clothing {
        Clothing(
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
