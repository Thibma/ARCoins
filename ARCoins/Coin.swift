//
//  Coin.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 01/02/2022.
//

import Foundation
import ARKit
import RealityKit
import Combine

class Coin {
    
    public let anchor: AnchorEntity
    public var coin: Entity?
    
    private let arView: ARView
    
    var animUpdateSubscription: Cancellable?
    
    init(arView: ARView) {
        self.arView = arView
        self.anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0))
        self.coin = nil
        guard let entity = try? Entity.load(named: "coin") else {
            return
        }
        
        self.coin = entity
        
        self.coin!.setScale(SIMD3<Float>(0.002, 0.002, 0.002), relativeTo: anchor)
        self.coin!.generateCollisionShapes(recursive: true)
        
        anchor.addChild(self.coin!)
        
        let posx: Float = Float.random(in: -1.0...1.0)
        let posy: Float = Float.random(in: -1.0...1.0)
        let posz: Float = Float.random(in: -1.0...1.0)
        self.coin!.setPosition(SIMD3(posx, posy, posz), relativeTo: nil)
        arView.scene.addAnchor(anchor)
        animate(entity: self.coin!, angle: .pi, axis: [0, 1, 0], duration: 2, loop: true)
    }
    
    
    // Animation de la pièce
    func animate(entity: HasTransform,
                 angle: Float,
                 axis: SIMD3<Float>,
                 duration: TimeInterval,
                 loop: Bool) {
        var transform = entity.transform
        transform.rotation *= simd_quatf(angle: angle, axis: axis)
        entity.move(to: transform,
                    relativeTo: entity.parent,
                    duration: duration,
                    timingFunction: .linear)
        guard loop,
              animUpdateSubscription == nil
        else { return }
        animUpdateSubscription = self.arView.scene.subscribe(to: AnimationEvents.PlaybackCompleted.self,
            on: entity, { _ in
            self.animate(entity: entity,
                         angle: angle,
                         axis: axis,
                         duration: duration,
                         loop: loop)
        })
    }
    
    func removeCoin() {
        self.arView.scene.removeAnchor(self.anchor)
    }
}
