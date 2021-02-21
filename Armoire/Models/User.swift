//
//  User.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/31/21.
//

import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String? = nil
    var firstName: String
    var lastName: String
    var email: String
    var username: String

    static var example: User {
        User(
            firstName: "Geraldine",
            lastName: "Turcios",
            email: "rosierjolie1999@gmail.com",
            username: "rosierjolie"
        )
    }
}
