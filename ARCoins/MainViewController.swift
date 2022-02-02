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
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var arView: ARView!
    var animUpdateSubscription: [Cancellable?] = []
    var coins: [Coin] = []
    var bombs: [Bomb] = []
    var score: Int = 0
    var touchedCoin: Int = 0
    var touchedBomb: Int = 0
    var timer: Int = 60
    
    var timerCoin: Timer!
    var timerBomb: Timer!
    var timerGame: Timer!
    
    // Initialisation des timers
    override func viewDidLoad() {
        super.viewDidLoad()
        timerCoin = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(createCoin), userInfo: nil, repeats: true)
        
        timerBomb = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(createBomb), userInfo: nil, repeats: true)
        
        timerGame = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerManager), userInfo: nil, repeats: true)
        
    }
    
    // Création des objets en fonction du timer
    @objc func createCoin() {
        let coin = Coin(arView: self.arView)
        self.coins.append(coin)
    }
    
    @objc func createBomb() {
        let bomb = Bomb(arView: self.arView)
        self.bombs.append(bomb)
    }
    
    // Temps global du jeu
    @objc func timerManager() {
        self.timer -= 1
        self.timerLabel.text = "Temps : \(self.timer)"
        if self.timer == 0 {
            self.timerCoin.invalidate()
            self.timerBomb.invalidate()
            self.timerGame.invalidate()
            self.dismiss(animated: true, completion: nil)
            let vc = EndGameViewController.newInstance(coin: self.touchedCoin, bomb: self.touchedBomb, score: self.score)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // Lors d'un appui sur l'écran
    @IBAction func onTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: arView)
        
        // Si on touche une entité
        if let hitEntity = arView.entity(at: tapLocation) {
            // Si c'est une pièce
            for coin in self.coins {
                if coin.anchor == hitEntity.anchor {
                    print("coin touché")
                    self.score += 1
                    self.touchedCoin += 1
                    self.scoreLabel.text = "Score : \(self.score)"
                    coin.createScore()
                    coin.removeCoin()
                    return
                }
            }
            
            // Si c'est une bombe
            for bomb in self.bombs {
                if bomb.anchor == hitEntity.anchor {
                    print("bomb touché")
                    self.score -= 3
                    self.touchedBomb += 1
                    self.scoreLabel.text = "Score : \(self.score)"
                    bomb.createScore()
                    bomb.removeBomb()
                    return
                }
            }
        }
    }
}
