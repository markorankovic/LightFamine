//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit

public class GameViewController: NSViewController, SCNSceneRendererDelegate {

    private var _sceneView: SCNView {
        view as! SCNView
    }
    private var _level: GameScene!

    public func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        _level.update(time)
    }

    public override func loadView() {
        view = SCNView()
    }

    func nextLevel() {
        levelIndex = levelIndex % 5
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
    }

    public var levelIndex = 0

    public override func viewDidLoad() {
        super.viewDidLoad()

        view = _sceneView

        _sceneView.allowsCameraControl = true

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

}
