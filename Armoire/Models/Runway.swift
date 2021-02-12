//
//  Runway.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/9/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct ItemNode {
    var imageUrl: String
    var xPosition: Double
    var yPosition: Double
    var zPosition: Double
}

struct Runway: Codable {
    @DocumentID var id: String? = nil
    var title: String
    var isFavorite = false
    var isSharing = false
    var dateCreated = Date()
    var dateUpdated: Date? = nil
    var user: DocumentReference?
}
