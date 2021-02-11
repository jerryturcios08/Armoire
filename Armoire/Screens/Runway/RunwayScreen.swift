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

    private var runway: String
    var selectedNode: SKNode?

    // MARK: - Initializers

    init(runway: String) {
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
        configureControlsToolbar()
        configureCanvasView()
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
        title = runway
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let closeButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonTapped))
        navigationItem.leftBarButtonItem = closeButton

        let exportButton = UIBarButtonItem(image: UIImage(systemName: "link"), style: .plain, target: self, action: #selector(exportButtonTapped))
        let addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addItemButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, exportButton]
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
        scene.size = CGSize(width: 1000, height: 1000)
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
    }

    // MARK: - Action methods

    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Exit", message: "Are you sure you want to close this runway? All progress will be saved.", preferredStyle: .alert)
        alertController.view.tintColor = UIColor.accentColor

        alertController.addAction(UIAlertAction(title: "Exit", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        })

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alertController, animated: true)
    }

    @objc func exportButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: Allow for sharing with another user to get feedback on a runway
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

    @objc func addItemButtonTapped(_ sender: UIBarButtonItem) {
        let itemSearchScreen = ItemSearchScreen()
        let destinationScreen = AMNavigationController(rootViewController: itemSearchScreen)
        itemSearchScreen.delegate = self
        destinationScreen.modalPresentationStyle = .fullScreen
        present(destinationScreen, animated: true)
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
}

// MARK: - Item search delegate

extension RunwayScreen: ItemSearchScreenDelegate {
    func didSelectClothingItem(_ clothing: Clothing) {
        guard let imageUrl = clothing.imageUrl else { return }

        do {
            let data = try Data(contentsOf: imageUrl)
            guard let image = UIImage(data: data) else { return }
            scene.createNewNode(for: image)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
}

// MARK: - Previews

#if DEBUG
struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            AMNavigationController(rootViewController: RunwayScreen(runway: "My Runway"))
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}
#endif
