//
//  FirebaseManager.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/30/21.
//

import FirebaseFirestore
import FirebaseStorage

extension String {
    var blobCase: String {
        self.replacingOccurrences(of: " ", with: "-")
    }
}

class FirebaseManager {
    static let shared = FirebaseManager()

    private let db = Firestore.firestore()
    private let storage = Storage.storage()

    private init() {}

    // MARK: - Clothes collection

    func addClothing(with clothing: Clothing, image: UIImage, folderId: String, completed: @escaping (Result<Clothing, AMError>) -> Void) {
        let folderRef = db.collection("folders").document(folderId)
        let clothesRef = db.collection("clothes")
        let storageRef = storage.reference()

        let clothingImageRef = storageRef.child("images/\(clothing.name.blobCase.lowercased()).jpg")

        guard let data = image.jpegData(compressionQuality: 0.8) else {
            return completed(.failure(.invalidImage))
        }

        let uploadTask = clothingImageRef.putData(data, metadata: nil) { metadata, error in
            clothingImageRef.downloadURL { url, error in
                if error != nil {
                    return completed(.failure(.unableToComplete))
                }

                guard let downloadUrl = url else {
                    return completed(.failure(.invalidUrl))
                }

                var newClothing = Clothing(
                    imageUrl: downloadUrl,
                    name: clothing.name,
                    brand: clothing.brand,
                    quantity: clothing.quantity,
                    color: clothing.color,
                    isFavorite: clothing.isFavorite,
                    description: clothing.description ?? nil,
                    size: clothing.size ?? nil,
                    material: clothing.material ?? nil,
                    url: clothing.url ?? nil,
                    dateCreated: clothing.dateCreated,
                    dateUpdated: clothing.dateUpdated,
                    folder: folderRef
                )

                do {
                    let document = try clothesRef.addDocument(from: newClothing)
                    newClothing.id = document.documentID
                    completed(.success(newClothing))
                } catch {
                    completed(.failure(.invalidData))
                }
            }
        }

        uploadTask.resume()
    }

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

    func createFolder(with folder: Folder, for userId: String, completed: @escaping (Result<Folder, AMError>) -> Void) {
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
            completed(.success(newFolder))
        } catch {
            completed(.failure(.invalidData))
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
