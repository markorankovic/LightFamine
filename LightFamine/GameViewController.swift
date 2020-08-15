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
        
        scene = GameScene(named: "art.scnassets/scene2.scn")!
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
                        
        // Add a click gesture recognizer
        let clickGesture = NSClickGestureRecognizer(
            target: self,
            action: #selector(handleClick(_:))
        )
        var gestureRecognizers = scnView.gestureRecognizers
        gestureRecognizers.insert(clickGesture, at: 0)
        scnView.gestureRecognizers = gestureRecognizers
        
        setupNodes()
    }
    
    func setupNodes() {
        let playerNode = scene.rootNode.childNode(withName: "player", recursively: true)!
        print(playerNode)
    }
    
    @objc
    func handleClick(_ gestureRecognizer: NSGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are clicked
        let p = gestureRecognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result = hitResults[0]
            
            // get its material
            let material = result.node.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = NSColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = NSColor.red
            
            SCNTransaction.commit()
        }
    }
}
