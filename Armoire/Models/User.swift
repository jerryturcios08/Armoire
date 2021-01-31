//
//  User.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/31/21.
//

import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String? = UUID().uuidString
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var closet: [Folder]
}
