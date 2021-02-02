//
//  NetworkManager.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/2/21.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()

    private init() {}

    func downloadImage(from urlString: String, completed: @escaping (UIImage) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let cacheKey = NSString(string: urlString)

        // Runs the completion block if a cached image has been found
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            // Leave function if there is an error and use placeholder instead
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            // If image is available, then cache it and run the completion block
            guard let image = UIImage(data: data) else { return }
            self.cache.setObject(image, forKey: NSString(string: urlString))
            completed(image)
        }

        dataTask.resume()
    }
}
