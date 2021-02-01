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

    // MARK: - Clothes collection

    func fetchClothes(for folderId: String, completed: @escaping (Result<[Clothing], AMError>) -> Void) {
        let folderRef = db.collection("folders").document(folderId)
        let clothingQuery = db.collection("clothes").whereField("folder", isEqualTo: folderRef)

        clothingQuery.getDocuments { querySnapshot, error in
            if error != nil {
                return completed(.failure(.invalidUser))
            }

            guard let documents = querySnapshot?.documents else {
                fatalError("Something went wrong.")
            }

            let clothes = documents.compactMap { document in
                return try? document.data(as: Clothing.self)
            }

            completed(.success(clothes))
        }
    }

    // MARK: - Folders collection

    func addFolder(with folder: Folder, for userId: String, completed: @escaping (Result<Folder, AMError>) -> Void) {
        let userRef = db.collection("users").document(userId)
        let foldersRef = db.collection("folders")

        var newFolder = Folder(
            title: folder.title,
            description: folder.description ?? nil,
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
            if error != nil {
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

    func updateFolder(_ folder: Folder, completion: @escaping (Result<Folder, AMError>) -> Void) {
        guard let id = folder.id else { return }
        let folderRef = db.collection("folders").document(id)

        if let description = folder.description {
            folderRef.updateData([
                "title": folder.title,
                "description": description,
                "isFavorite": folder.isFavorite
            ])
        } else {
            folderRef.updateData([
                "title": folder.title,
                "isFavorite": folder.isFavorite
            ])
        }
    }

    func deleteFolder(_ folder: Folder, errorHandler: @escaping (AMError) ->Void) {
        guard let id = folder.id else { return }

        fetchClothes(for: id) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let clothes): self.deleteClothesForFolder(clothes, errorHandler: errorHandler)
            case .failure(let error): fatalError("Error! " + error.localizedDescription)
            }
        }

        db.collection("folders").document(id).delete { error in
            if error != nil {
                return errorHandler(.invalidUser)
            }
        }
    }

    private func deleteClothesForFolder(_ clothes: [Clothing], errorHandler: @escaping (AMError) -> Void) {
        for clothing in clothes {
            guard let id = clothing.id else { break}

            self.db.collection("clothes").document(id).delete { error in
                if error != nil {
                    return errorHandler(.nonexistentDocument)
                }
            }
        }
    }
}
