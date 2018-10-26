//
//  BaseViewController.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {

    // MARK: - Public Methods

    let disposeBag = DisposeBag()

    // MARK: - Private Properties

    private let loader = UIActivityIndicatorView(style: .gray)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoader()
    }

    // MARK: - Private Methods

    private func setupLoader() {
        view.addSubview(loader)
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Public Methods

    func toggleLoader(_ show: Bool) {
        if show {
            view.bringSubviewToFront(loader)
            loader.startAnimating()
        } else {
            loader.stopAnimating()
        }
    }

    func showAlert(title: String, message: String, buttonTitle: String) {
        if presentedViewController?.isKind(of: UIAlertController.self) ?? false {
            return
        }

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: buttonTitle, style: .default)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }

    func showErrorAlert(error: Error) {
        let title = "Oops!"
        let buttonText = "OK"

        if let customError = error as? CustomError {
            showAlert(title: title, message: customError.localizedDescription, buttonTitle: buttonText)
        } else {
            showAlert(title: title, message: error.localizedDescription, buttonTitle: buttonText)
        }
    }

    func setupTapAnywhereToHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
}
