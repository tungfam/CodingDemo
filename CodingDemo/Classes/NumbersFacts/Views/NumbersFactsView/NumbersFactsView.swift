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

    @IBOutlet fileprivate weak var numberInputTextField: UITextField!
    @IBOutlet fileprivate weak var triviaButton: UIButton!
    @IBOutlet fileprivate weak var mathButton: UIButton!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    // MARK: - Private Methods

    private func setup() {
        numberInputTextField.keyboardType = .numberPad

        triviaButton.setTitle("Trivia fact 🧐", for: .normal)

        mathButton.setTitle("Math fact 🤓", for: .normal)

        [triviaButton, mathButton].forEach { button in
            button?.tintColor = .berry
        }
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
