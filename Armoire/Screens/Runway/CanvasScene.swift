//
//  CanvasScene.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/24/21.
//

import SpriteKit

protocol CanvasSceneDelegate: class {
    func didTapBackground()
    func didTapItem(_ node: SKNode)
}

fileprivate enum CanvasObject: String {
    case border = "Border"
    case item = "Item"
}

class CanvasScene: SKScene {
    // MARK: - Properties

    let cameraNode = SKCameraNode()

    weak var canvasDelegate: CanvasSceneDelegate?

    // Item properties
    var highestNodeZPosition = CGFloat(0)
    var selectedItemBorderNode = SKShapeNode()
    var nodeIsSelected = false

    // Camera properties
    var previousCameraPoint = CGPoint.zero
    var previousCameraScale = CGFloat()
    var currentCameraScale = CGFloat(6)

    // MARK: - Overriden methods

    override func sceneDidLoad() {
        super.sceneDidLoad()
        configureCamera()
        createInitialNode()
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        configureGestures(view: view)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        var nodeFound = false

        for node in tappedNodes {
            nodeFound = true

            // Creates a border for a selected border
            if node.name == CanvasObject.border.rawValue {
                return
            }

            // Adds a new border if a node has not been selected yet
            if !nodeIsSelected {
                selectedItemBorderNode = createBorderNode(for: node)
                nodeIsSelected = true
                addChild(selectedItemBorderNode)
                canvasDelegate?.didTapItem(node)
            }
        }

        // Removes the selected item border node if the user taps the background
        if !nodeFound {
            removeChildren(in: [selectedItemBorderNode])
            nodeIsSelected = false
            canvasDelegate?.didTapBackground()
        }
    }

    // MARK: - Configurations

    func configureCamera() {
        camera = cameraNode
        cameraNode.position = CGPoint(x: frame.midX, y: frame.midY)
        cameraNode.setScale(currentCameraScale)
        addChild(cameraNode)
    }

    func configureGestures(view: SKView) {
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(panGestureAction))
        view.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction))
        view.addGestureRecognizer(pinchGesture)
    }

    func changeToDarkMode() {
        backgroundColor = .darkGray
    }

    func changeToLightMode() {
        backgroundColor = .systemGray5
    }

    // MARK: - Node methods

    func createInitialNode() {
        // TODO: May soon be deleted since this is for early testing
        let dressNode = SKSpriteNode(imageNamed: "PinkDress")
        dressNode.name = CanvasObject.item.rawValue
        dressNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(dressNode)
    }

    func createNewNode(for imageName: String) {
        let newNode = SKSpriteNode(imageNamed: imageName)
        newNode.name = CanvasObject.item.rawValue
        newNode.position = CGPoint(x: frame.midX, y: frame.midY)
        newNode.zPosition = highestNodeZPosition + 1
        highestNodeZPosition += 1
        addChild(newNode)
    }

    func createBorderNode(for node: SKNode) -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: node.frame.width, height: node.frame.height)
        let borderNode = SKShapeNode(rect: rect)

        // Border node configurations
        borderNode.name = CanvasObject.border.rawValue
        borderNode.strokeColor = UIColor.accentColor ?? .systemPurple
        borderNode.lineWidth = 20
        borderNode.position = CGPoint(x: node.frame.minX, y: node.frame.minY)
        borderNode.zPosition = 100

        return borderNode
    }

    // MARK: - Action methods

    func increaseNodeZPosition(for node: SKNode) {
        if node.zPosition == highestNodeZPosition {
            highestNodeZPosition += 1
            node.zPosition = highestNodeZPosition
        } else {
            node.zPosition += 1
        }
    }

    func decreaseNodeZPosition(for node: SKNode) {
        node.zPosition -= 1
    }

    func deleteNode(node: SKNode) {
        let fadeOutAnimation = SKAction.fadeOut(withDuration: 0.25)

        node.run(fadeOutAnimation) { [weak self] in
            guard let self = self else { return }
            self.removeChildren(in: [node])
        }

        selectedItemBorderNode.run(fadeOutAnimation) { [weak self] in
            guard let self = self else { return }
            self.removeChildren(in: [self.selectedItemBorderNode])
        }

        nodeIsSelected = false
    }

    // MARK: - Gesture methods

    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = camera else { return }

        if sender.state == .began {
            previousCameraScale = camera.xScale
        }

        let scale = previousCameraScale * 1 / sender.scale

        if scale > 1, scale < 20 {
            currentCameraScale = scale
            camera.setScale(scale)
        }
    }

    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        // The camera has a weak reference, so test it
        guard let camera = camera else { return }

        // If the movement just began, save the first camera position
        if sender.state == .began {
            previousCameraPoint = camera.position
        }

        // Perform the translation
        let translation = sender.translation(in: view)

        let newPosition = CGPoint(
            x: previousCameraPoint.x + translation.x * -1 * currentCameraScale,
            y: previousCameraPoint.y + translation.y * currentCameraScale
        )

        camera.position = newPosition
    }
}
