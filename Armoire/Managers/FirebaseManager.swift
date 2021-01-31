//
//  FirebaseManager.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

struct User: Codable {
    @DocumentID var id: String? = nil
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var closet: [Folder]
}

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    private init() {}

    func fetchFolderItems(completed: @escaping (Result<[Folder], AMError>) -> Void) {
        db.collection("users").addSnapshotListener { querySnapshot, error in
            if let _ = error {
                return completed(.failure(.invalidUser))
            }

            guard let document = querySnapshot?.documents else {
                return completed(.failure(.nonexistentDocument))
            }

            let user = document.compactMap { queryDocumentSnapshot -> User? in
                return try? queryDocumentSnapshot.data(as: User.self)
            }

            print(user)
        }
    }
}
