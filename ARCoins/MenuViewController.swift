//
//  MenuViewController.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 27/01/2022.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var bestScore: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Récupération du meilleur score dans les UserDefaults
        if let score = UserDefaults.standard.value(forKey: "bestScore") as? Int {
            self.bestScore.text = "Meilleur score : \(score)"
        }
        else {
            UserDefaults.standard.set(0, forKey: "bestScore")
        }

        // Do any additional setup after loading the view.
    }

    // Play
    @IBAction func playButton(_ sender: Any) {
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
