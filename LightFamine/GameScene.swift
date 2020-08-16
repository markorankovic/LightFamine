import SceneKit

public class GameScene: SCNScene, SCNSceneRendererDelegate {
    
    var player: SCNNode? {
        rootNode.childNode(withName: "player", recursively: true)
    }
    
    var spotLights: [SCNNode] {
        rootNode.childNodes.filter { $0.name == "spot" }
    }
    
    var spotLightsPlayerFallsUnder: [SCNNode] {
        spotLights.filter { spot in
            guard let player = player else {
                return false
            }
            let pC = player.position
            let pR = player.geometry!.boundingBox.max.x / 2
            let sC = spot.position
            let distanceToGround = abs(spot.position.y)
            let sR = (tan(spot.light!.spotOuterAngle / 2) * distanceToGround) / 2
            let dist = hypot(pC.x - sC.x, pC.z - sC.z)
            let combinedRadius = sR + pR
            return round(dist) <= round(combinedRadius)
        }
    }
    
    func evaluateBounds() {
        print("Spot lights: \(spotLights.compactMap { $0.light })")
    }
    
    public func keyDown(with event: NSEvent) {
        print(spotLightsPlayerFallsUnder.count)
        let speed: CGFloat = 0.1
        var zSpeed: CGFloat = 0
        var xSpeed: CGFloat = 0
        if event.keyCode == 17 {
            zSpeed = -speed
        }
        if event.keyCode == 5 {
            zSpeed = speed
        }
        if event.keyCode == 3 {
            xSpeed = -speed
        }
        if event.keyCode == 4 {
            xSpeed = speed
        }
        if event.keyCode == 49 {
            player?.position = .init(x: 0, y: 5, z: 0)
            player?.rotation = .init()
            player?.physicsBody?.angularVelocity = .init()
            player?.physicsBody?.velocity = .init()
        }
        player?.runAction(.moveBy(x: xSpeed, y: 0, z: zSpeed, duration: 0.1))
    }
        
}
