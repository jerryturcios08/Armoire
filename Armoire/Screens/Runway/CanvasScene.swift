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
    func didUpdate(_ itemNodes: [ItemNode])
}

fileprivate enum CanvasObject: String {
    case border = "Border"
    case item = "Item"
}

class CanvasScene: SKScene {
    // MARK: - Properties

    let cameraNode = SKCameraNode()

    var itemNodes = [ItemNode]()

    weak var canvasDelegate: CanvasSceneDelegate?

    // Item properties
    var selectedNode: SKNode?
    var highestNodeZPosition = CGFloat(-1)
    var previousNodePoint = CGPoint.zero
    var previousNodeScale = CGFloat()
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
                selectedNode = node
                selectedItemBorderNode = createBorderNode(for: node)
                nodeIsSelected = true
                addChild(selectedItemBorderNode)
                canvasDelegate?.didTapItem(node)
            }
        }

        // Removes the selected item properties if the user taps the background
        if !nodeFound {
            selectedNode = nil
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction))
        view.addGestureRecognizer(panGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinchGestureAction))
        view.addGestureRecognizer(pinchGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction))
        view.addGestureRecognizer(longPressGesture)
    }

    func changeToDarkMode() {
        backgroundColor = .canvasDarkModeBackground
    }

    func changeToLightMode() {
        backgroundColor = .canvasLightModeBackground
    }

    // MARK: - Node methods

    func loadNodes(_ nodes: [ItemNode]) {
        for node in nodes {
            guard let url = URL(string: node.imageUrl) else { return }

            let newNode: SKSpriteNode
            let nodeImage: UIImage

            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                nodeImage = image
            } catch {
                // Ignores the current node if the image cannot be found
                continue
            }

            newNode = SKSpriteNode(texture: SKTexture(image: nodeImage))
            newNode.name = node.id
            newNode.position = CGPoint(x: node.xPosition, y: node.yPosition)
            newNode.zPosition = CGFloat(node.zPosition)

            if let scale = node.scale {
                newNode.setScale(CGFloat(scale))
            }

            addChild(newNode)

            if CGFloat(node.zPosition) > highestNodeZPosition {
                highestNodeZPosition = CGFloat(node.zPosition)
            }

            itemNodes.append(node)
        }
    }

    func createNewNode(for image: UIImage, urlString: String) {
        let generatedId = UUID().uuidString + "-\(CanvasObject.item.rawValue)"
        let newNode = SKSpriteNode(texture: SKTexture(image: image))
        newNode.name = generatedId
        newNode.position = CGPoint(x: frame.minX, y: frame.minY)
        newNode.zPosition = highestNodeZPosition + 1
        highestNodeZPosition += 1
        addChild(newNode)

        // Creates a new item node to be synced with firebase
        let item = ItemNode(
            id: generatedId,
            imageUrl: urlString,
            xPosition: Double(newNode.position.x),
            yPosition: Double(newNode.position.y),
            zPosition: Double(newNode.zPosition)
        )
        itemNodes.append(item)
        canvasDelegate?.didUpdate(itemNodes)
    }

    func createBorderNode(for node: SKNode) -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: node.frame.width, height: node.frame.height)
        let borderNode = SKShapeNode(rect: rect)

        // Border node configurations
        borderNode.name = CanvasObject.border.rawValue
        borderNode.strokeColor = UIColor.accentColor ?? .systemPurple
        borderNode.lineWidth = 20
        borderNode.position = CGPoint(x: node.frame.minX, y: node.frame.minY)
        borderNode.zPosition = .greatestFiniteMagnitude

        return borderNode
    }

    // MARK: - Defined methods

    func increaseNodeZPosition(for node: SKNode) {
        if node.zPosition == highestNodeZPosition {
            highestNodeZPosition += 1
            node.zPosition = highestNodeZPosition
        } else {
            node.zPosition += 1
        }

        for (index, itemNode) in itemNodes.enumerated() {
            if itemNode.id == node.name {
                itemNodes[index].zPosition = Double(node.zPosition)
                canvasDelegate?.didUpdate(itemNodes)
            }
        }
    }

    func decreaseNodeZPosition(for node: SKNode) {
        node.zPosition -= 1

        for (index, itemNode) in itemNodes.enumerated() {
            if itemNode.id == node.name {
                itemNodes[index].zPosition = Double(node.zPosition)
                canvasDelegate?.didUpdate(itemNodes)
            }
        }
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

        for (index, itemNode) in itemNodes.enumerated() {
            if itemNode.id == node.name {
                nodeIsSelected = false
                itemNodes.remove(at: index)
                canvasDelegate?.didUpdate(itemNodes)
            }
        }
    }

    func deleteAllNodes() {
        itemNodes.removeAll()

        for node in children {
            guard let name = node.name else { continue }

            if name.contains("-Item") {
                node.removeFromParent()
            }
        }
    }

    // MARK: - Gesture methods

    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        if nodeIsSelected {
            guard let node = selectedNode else { return }

            if sender.state == .began {
                previousNodeScale = node.xScale
            }

            let scale = previousNodeScale * sender.scale

            if scale > 0.5, scale < 8 {
                node.setScale(scale)

                // Updates the item nodes array with the updated scale for the selected node
                for (index, itemNode) in itemNodes.enumerated() {
                    guard let name = node.name else { continue }

                    if itemNode.id.contains(name) {
                        itemNodes[index].scale = Double(scale)
                        canvasDelegate?.didUpdate(itemNodes)
                    }
                }
            }
        } else {
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
    }

    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        if nodeIsSelected {
            // Moves a selected item if that item was selected
            guard let node = selectedNode else { return }

            var touchLocation = sender.location(in: view)
            touchLocation = convertPoint(fromView: touchLocation)

            if sender.state == .changed {
                if previousNodePoint != CGPoint.zero {
                    let xDifference = -(touchLocation.x - previousNodePoint.x)
                    let yDifference = -(touchLocation.y - previousNodePoint.y)
                    let newPosition = CGPoint(x: node.position.x - xDifference, y: node.position.y - yDifference)

                    // Sets the position of the node and border based on the computations
                    node.position = newPosition
                    selectedItemBorderNode.position = CGPoint(x: node.frame.minX, y: node.frame.minY)

                    // Updates the item nodes array with the updated position for the selected node
                    for (index, itemNode) in itemNodes.enumerated() {
                        guard let name = node.name else { continue }

                        if itemNode.id.contains(name) {
                            itemNodes[index].xPosition = Double(newPosition.x)
                            itemNodes[index].yPosition = Double(newPosition.y)
                            canvasDelegate?.didUpdate(itemNodes)
                        }
                    }
                }

                previousNodePoint = touchLocation
            } else if sender.state == .ended {
                previousNodePoint = CGPoint.zero
            }
        } else {
            // Moves the camera if a node was not selected
            guard let camera = camera else { return }

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

    @objc func longPressGestureAction(_ sender: UILongPressGestureRecognizer) {
        guard let camera = camera else { return }
        camera.run(SKAction.moveTo(x: frame.minX, duration: 0.5))
        camera.run(SKAction.moveTo(y: frame.minY, duration: 0.5))
    }
}
