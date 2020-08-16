import SceneKit

public class GameScene: SCNScene, SCNPhysicsContactDelegate {
    
    var player: SCNNode? {
        rootNode.childNode(withName: "player", recursively: true)
    }
    
    var exit: SCNNode? {
        rootNode.childNode(withName: "exit", recursively: true)
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
    
    var playerHitExit: Bool {
        guard let player = player, let exit = exit else {
            return false
        }
        return physicsWorld.contactTestBetween(player.physicsBody!, exit.physicsBody!, options: nil).count > 0
    }
    
    var playerInTheDark: Bool {
        return spotLightsPlayerFallsUnder.count == 0
    }
    
    func update(_ time: TimeInterval) {
        player?.runAction(.moveBy(x: xSpeed, y: 0, z: zSpeed, duration: 0.1))
        if playerInTheDark {
            print("You lost!")
            player?.position = .init(x: 0.13777577877044678, y: 0.7823623418807983, z: 3.761770725250244)
        } else if playerHitExit {
            print("You won!")
            player?.position = .init(x: 0.13777577877044678, y: 0.7823623418807983, z: 3.761770725250244)
        }
    }
    
    let speed: CGFloat = 0.03
    var zSpeed: CGFloat = 0
    var xSpeed: CGFloat = 0
    
    public func keyDown(with event: NSEvent) {
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
    }
    
    public func keyUp(with event: NSEvent) {
        if event.keyCode == 17 {
            zSpeed = 0
        }
        if event.keyCode == 5 {
            zSpeed = 0
        }
        if event.keyCode == 3 {
            xSpeed = 0
        }
        if event.keyCode == 4 {
            xSpeed = 0
        }
    }
        
}
