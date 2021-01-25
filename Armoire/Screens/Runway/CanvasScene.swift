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
    weak var canvasDelegate: CanvasSceneDelegate?
    var selectedItemBorderNode = SKShapeNode()

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        createInitialNode()
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

    func createInitialNode() {
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
        borderNode.strokeColor = UIColor.accentColor!
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
}
