//
//  AppDelegate.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 02/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISceneDelegate {

    var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        let vc = ScanViewController()
        window!.rootViewController = vc
        
        return true
    }

}

