//
//  ClothingScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/20/21.
//

import SwiftUI
import UIKit

class ClothingScreen: UIViewController {
    let clothingColorButton = UIButton()
    let clothingImageView = UIImageView(image: UIImage(named: "PinkDress"))
    let clothingNameLabel = AMPrimaryLabel(text: "Pink Dress", fontSize: 36)
    let clothingBrandLabel = AMBodyLabel(text: "Miss Collection", fontSize: 24)
    let clothingDescriptionLabel = AMBodyLabel(text: "My favorite dress out of everything in my collection. The frabrick feels nice. The color is also nice.")
    let clothingQuantityLabel = AMBodyLabel(text: "1 quantity", fontSize: 22)
    let sizeLabel = AMBodyLabel(text: "Size", fontSize: 22)
    let materialLabel = AMBodyLabel(text: "Material", fontSize: 22)

    private var clothing: Clothing

    init(clothing: Clothing) {
        self.clothing = clothing
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureClothingImageView()
        configureClothingColorButton()
        configureClothingNameLabel()
        configureClothingBrandLabel()
        configureClothingDescriptionLabel()
    }

    func configureScreen() {
        title = clothing.name
        view.backgroundColor = .systemBackground

        let starImage = UIImage(systemName: SFSymbol.starFill)
        let favoriteButton = UIBarButtonItem(image: starImage, style: .plain, target: self, action: #selector(favoriteButtonTapped))
        navigationItem.rightBarButtonItem = favoriteButton
    }

    func configureClothingImageView() {
        view.addSubview(clothingImageView)
        clothingImageView.contentMode = .scaleAspectFill
        clothingImageView.clipsToBounds = true

        clothingImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
            make.height.equalTo(300)
        }
    }

    func configureClothingColorButton() {
        view.addSubview(clothingColorButton)
        clothingColorButton.addTarget(self, action: #selector(colorButtonTapped), for: .touchUpInside)
        clothingColorButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        clothingColorButton.imageView?.layer.transform = CATransform3DMakeScale(2, 2, 2)
        clothingColorButton.tintColor = .systemPink

        clothingColorButton.snp.makeConstraints { make in
            make.top.equalTo(clothingImageView.snp.bottom).offset(20)
            make.right.equalTo(view).offset(-20)
        }
    }

    func configureClothingNameLabel() {
        view.addSubview(clothingNameLabel)
        clothingNameLabel.text = clothing.name

        clothingNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(clothingColorButton)
            make.left.equalTo(view).offset(12)
            make.right.equalTo(clothingColorButton).offset(-8)
        }
    }

    func configureClothingBrandLabel() {
        view.addSubview(clothingBrandLabel)

        clothingBrandLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingNameLabel.snp.bottom)
            make.left.equalTo(clothingNameLabel)
            make.right.equalTo(clothingColorButton)
        }
    }

    func configureClothingDescriptionLabel() {
        view.addSubview(clothingDescriptionLabel)
        clothingDescriptionLabel.font = UIFont(name: Fonts.quicksandRegular, size: 18)
        clothingDescriptionLabel.numberOfLines = 0

        clothingDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(clothingBrandLabel.snp.bottom).offset(20)
            make.left.equalTo(clothingBrandLabel)
            make.right.equalTo(view).offset(-12)
        }
    }

    @objc func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        // Implement
    }

    @objc func colorButtonTapped(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.delegate = self
        colorPicker.selectedColor = clothingColorButton.tintColor
        colorPicker.supportsAlpha = false
        present(colorPicker, animated: true)
    }
}

extension ClothingScreen: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        clothingColorButton.tintColor = color
    }
}

#if DEBUG
struct ClothingScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(
                rootViewController: ClothingScreen(
                    clothing: Clothing(
                        image: UIImage(named: "Pink Dress")!,
                        name: "Pink Dress",
                        quantity: 1,
                        color: "#000000",
                        isFavorite: true
                    )
                )
            )
        }
    }
}
#endif
