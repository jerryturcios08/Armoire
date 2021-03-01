//
//  AMImageView.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/2/21.
//

import UIKit

class AMImageView: UIImageView {
    static let placeholderImage = Images.placeholder
    let cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setImage(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }

    private func configureImageView() {
        image = AMImageView.placeholderImage
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
