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
        print(cam!.constraints)
        if let v = player?.physicsBody?.velocity {
            let contacts = physicsWorld.contactTest(with: player!.physicsBody!, options: nil)
            if round(v.y) == 0 && contacts.count > 0 {
                alreadyJumped = false
            } else {
                alreadyJumped = true
            }
        }
        run()
        let condition = (playerOutOfBounds && !flipped)
        if condition {
            print("You lost!")
            returnToStart()
        } else if playerHitExit {
            viewController?.nextLevel()
        }
    }
    
    var speed: CGFloat = 0.1
    var zSpeed: CGFloat = 0
    var xSpeed: CGFloat = 0
    var ySpeed: CGFloat = 0
        
    func run() {
        let angleBetween = atan2(player!.position.z - cam!.position.z, player!.position.x - cam!.position.x)
        var a: CGFloat = 0
        
        for key in movingKeys.filter({ $0.holding }) {
            switch key.direction {
            case .down: a = 4 * CGFloat.pi/2; speed = -0.1
            case .left: a = CGFloat.pi/2; speed = -0.1
            case .right: a = CGFloat.pi/2; speed = 0.1
            default: a = 0; speed = 0.1
            }
            player?.runAction(.move(by: .init(speed * cos(angleBetween + a), 0, speed * sin(angleBetween + a)), duration: 0.1))
        }
    }
    
    var alreadyJumped = false
    
    func jump() {
        if !alreadyJumped {
            player?.runAction(.moveBy(x: 0, y: 1, z: 0, duration: 0.1))
        }
    }
        
    class MovingKey {
        let key: String
        var holding: Bool = false
        let direction: Direction
        
        func press() {
            self.holding = true
        }
        
        func release() {
            self.holding = false
        }
        
        init(key: String, direction: Direction) {
            self.key = key
            self.direction = direction
        }
    }
    
    let movingKeys = [MovingKey(key: "W", direction: Direction.up), MovingKey(key: "A", direction: Direction.left), MovingKey(key: "S", direction: Direction.down), MovingKey(key: "D", direction: Direction.right)]
    
    public func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 13: movingKeys.filter { $0.key == "W" }.first?.press()
        case 1: movingKeys.filter { $0.key == "S" }.first?.press()
        case 0: movingKeys.filter { $0.key == "A" }.first?.press()
        case 2: movingKeys.filter { $0.key == "D" }.first?.press()
        case 49: jump()
        default: break
        }
    }
    
    public func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 13: movingKeys.filter { $0.key == "W" }.first?.release()
        case 1: movingKeys.filter { $0.key == "S" }.first?.release()
        case 0: movingKeys.filter { $0.key == "A" }.first?.release()
        case 2: movingKeys.filter { $0.key == "D" }.first?.release()
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
    
    public func mouseExited(with event: NSEvent) { }
            
}
