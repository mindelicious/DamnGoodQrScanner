//
//  AppDelegate.swift
//  DamnGoodQrScanner
//
//  Created by Mateusz Danieluk on 02/01/2020.
//  Copyright © 2020 Mateusz Danieluk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainViewController = ViewController()
        window!.rootViewController = mainViewController
        window!.makeKeyAndVisible()
        return true
    }

}

