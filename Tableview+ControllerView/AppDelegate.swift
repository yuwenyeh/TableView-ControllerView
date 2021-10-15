//
//  AppDelegate.swift
//  Tableview+ControllerView
//
//  Created by etrovision on 2021/10/7.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   
        let rootVC = TableViewVC(nibName: String(describing: TableViewVC.self), bundle: nil)
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = rootVC
        self.window!.makeKeyAndVisible()
        
        return true
    }

    

}

