import SceneKit

public class GameScene: SCNScene, SCNPhysicsContactDelegate {
    
    enum Direction {
        case left
        case right
        case up
        case down
    }
    
    weak var viewController: GameViewController?
    
    var player: SCNNode? {
        rootNode.childNode(withName: "player", recursively: true)
    }
    
    var cam: SCNNode? {
        rootNode.childNode(withName: "camera", recursively: true)
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
    
    func flipTheDarkAndLight() {
        if !flipped {
            flipped = true
        }
    }
    
    var flipped = false
    
    func returnToStart() {
        player?.position = start?.position ?? .init()
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
        if (playerOutOfBounds && !flipped) || (!playerOutOfBounds && flipped) {
            print("You lost!")
            returnToStart()
        } else {
            if playerHitExit {
                viewController?.nextLevel()
            }
        }
    }
    
    var speed: CGFloat = 0
    var zSpeed: CGFloat = 0
    var xSpeed: CGFloat = 0
    var ySpeed: CGFloat = 0
        
    func run() {
        //player?.runAction(.moveBy(x: xSpeed, y: 0, z: zSpeed, duration: 0.1))
        let angleBetween = atan2(player!.position.z - cam!.position.z, player!.position.x - cam!.position.x)
        //let dist = hypot(player!.position.z - cam!.position.z, player!.position.x - cam!.position.x)
        //let sinRatio = (player!.position.z - cam!.position.z) / dist
        //let cosRatio = (player!.position.x - cam!.position.x) / dist
        var a: CGFloat = 0
        switch dir {
        case .down: a = 4 * CGFloat.pi/2
        case .left: a = CGFloat.pi/2
        case .right: a = CGFloat.pi/2
        default: a = 0
        }
        player?.runAction(.move(by: .init(speed * cos(angleBetween + a), 0, speed * sin(angleBetween + a)), duration: 0.1))
        //player?.physicsBody?.applyForce(.init(xSpeed, ySpeed, zSpeed), asImpulse: true)
    }
    
    var alreadyJumped = false
    
    func jump() {
        if !alreadyJumped {
            player?.runAction(.moveBy(x: 0, y: 1, z: 0, duration: 0.1))
        }
    }
    
    var dir: Direction = .up
    
    struct Key {
        let key: String
        var holding: Bool
    }
    
    let keys = []
    
    public func keyDown(with event: NSEvent) {
        print(event.keyCode)
        switch event.keyCode {
        case 13: speed = 0.1; dir = .up
        case 1: speed = -0.1; dir = .down
        case 0: speed = -0.1; dir = .left
        case 2: speed = 0.1; dir = .right
        case 49: jump()
        default: break
        }
    }
    
    public func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 13: speed = 0
        case 1: speed = 0
        case 0: speed = 0
        case 2: speed = 0
        case 53: viewController?.exitToMainMenu()
        default: break
        }
    }
    
    public func mouseMoved(with event: NSEvent) {
        cam?.constraints?.removeAll { $0 is SCNLookAtConstraint }
        cam?.rotate(by: .init(0, 0.01 * -event.deltaX, 0, 1), aroundTarget: player!.position)
        let lookAt = SCNLookAtConstraint(target: player)
        lookAt.isGimbalLockEnabled = true
        cam?.constraints?.append(lookAt)
    }
    
    public func mouseExited(with event: NSEvent) {
        print(5)
    }
        
}
