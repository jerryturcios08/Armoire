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

    func addFolder(with folder: Folder, for userId: String, completed: @escaping (Result<Folder, AMError>) -> Void) {
        let userRef = db.collection("users").document(userId)
        let foldersRef = db.collection("folders")

        var newFolder = Folder(
            title: folder.title,
            description: folder.description,
            isFavorite: folder.isFavorite,
            user: userRef
        )

        do {
            let document = try foldersRef.addDocument(from: newFolder)
            newFolder.id = document.documentID
            return completed(.success(newFolder))
        } catch {
            return completed(.failure(.invalidUser))
        }
    }

    func fetchFolders(for userId: String, completed: @escaping (Result<[Folder], AMError>) -> Void) {
        let userRef = db.collection("users").document(userId)
        let folderQuery = db.collection("folders").whereField("user", isEqualTo: userRef)

        folderQuery.getDocuments { querySnapshot, error in
            if let _ = error {
                return completed(.failure(.invalidUser))
            }

            guard let documents = querySnapshot?.documents else {
                return completed(.failure(.nonexistentDocument))
            }

            let folders = documents.compactMap { document in
                return try? document.data(as: Folder.self)
            }

            completed(.success(folders))
        }
    }

    func deleteFolder(_ folder: Folder, errorHandler: @escaping (AMError) ->Void) {
        guard let id = folder.id else { return }

        db.collection("folders").document(id).delete { error in
            if let _ = error {
                return errorHandler(.invalidUser)
            }
        }
    }
}
