//
//  AppDelegate.swift
//  EduardoHiggorMarcusSergioSergio
//
//  Created by Eduardo Silva on 04/10/22.
//

import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let toyTableViewController = storyboard.instantiateViewController(withIdentifier: "ToyTableViewController")
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.viewControllers = [toyTableViewController]
        window?.rootViewController = navigationController
        
        return true
    }
}
