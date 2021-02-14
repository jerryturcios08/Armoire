//
//  Message.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/13/21.
//

import FirebaseFirestoreSwift

struct Message: Codable {
    @DocumentID var id: String? = nil
    var body: String
    var isIncoming: Bool
}
