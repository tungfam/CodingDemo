//
//  NumbersFactsViewController.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import UIKit

final class NumbersFactsViewController: BaseViewController {

    // MARK: Nested Structs

    struct Props {
        enum State {
            case isLoading(Bool)
            case alert(error: Error)
            case showFact(NumberFactViewData)
        }

        let state: State
    }

    // MARK: - Private Properties

    private let viewModel: NumbersFactsViewModel
    private let wordsGenerator: WordsGeneratorProtocol

    // MARK: - Initialization

    init(numbersFactsViewModel: NumbersFactsViewModel,
         wordsGenerator: WordsGeneratorProtocol) {
        self.viewModel = numbersFactsViewModel
        self.wordsGenerator = wordsGenerator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupTapAnywhereToHideKeyboard()
    }

    // MARK: - Private Methods

    private func bindViewModel() {
        guard let view = self.view as? NumbersFactsView
            else {
                assertionFailure("The view type should be NumbersFactsView")
                return
        }

        let inputs = NumbersFactsViewModel.Inputs(
            numberInput: view.rx.numberInput,
            triviaButtonTap: view.rx.triviaFactTap,
            mathButtonTap: view.rx.mathFactTap
        )

        let outputs = viewModel.makeOutputs(from: inputs)

        outputs.state
            .observeForUI()
            .subscribe(onNext: { [unowned self] props in
                self.render(state: props.state)
            })
            .disposed(by: disposeBag)
    }

    private func render(state: Props.State) {
        switch state {
        case .isLoading(let isLoading): toggleLoader(isLoading)
        case .alert(let error): showErrorAlert(error: error)
        case .showFact(let fact): showFact(fact)
        }
    }

    private func showFact(_ factViewData: NumberFactViewData) {
        showAlert(
            title: factViewData.title,
            message: factViewData.text,
            buttonTitle: wordsGenerator.generateNumberFactReactionWord()
        )
    }
}
