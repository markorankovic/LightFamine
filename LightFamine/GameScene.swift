import SceneKit

public class GameScene: SCNScene, SCNPhysicsContactDelegate {
    
    weak var viewController: GameViewController?
    
    var player: SCNNode? {
        rootNode.childNode(withName: "player", recursively: true)
    }
    
    var exit: SCNNode? {
        rootNode.childNode(withName: "exit", recursively: true)
    }
    
    var surface: SCNNode? {
        rootNode.childNode(withName: "surface", recursively: true)
    }
    
    var spotLights: [SCNNode] {
        rootNode.childNodes.filter { $0.name == "spot" }
    }
    
    var start: SCNNode? {
        rootNode.childNode(withName: "start", recursively: true)
    }
    
    var playerOnSurface: Bool {
        guard let player = player, let surface = surface else {
            return false
        }
        return physicsWorld.contactTestBetween(player.physicsBody!, surface.physicsBody!, options: nil).count > 0
    }
    
    var spotLightsPlayerFallsUnder: [SCNNode] {
        return spotLights.filter { spot in
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
    
    var playerOutOfBounds: Bool {
        guard playerOnSurface else {
            return false
        }
        return spotLightsPlayerFallsUnder.count == 0
    }
    
    func update(_ time: TimeInterval) {
        if let v = player?.physicsBody?.velocity {
            let contacts = physicsWorld.contactTest(with: player!.physicsBody!, options: nil)
            if round(v.y) == 0 && contacts.count > 0 {
                alreadyJumped = false
            } else {
                alreadyJumped = true
            }
        }
        run()
        if playerOutOfBounds {
            print("You lost!")
            player?.position = start?.position ?? .init()
        } else if playerHitExit {
            viewController?.nextLevel()
        }
    }
    
    let speed: CGFloat = 0.05
    var zSpeed: CGFloat = 0
    var xSpeed: CGFloat = 0
    var ySpeed: CGFloat = 0
        
    func run() {
        player?.runAction(.moveBy(x: xSpeed, y: 0, z: zSpeed, duration: 0.1))
        //player?.physicsBody?.applyForce(.init(xSpeed, ySpeed, zSpeed), asImpulse: true)
    }
    
    var alreadyJumped = false
    
    func jump() {
        if !alreadyJumped {
            player?.runAction(.moveBy(x: 0, y: 1, z: 0, duration: 0.1))
        }
    }
    
    public func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 17: zSpeed = -speed
        case 5: zSpeed = speed
        case 3: xSpeed = -speed
        case 4: xSpeed = speed
        case 49: jump()
        default: break
        }
    }
    
    public func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 17: zSpeed = 0
        case 5: zSpeed = 0
        case 3: xSpeed = 0
        case 4: xSpeed = 0
        default: break
        }
    }
        
}
