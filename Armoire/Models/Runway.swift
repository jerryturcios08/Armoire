//
//  Runway.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/9/21.
//

import FirebaseFirestoreSwift

struct Runway: Codable {
    @DocumentID var id: String? = nil
    var title: String
    var isFavorite = false
    var isSharing = false
    var dateCreated = Date()
    var dateUpdated: Date? = nil
}
