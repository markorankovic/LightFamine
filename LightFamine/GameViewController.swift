//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit

public class GameViewController: NSViewController, SCNSceneRendererDelegate {

    private var _sceneView: GameView {
        view as! GameView
    }
    
    private var _level: GameScene!
    
    func setUpCam(level: GameScene) {
        let cam = level.rootNode.childNode(withName: "camera", recursively: true)!
        let player = level.player!
        let constraint = SCNTransformConstraint.positionConstraint(inWorldSpace: true) { node, position in
            var constrainedPosition = position
            if cam.position.z - player.position.z > 5 { cam.position.z = player.position.z + 5 }
            if cam.position.z - player.position.z < 2 { cam.position.z = player.position.z + 2 }
            
            if cam.position.x - player.position.x > 0.5 { cam.position.x = player.position.x }
            if cam.position.x - player.position.x < 0.5 { cam.position.x = player.position.x }
            return constrainedPosition
        }
        cam.constraints?.append(constraint)
    }
    
    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        _level.update(time)
    }

    public override func loadView() {
        view = GameView()
    }
    
    func exitToMainMenu() {
        if let p = parent as? MainViewController {
            p.addChild(p.mainMenuViewController)
            p.view = p.mainMenuViewController.view
            removeFromParent()
        }
    }

    func nextLevel() {
        levelIndex = levelIndex % LevelSelectionScene.LEVEL_COUNT
        levelIndex += 1
        _level = GameScene(named: "art.scnassets/Levels/level\(levelIndex).scn")!

        _level.viewController = self

        _sceneView.scene = _level
    }

    func enterLevel(level: Int) {
        _level = GameScene(named: "art.scnassets/Levels/level\(level).scn")!
        
        _level.viewController = self

        _sceneView.scene = _level
        
        levelIndex = level
        
        setUpCam(level: _level)
    }

    public var levelIndex = 0

    public override func viewDidLoad() {
        super.viewDidLoad()

        view = _sceneView

        //_sceneView.allowsCameraControl = true

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
        print(1)
    }

}
