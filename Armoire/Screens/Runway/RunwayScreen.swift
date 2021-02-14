//
//  RunwayScreen.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/24/21.
//

import SpriteKit
import SwiftUI
import UIKit

class RunwayScreen: UIViewController {
    // MARK: - Properties

    let scene = CanvasScene()

    let undoButton = AMBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left"))
    let redoButton = AMBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"))
    let moveUpButton = AMBarButtonItem(image: UIImage(systemName: "arrow.up"))
    let moveDownButton = AMBarButtonItem(image: UIImage(systemName: "arrow.down"))
    let deleteButton = AMBarButtonItem(image: UIImage(systemName: "trash"))

    let editTitleField = EditTitleField(previousTitle: "")
    let editTitleTapGestureRecognizer = UITapGestureRecognizer()

    private var runway: Runway
    var selectedNode: SKNode?

    // MARK: - Initializers

    init(runway: Runway) {
        self.runway = runway
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overriden methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
        configureGestures()
        configureNavigationTitleView()
        configureControlsToolbar()
        configureCanvasView()
        configureEditTitleField()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.userInterfaceStyle == .light {
            scene.changeToLightMode()
        } else if traitCollection.userInterfaceStyle == .dark {
            scene.changeToDarkMode()
        }
    }

    // MARK: - Configurations

    func configureScreen() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        let saveButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.down"), style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItems = [closeButton, saveButton]

        let exportButton = UIBarButtonItem(image: UIImage(systemName: "link"), style: .plain, target: self, action: #selector(exportButtonTapped))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItemButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, exportButton]
    }

    func configureGestures() {
        editTitleTapGestureRecognizer.addTarget(self, action: #selector(runwayTitleTapped))
        view.addGestureRecognizer(editTitleTapGestureRecognizer)
    }

    func configureNavigationTitleView() {
        let titleLabel = AMBodyLabel(text: runway.title)
        titleLabel.text = runway.title
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail

        let titleView = titleLabel
        titleView.setFont(with: UIFont(name: Fonts.quicksandSemiBold, size: 17))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(editTitleTapGestureRecognizer)
        navigationItem.titleView = titleView
    }

    func configureControlsToolbar() {
        navigationController?.setToolbarHidden(false, animated: false)

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

        undoButton.setOnAction(undoButtonTapped)
        redoButton.setOnAction(redoButtonTapped)
        moveUpButton.setOnAction(arrowUpButtonTapped)
        moveDownButton.setOnAction(arrowDownButtonTapped)
        deleteButton.setOnAction(deleteButtonTapped)

        undoButton.isEnabled = false
        redoButton.isEnabled = false
        moveUpButton.isEnabled = false
        moveDownButton.isEnabled = false
        deleteButton.isEnabled = false

        toolbarItems = [
            undoButton, spacer, redoButton,
            spacer, moveUpButton, spacer,
            moveDownButton, spacer, deleteButton
        ]
    }

    func configureCanvasView() {
        view = SKView(frame: UIScreen.main.bounds)

        scene.canvasDelegate = self
        scene.size = view.bounds.size
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        scene.scaleMode = .aspectFill

        if traitCollection.userInterfaceStyle == .dark {
            scene.backgroundColor = .canvasDarkModeBackground
        } else if traitCollection.userInterfaceStyle == .light {
            scene.backgroundColor = .canvasLightModeBackground
        }

        guard let skView = view as? SKView else { return }
        skView.ignoresSiblingOrder = true
        skView.presentScene(scene)

        #if DEBUG
        skView.showsFPS = true
        skView.showsNodeCount = true
        #else
        skView.showsFPS = false
        skView.showsNodeCount = false
        #endif

        if let dataUrl = runway.dataUrl {
            do {
                let jsonData = try Data(contentsOf: dataUrl)
                let nodes = try JSONDecoder().decode([ItemNode].self, from: jsonData)
                scene.loadNodes(nodes)
            } catch {
                presentErrorAlert(message: error.localizedDescription)
            }
        }
    }

    func configureEditTitleField() {
        view.addSubview(editTitleField)
        editTitleField.isHidden = true
        editTitleField.textField.delegate = self
        editTitleField.textField.text = runway.title

        editTitleField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.equalTo(340)
            make.height.equalTo(60)
            make.centerX.equalTo(view)
        }
    }

    // MARK: - Defined methods

