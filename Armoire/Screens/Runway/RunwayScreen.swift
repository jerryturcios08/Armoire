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
    let scene = CanvasScene()

    let undoButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left"), style: .plain, target: self, action: nil)
    let redoButton = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.right"), style: .plain, target: self, action: nil)
    let moveUpButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"), style: .plain, target: self, action: nil)
    let moveDownButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down"), style: .plain, target: self, action: nil)
    let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteButtonTapped))

    private var runway: String
    var selectedNode: SKNode?

    init(runway: String) {
        self.runway = runway
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        navigationController?.toolbar.isTranslucent = false

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)

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
        scene.size = view.frame.size
        scene.anchorPoint = CGPoint(x: 0, y: 0)
        // TODO: Need to determine how scene size will be handled
        scene.size = CGSize(width: 1000, height: 1000)
        scene.scaleMode = .aspectFill

        if traitCollection.userInterfaceStyle == .light {
            scene.backgroundColor = .systemGray5
        } else if traitCollection.userInterfaceStyle == .dark {
            scene.backgroundColor = .darkGray
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

    @objc func closeButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc func exportButtonTapped(_ sender: UIBarButtonItem) {
    }

    @objc func addItemButtonTapped(_ sender: UIBarButtonItem) {
        print("Hello")
    }

    @objc func deleteButtonTapped(_ sender: UIBarButtonItem) {
        // TODO: Figure out why this method does not fire when the button is tapped
        guard let node = selectedNode else { return }

        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to delete the selected item?", preferredStyle: .alert)

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

extension RunwayScreen: CanvasSceneDelegate {
    func didTapItem(_ node: SKNode) {
        selectedNode = node
        moveUpButton.isEnabled = true
        moveDownButton.isEnabled = true
        deleteButton.isEnabled = true
    }
}

#if DEBUG
struct RunwayScreenPreviews: PreviewProvider {
    static var previews: some View {
        Group {
            UIViewControllerPreview {
                AMNavigationController(rootViewController: RunwayScreen(runway: "My Runway"))
            }
        }
    }
}
#endif
