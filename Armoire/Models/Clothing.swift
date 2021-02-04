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
            imageUrl: URL(string: "https://www.theprettydresscompany.com/images/the-pretty-dress-company-tilly-off-the-shoulder-bow-high-low-gown-p267-18042_image.jpg"),
            name: "Pink Dress",
            brand: "Miss Collection",
            quantity: 1,
            color: "#FAD9DC",
            isFavorite: true,
            description: "My favorite pink dress.",
            size: "Small",
            material: "Cotton",
            url: "https://www.theprettydresscompany.com/shop-c1/dresses-c2/the-pretty-dress-company-tilly-off-the-shoulder-bow-high-low-gown-p267"
        )
    }
}
