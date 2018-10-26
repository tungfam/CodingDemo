//
//  TabBarController.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

final class TabBarViewController: UITabBarController {

    // MARK: - Private Properties

    // MARK: - Initialization

    init() {

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // All the services can be taken from DIP
        let numbersService = NumbersService()
        let wordsGenerator = WordsGenerator()
        let numbersFactsViewModel = NumbersFactsViewModel(numbersService: numbersService)

        let numbersFactsViewController = NumbersFactsViewController(
            numbersFactsViewModel: numbersFactsViewModel,
            wordsGenerator: wordsGenerator
        )

        numbersFactsViewController.tabBarItem = UITabBarItem(
            title: "Numbers",
            image: #imageLiteral(resourceName: "numbers_tab").withRenderingMode(.alwaysOriginal),
            selectedImage: #imageLiteral(resourceName: "numbers_tab").withRenderingMode(.automatic)
        )

        viewControllers = [numbersFactsViewController]

        tabBar.isTranslucent = false
    }

}