    func updateTitleView(text: String) {
        let updatedTitleLabel = AMBodyLabel(text: text)
        updatedTitleLabel.numberOfLines = 1
        updatedTitleLabel.lineBreakMode = .byTruncatingTail

        let titleView = updatedTitleLabel
        titleView.setFont(with: UIFont(name: Fonts.quicksandSemiBold, size: 17))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(editTitleTapGestureRecognizer)
        navigationItem.titleView = updatedTitleLabel
    }

    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Exit", message: "Are you sure you want to close this runway? All progress will be saved.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor

        alertController.addAction(UIAlertAction(title: "Exit", style: .default) { [weak self] _ in
            guard let self = self else { return }

            FirebaseManager.shared.updateRunwayCanvas(self.runway, itemNodes: self.scene.itemNodes) { error in
                self.presentErrorAlert(message: error.rawValue)
            }

            self.dismiss(animated: true)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    @objc func saveButtonTapped(_ sender: UIBarButtonItem) {
        FirebaseManager.shared.updateRunwayCanvas(self.runway, itemNodes: self.scene.itemNodes) { error in
            return self.presentErrorAlert(message: error.rawValue)
        }

        let alertController = UIAlertController(title: "Saved", message: "Your runway was saved.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor
        alertController.addAction(UIAlertAction(title: "Okay", style: .default))
        present(alertController, animated: true)
    }

    @objc func exportButtonTapped(_ sender: UIBarButtonItem) {
        let destinationScreen = AMNavigationController(rootViewController: CriticListScreen())
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }

    @objc func addItemButtonTapped(_ sender: UIBarButtonItem) {
        let itemSearchScreen = ItemSearchScreen()
        let destinationScreen = AMNavigationController(rootViewController: itemSearchScreen)
        itemSearchScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
    }

    @objc func undoButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: Implement undo functionality
    }

    @objc func redoButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: Implement redo functionality
    }

    @objc func arrowUpButtonTapped(_ sender: UIBarButtonItem) {
        guard let node = selectedNode else { return }
        scene.increaseNodeZPosition(for: node)
    }

    @objc func arrowDownButtonTapped(_ sender: UIBarButtonItem) {
        guard let node = selectedNode else { return }
        scene.decreaseNodeZPosition(for: node)
    }

    @objc func deleteButtonTapped(_ sender: UIBarButtonItem) {
        guard let node = selectedNode else { return }

        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete the selected item?", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor

        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            self.scene.deleteNode(node: node)
            self.moveUpButton.isEnabled = false
            self.moveDownButton.isEnabled = false
            self.deleteButton.isEnabled = false
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    @objc func runwayTitleTapped(_ gesture: UITapGestureRecognizer) {
        UIView.transition(with: editTitleField, duration: 0.25, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self = self else { return }
            self.editTitleField.isHidden = false
            self.editTitleField.textField.becomeFirstResponder()
        })
    }
}

// MARK: - Canvas scene delegate

extension RunwayScreen: CanvasSceneDelegate {
    func didTapBackground() {
        selectedNode = nil
        moveUpButton.isEnabled = false
        moveDownButton.isEnabled = false
        deleteButton.isEnabled = false
    }

    func didTapItem(_ node: SKNode) {
        selectedNode = node
        moveUpButton.isEnabled = true
        moveDownButton.isEnabled = true
        deleteButton.isEnabled = true
    }

    func didUpdate(_ itemNodes: [ItemNode]) {
        FirebaseManager.shared.updateRunwayCanvas(runway, itemNodes: itemNodes) { [weak self] error in
            guard let self = self else { return }
            self.presentErrorAlert(message: error.rawValue)
        }
    }
}

// MARK: - Item search delegate

extension RunwayScreen: ItemSearchScreenDelegate {
    func didSelectClothingItem(_ clothing: Clothing) {
        guard let imageUrl = clothing.imageUrl else { return }

        do {
            let data = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: data) else { return }
            scene.createNewNode(for: image, urlString: imageUrl.absoluteString)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
}

// MARK: - Text field delegate

extension RunwayScreen: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else { return true }

        if !text.isEmpty && (text != runway.title) {
            runway.title = text

            FirebaseManager.shared.updateRunway(runway) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(_): break
                case .failure(let error): self.presentErrorAlert(message: error.rawValue)
                }
            }
        }

        editTitleField.isHidden = true
        updateTitleView(text: self.runway.title)

        return textField.resignFirstResponder()
    }
}

// MARK: - Previews

#if DEBUG
struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayScreen(runway: Runway(title: "Wedding Outfit 2021")))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
