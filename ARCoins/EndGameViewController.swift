//
//  EndGameViewController.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 02/02/2022.
//

import UIKit

class EndGameViewController: UIViewController {
    @IBOutlet weak var coinTouchedLabel: UILabel!
    @IBOutlet weak var bombTouchedLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newRecord: UILabel!
    
    var coin: Int!
    var bomb: Int!
    var score: Int!
    
    // Instanciation de la classe en mettant les valeurs obtenue lors du jeu
    class func newInstance(coin: Int, bomb: Int, score: Int) -> EndGameViewController {
        let viewController = EndGameViewController()
        viewController.coin = coin
        viewController.bomb = bomb
        viewController.score = score
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Valeurs mise sur les labels
        self.coinTouchedLabel.text = "Vous avez obtenu : \(self.coin ?? 0) pièces !"
        self.bombTouchedLabel.text = "Vous avez touché : \(self.bomb ?? 0) bombes !"
        self.scoreLabel.text = "Pour un total de : \(self.score ?? 0) points !"
        
        if let bestScore = UserDefaults.standard.value(forKey: "bestScore") as? Int {
            if self.score > bestScore {
                self.newRecord.text = "Nouveau record !"
                UserDefaults.standard.set(score, forKey: "bestScore")
            }
            else {
                self.newRecord.text = ""
            }
        }
    }
    
    // Retour au menu principal
    @IBAction func backToMenuButton(_ sender: Any) {
        self.navigationController?.pushViewController(MenuViewController(), animated: true)
        self.dismiss(animated: true, completion: nil)
    }

}
