//
//  GameViewController.swift
//  LightFamine
//
//  Created by Marko Rankovic on 8/15/20.
//

import SceneKit
import QuartzCore

class GameViewController: NSViewController {
        
    var scene: SCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        scene = GameScene(named: "art.scnassets/scene.scn")!
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
                                
        setupNodes()
    }
    
    func setupNodes() {
        let playerNode = scene.rootNode.childNode(withName: "player", recursively: true)!
        print(playerNode)
    }
    
}
