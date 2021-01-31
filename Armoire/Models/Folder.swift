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
}
