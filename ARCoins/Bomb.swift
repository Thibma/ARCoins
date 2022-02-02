//
//  Bomb.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 02/02/2022.
//

import Foundation
import ARKit
import RealityKit
import Combine

// CLASSE BOMB -> Bombe
class Bomb {
    
    public let anchor: AnchorEntity
    public var bomb: Entity?
    
    private let arView: ARView
    
    var animUpdateSubscription: Cancellable?
    
    init(arView: ARView) {
        self.arView = arView
        self.anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0))
        self.bomb = nil
        // Model 3D :
        // https://sketchfab.com/3d-models/bomb-quick-practice-1631526a79b44d3a96382b1802a59fb7
        guard let entity = try? Entity.load(named: "bomb") else {
            return
        }
        
        self.bomb = entity
        
        self.bomb!.setScale(SIMD3<Float>(0.001, 0.001, 0.001), relativeTo: anchor)
        self.bomb!.generateCollisionShapes(recursive: true)
        
        anchor.addChild(self.bomb!)
        
        let posx: Float = Float.random(in: -1.0...1.0)
        let posy: Float = Float.random(in: -1.0...1.0)
        let posz: Float = Float.random(in: -1.0...1.0)
        self.bomb!.setPosition(SIMD3(posx, posy, posz), relativeTo: nil)
        arView.scene.addAnchor(anchor)
        animate(entity: self.bomb!, angle: .pi, axis: [0, 1, 0], duration: 2, loop: true)
    }
    
    
    // Animation de la bombe
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
    
    // Score de la bombe à la destruction
    func createScore() {
        let anchor = AnchorEntity(world: SIMD3<Float>(0, 0, 0))
        let text = MeshResource.generateText("-3", extrusionDepth: 0.01, font: .systemFont(ofSize: 0.10), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping)
        let shader = UnlitMaterial(color: .red)
        let textEntity = ModelEntity(mesh: text, materials: [shader])
        anchor.addChild(textEntity)
        textEntity.position = self.bomb!.position(relativeTo: nil)
        textEntity.position.y += 0.1
        //textEntity.position.x -= 0.15
        textEntity.look(at: self.arView.cameraTransform.translation, from: textEntity.position(relativeTo: nil), relativeTo: nil)
        textEntity.transform.rotation *= simd_quatf(angle: .pi, axis: [0, 1, 0])
        self.arView.scene.addAnchor(anchor)
        
        var transform = textEntity.transform
        transform.translation.y -= 0.1
        textEntity.move(to: transform, relativeTo: textEntity.parent, duration: 0.5, timingFunction: .linear)
        
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { timer in
            self.arView.scene.removeAnchor(anchor)
        }
    }
    
    // Destruction de la bombe
    func removeBomb() {
        self.arView.scene.removeAnchor(self.anchor)
    }
}

