//
//  AppDelegate.swift
//  ITSME
//
//  Created by Hansen Yudistira on 03/01/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    internal func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

