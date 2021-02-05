//
//  ImageViewerScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 2/4/21.
//

import SwiftUI
import UIKit

class ImageViewerScreen: UIViewController {
    let imageView = UIImageView()

    private var imageName: String

    init(imageName: String, image: UIImage?) {
        self.imageName = imageName
        imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        configureGestures()
        configureImageView()
    }

    func configureGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissScreen))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    func configureImageView() {
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-12)
            make.bottom.equalTo(view).offset(-20)
        }
    }

    @objc func dismissScreen() {
        dismiss(animated: true)
    }
}

#if DEBUG
struct ImageViewerScreenPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                ImageViewerScreen(imageName: "Pink Dress", image: UIImage(named: "PinkDress"))
            }
            UIViewControllerPreview {
                ImageViewerScreen(imageName: "Pink Dress", image: UIImage(named: "PinkDress"))
            }
            .previewDisplayName("iPhone XR Landscape")
            .previewLayout(.fixed(width: 896, height: 414))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
