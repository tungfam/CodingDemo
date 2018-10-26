//
//  AppDelegate.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/25/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Public Properties

    var window: UIWindow?

    // MARK: - Private Properties

    var appCoordinator: AppCoordinator!

    private let tracker = Tracker()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {

        setupAppearance()
        showApp()

        return true
    }
}

extension AppDelegate {
    // MARK: Private methods

    private func showApp() {
        window = UIWindow()
        guard let window = window
            else {
                tracker.track(event: "Wrong logic: window can't be nil")
                assertionFailure("Wrong logic: window can't be nil")
                return
        }

        appCoordinator = AppCoordinator(window: window)

        appCoordinator.start()
    }

    private func setupAppearance() {
        UITabBar.appearance().tintColor = .berry
    }
}
