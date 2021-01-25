//
//  CanvasScene.swift
//  Armoire
//
//  Created by Geraldine Turcios on 1/24/21.
//

import SpriteKit

protocol CanvasSceneDelegate: class {
    func didTapItem(_ node: SKNode)
}

class CanvasScene: SKScene {
    let cameraNode = SKCameraNode()

    weak var canvasDelegate: CanvasSceneDelegate?
    var selectedItemBorderNode = SKShapeNode()

    // Camera properties
    var previousCameraPoint = CGPoint.zero
    var previousCameraScale = CGFloat()
    var currentCameraScale = CGFloat(6)

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
            if node.name == "SelectedItemBorder" {
                return
            }

            selectedItemBorderNode = createBorderNode(for: node)
            addChild(selectedItemBorderNode)
            canvasDelegate?.didTapItem(node)
        }

        // Removes the selected item border node if the user taps the background
        if !nodeFound {
            removeChildren(in: [selectedItemBorderNode])
        }
    }

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

    func createInitialNode() {
        // TODO: May soon be deleted since this is for early testing
        let dressNode = SKSpriteNode(imageNamed: "PinkDress")
        dressNode.name = "PinkDress"
        dressNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(dressNode)
    }

    func createBorderNode(for node: SKNode) -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: node.frame.width, height: node.frame.height)
        let borderNode = SKShapeNode(rect: rect)

        // Border node configurations
        borderNode.name = "SelectedItemBorder"
        borderNode.strokeColor = UIColor.accentColor ?? .systemPurple
        borderNode.lineWidth = 20
        borderNode.position = CGPoint(x: node.frame.minX, y: node.frame.minY)
        borderNode.zPosition = 100

        return borderNode
    }

    func changeToDarkMode() {
        backgroundColor = .darkGray
    }

    func changeToLightMode() {
        backgroundColor = .systemGray5
    }

    func deleteNode(node: SKNode) {
        removeChildren(in: [node, selectedItemBorderNode])
    }

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
