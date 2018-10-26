//
//  AppCoordinator.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

final class AppCoordinator {

    // MARK: - Private Properties

    private let window: UIWindow

    // MARK: - Initialization

    init(window: UIWindow) {
        self.window = window
        setup()
    }

    // MARK: - Private Methods

    private func setup() {
        window.makeKeyAndVisible()
    }

    // MARK: - Public Methods

    func start() {
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController
    }

}
