//
//  Runway.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/9/21.
//

import FirebaseFirestoreSwift

enum Status: String, Codable {
    case notSharing = "Not Sharing"
    case sharing = "Sharing"
}

struct Runway: Codable {
    @DocumentID var id: String? = nil
    var title: String
    var isFavorite: Bool
    var status: Status
    var dateCreated = Date()
    var dateUpdated: Date? = nil
}
