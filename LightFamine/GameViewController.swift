//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController, SCNSceneRendererDelegate {
        
    private var _sceneView: SCNView!
    private var _level: GameScene!

    var sceneView: SCNView! {
        _sceneView
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didSimulatePhysicsAtTime time: TimeInterval) {
        _level.update(time)
    }
    
    func nextLevel() {
        levelIndex = levelIndex % 4
        levelIndex += 1
                            
        _level = GameScene(named: "art.scnassets/Levels/level\(levelIndex).scn")!
        
        _level.viewController = self
        
        _sceneView.scene = _level
    }
    
    public var levelIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _sceneView = SCNView()
        view = _sceneView
        
        _sceneView.allowsCameraControl = true
                
        _sceneView.delegate = self

        print(levelIndex)
                
        nextLevel()
    }
        
    override func keyDown(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyDown(with: event)
    }
    
    override func keyUp(with event: NSEvent) {
        let scnView = self.view as! SCNView
        (scnView.scene as? GameScene)?.keyUp(with: event)
    }
    
}
