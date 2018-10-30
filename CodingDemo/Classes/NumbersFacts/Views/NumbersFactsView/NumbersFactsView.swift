//
//  NumbersFactsView.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class NumbersFactsView: UIView {

    // MARK: - Private Properties

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var numberInputTextField: UITextField!
    @IBOutlet fileprivate weak var triviaButton: UIButton!
    @IBOutlet fileprivate weak var mathButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        setupAccessabilityIdentifiers()
    }

    // MARK: - Private Methods

    private func setup() {
        descriptionLabel.text = "Find out an interesting fact about a given number!"
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        numberInputTextField.keyboardType = .numberPad
        numberInputTextField.placeholder = "Enter any number"

        triviaButton.setTitle("Trivia fact 🧐", for: .normal)

        mathButton.setTitle("Math fact 🤓", for: .normal)

        [triviaButton, mathButton].forEach { button in
            button?.tintColor = .berry
        }
    }

    // MARK: - Public Methods

    func openKeyboard() {
        numberInputTextField.becomeFirstResponder()
    }
}

extension Reactive where Base: NumbersFactsView {
    var numberInput: Observable<String> {
        return base.numberInputTextField.rx.text.asObservable().ignoreNil()
    }

    var triviaFactTap: Observable<Void> {
        return base.triviaButton.rx.tap.asObservable()
    }

    var mathFactTap: Observable<Void> {
        return base.mathButton.rx.tap.asObservable()
    }
}

extension NumbersFactsView {
    private func setupAccessabilityIdentifiers() {
        self.accessibilityIdentifier = "NumbersFactsView"
        numberInputTextField.accessibilityIdentifier = "NumberInputTextField"
        mathButton.accessibilityIdentifier = "MathButton"
        triviaButton.accessibilityIdentifier = "TriviaButton"
    }
}
