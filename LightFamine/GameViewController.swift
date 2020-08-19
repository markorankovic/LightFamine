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
        cam.constraints = []
        let player = level.player!
        let constraint = SCNTransformConstraint.positionConstraint(inWorldSpace: true) { node, position in
            //let constrainedPosition = position
            if cam.position.z - player.position.z > 5 { cam.position.z = player.position.z + 5 }
            if cam.position.z - player.position.z < 2 { cam.position.z = player.position.z + 2 }
            
            if cam.position.x - player.position.x > 0.5 { cam.position.x = player.position.x }
            if cam.position.x - player.position.x < 0.5 { cam.position.x = player.position.x }
            return position
        }
        cam.constraints!.append(constraint)
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

    func presentScene(scene: GameScene) {
        _sceneView.scene = _level
        setUpCam(level: _level)
    }
    
    func nextLevel() {
        levelIndex = levelIndex % LevelSelectionScene.LEVEL_COUNT
        levelIndex += 1
        _level = GameScene(named: "art.scnassets/Levels/level\(levelIndex).scn")!

        _level.viewController = self

        presentScene(scene: _level)
    }

    func enterLevel(level: Int) {
        _level = GameScene(named: "art.scnassets/Levels/level\(level).scn")!
        
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
        
    }

}
