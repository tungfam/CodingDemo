//
//  NumbersFactsViewModel.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import RxSwift

final class NumbersFactsViewModel {

    // MARK: Nested Structs

    struct Inputs {
        let numberInput: Observable<String>
        let triviaButtonTap: Observable<Void>
        let mathButtonTap: Observable<Void>
    }

    struct Outputs {
        let props: Observable<NumbersFactsViewController.Props>
    }

    // MARK: - Private Properties

    private let numbersService: NumbersServiceProtocol

    // MARK: - Initialization

    init(numbersService: NumbersServiceProtocol) {
        self.numbersService = numbersService
    }

    // MARK: - Public Methods

    func makeOutputs(from inputs: Inputs) -> Outputs {

        let errorSubject = PublishSubject<Error>()

        // Is Loading
        let isLoadingSubject = PublishSubject<Bool>()
        let isLoadingState = isLoadingSubject.map { NumbersFactsViewController.Props.State.isLoading($0) }

        // Fact
        let numberInput = inputs.numberInput
            .share()

        let triviaTap = inputs.triviaButtonTap.map { _ in NumberFactType.trivia }
        let mathTap = inputs.mathButtonTap.map { _ in NumberFactType.math }

        let factTap = Observable.merge(triviaTap, mathTap)

        let emptyNumberErrorMessage = factTap
            .withLatestFrom(numberInput)
            .filter { $0.isEmpty }
            .map { _ in "Please, input some number! For example, your favorite one :)" }

        let wrongNumberErrorMessage = factTap
            .withLatestFrom(numberInput)
            .filter { !$0.isEmpty }
            .filter { Int($0) == nil }
            .map { _ in "Please, input a number! For example, a 5 :)" }

        let showFactState = factTap
            .withLatestFrom(numberInput) { (factType, numberInput) -> (NumberFactType, Int)? in
                guard let intNumber = Int(numberInput) else { return nil }
                return (factType, intNumber)
            }
            .ignoreNil()
            .do(onNext: { _ in isLoadingSubject.onNext(true) })
            .flatMap { [unowned self] (factType, number) -> Observable<NumberFact> in
                return self.numbersService.getFact(number: number, type: factType)
                    .catchError({ error -> Observable<NumberFact> in
                        isLoadingSubject.onNext(false)
                        errorSubject.onNext(error)
                        return Observable.empty()
                    })
            }
            .map { NumbersFactsViewController.Props.State.showFact(NumberFactViewData(numberFact: $0)) }
            .do(onNext: { _ in isLoadingSubject.onNext(false) })

        // Alert
        let networkError = errorSubject.map { (error: Error) -> CustomError in
            if let customError = error as? CustomError {
                return CustomError.networking(message: customError.localizedDescription)
            } else {
                return CustomError.networking(message: error.localizedDescription)
            }
        }

        let inputError = Observable
            .merge(emptyNumberErrorMessage, wrongNumberErrorMessage)
            .map { CustomError.input(message: $0) }

        let alertState = Observable
            .merge(inputError, networkError)
            .map { NumbersFactsViewController.Props.State.alert(error: $0) }

        let props = Observable
            .merge(isLoadingState, alertState, showFactState)
            .map(NumbersFactsViewController.Props.init)

        return Outputs(props: props)
    }

}
