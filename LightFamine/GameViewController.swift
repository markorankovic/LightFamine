//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
        
    let scene = GameScene(named: "art.scnassets/scene4.scn")!
    var player: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        
        player = scene.rootNode.childNode(withName: "player", recursively: true)
    }
    
    override func keyDown(with event: NSEvent) {
        print(event.keyCode)
        var speed: CGFloat = 0
        if event.keyCode == 12 {
            speed = -1
        }
        if event.keyCode == 14 {
            speed = 1
        }
        player?.runAction(.moveBy(x: 0, y: 0, z: speed, duration: 0.1))
    }
    
    override func keyUp(with event: NSEvent) {
        print(1)
    }
        
}
