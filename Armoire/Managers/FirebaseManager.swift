//
//  FirebaseManager.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    private init() {}

    func fetchFolderItems(completed: @escaping (Result<[Folder], AMError>) -> Void) {
        let userRef = db.collection("users").document("QePfaCJjbHIOmAZgfgTF")

        userRef.getDocument { document, error in
            if let _ = error {
                return completed(.failure(.invalidUser))
            }

            guard let document = document, document.exists else {
                return completed(.failure(.nonexistentDocument))
            }

            guard let user = try? document.data(as: User.self) else {
                return completed(.failure(.nonexistentDocument))
            }

            return completed(.success(user.closet))
        }
    }
}
