//
//  AppDelegate.swift
//  ARCoins
//
//  Created by Thibault BALSAMO on 24/01/2022.
//

import UIKit
import ARKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Permet de ne pas utiliser le storyboard
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UINavigationController(rootViewController: MenuViewController())
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
    
    

}

