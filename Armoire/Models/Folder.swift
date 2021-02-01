//
//  Folder.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/21/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct Folder: Codable {
    @DocumentID var id: String? = nil
    var title: String
    var description: String?
    var isFavorite: Bool
    var user: DocumentReference?

    static var example: Folder {
        Folder(
            title: "Dresses",
            description: "Collection of formal wear.",
            isFavorite: true
        )
    }
}
