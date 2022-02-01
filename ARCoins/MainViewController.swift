//
//  ViewController.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 24/01/2022.
//

import UIKit
import RealityKit
import ARKit
import Combine

class MainViewController: UIViewController {
    
    @IBOutlet weak var arView: ARView!
    var animUpdateSubscription: [Cancellable?] = []
    var coins: [Coin] = []
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createCoin), userInfo: nil, repeats: true)
    }
    
    @objc func createCoin() {
        let coin = Coin(arView: self.arView)
        self.coins.append(coin)
    }
    
    func createScore(hitEntity: Entity) {
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0))
        let text = MeshResource.generateText("+1", extrusionDepth: 0.01, font: .systemFont(ofSize: 0.10), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        let shader = UnlitMaterial(color: .yellow)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        anchor.addChild(textEntity)
        textEntity.position = hitEntity.position(relativeTo: nil)
        textEntity.position.y += 0.1
        textEntity.position.x -= 0.2
        textEntity.look(at: arView.cameraTransform.translation, from: textEntity.position(relativeTo: nil), relativeTo: nil)
        textEntity.transform.rotation *= simd_quatf(angle: .pi, axis: [0, 1, 0])
        arView.scene.addAnchor(anchor)
        
        var transform = textEntity.transform
        transform.translation.y += 0.1
        textEntity.move(to: transform, relativeTo: textEntity.parent, duration: 0.5, timingFunction: .linear)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.arView.scene.removeAnchor(anchor)
        }
    }
    
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        
        if let hitEntity = arView.entity(at: tapLocation) {
            print("touched")
            print(hitEntity)
            createScore(hitEntity: hitEntity)
            for coin in coins {
                if coin.coin == hitEntity {
                    self.score += 1
                    coin.removeCoin()
                }
            }
            //arView.scene.removeAnchor(hitEntity.anchor!)
            
            
        }
        else {
            print("nothing...")
        }
    }
    
}
