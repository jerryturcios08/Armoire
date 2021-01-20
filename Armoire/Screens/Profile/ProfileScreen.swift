//
//  ProfileScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/19/21.
//

import SnapKit
import SwiftUI
import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
}

class ProfileScreen: UIViewController {
    let label1 = UILabel()
    let label2 = UILabel()
    let label3 = UILabel()

    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureLabels()
        configureStackView()
    }

    func configureScreen() {
        title = "Profile"
        view.backgroundColor = .systemBackground
    }

    func configureLabels() {
        for (index, label) in [label1, label2, label3].enumerated() {
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Label: \(index+1)"
            label.textColor = .label
            label.backgroundColor = .systemBlue
            label.textAlignment = .center
        }
    }

    func configureStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubviews(label1, label2, label3)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.snp.makeConstraints { $0.size.equalTo(view) }
    }
}

#if DEBUG
struct ProfileScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: ProfileScreen())
        }
    }
}
#endif
