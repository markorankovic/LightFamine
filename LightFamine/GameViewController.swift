//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit

extension SCNNode {
    
    func distanceTo2D(node: SCNNode) -> CGFloat {
        hypot(node.position.x - self.position.x, node.position.z - self.position.z)
    }
    
}

public class GameViewController: NSViewController, SCNSceneRendererDelegate {

    private var _sceneView: GameView {
        view as! GameView
    }
    
    private var _level: GameScene!
    
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        _level.update(time)
    }
    
    func setUpCameraConstraints() {
        let cam = _level.cam!
        let player = _level.player!
        cam.constraints = []
        let follow = SCNTransformConstraint.positionConstraint(inWorldSpace: true) { cam, p in
            let maxAllowedDist: CGFloat = 4
            let dist = cam.distanceTo2D(node: player)
            if dist > maxAllowedDist {
                var constrainedPosition = p
                let currentXDist = player.position.x - cam.position.x
                let currentZDist = player.position.z - cam.position.z
                let newXDist = maxAllowedDist * (currentXDist / dist)
                let newZDist = maxAllowedDist * (currentZDist / dist)
                constrainedPosition.x = player.position.x - newXDist
                constrainedPosition.z = player.position.z - newZDist
                constrainedPosition.y = player.position.y + 1.5
                return constrainedPosition
            }
            return p
        }
        cam.constraints?.append(follow)
    }

    public override func loadView() {
        //view = GameView()
        view = GameView(frame: .init(x: 0, y: 0, width: 800, height: 600))
    }
    
    func exitToMainMenu() {
        if let p = parent as? MainViewController {
            p.addChild(p.mainMenuViewController)
            p.view = p.mainMenuViewController.view
            removeFromParent()
            NSCursor.unhide()
        }
    }

    func presentScene(scene: GameScene) {
        view.window!.acceptsMouseMovedEvents = true
        setUpCameraConstraints()
        _sceneView.scene = _level
        //_level.returnToStart()
        //_level.flipTheDarkAndLight()
        NSCursor.hide()
    }
    
    func nextLevel() {
        levelIndex = levelIndex % LevelSelectionScene.LEVEL_COUNT
        levelIndex += 1
        _level = GameScene(named: "art.scnassets/Levels/level\(levelIndex).scn")!
        _level.viewController = self
        presentScene(scene: _level)
    }

    var debugging = false
    
    func enterLevel(level: Int) {
        if debugging {
            _level = GameScene(named: "art.scnassets/testLevel.scn")!
        } else {
            _level = GameScene(named: "art.scnassets/Levels/level\(level).scn")!
        }
        _level.viewController = self
        presentScene(scene: _level)
        levelIndex = level
    }

    public var levelIndex = 0

    public override func viewDidLoad() {
        super.viewDidLoad()
        view = _sceneView
        _sceneView.delegate = self
    }

    public override func keyDown(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyDown(with: event)
    }

    public override func keyUp(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyUp(with: event)
    }
    
    public override func mouseMoved(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.mouseMoved(with: event)
    }
    
    public override func mouseExited(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.mouseExited(with: event)

    }

}
