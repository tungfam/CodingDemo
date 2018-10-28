//
//  NumbersFactsViewModelTests.swift
//  CodingDemoTests
//
//  Created by Tung Fam on 10/25/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CodingDemo

class NumbersFactsViewModelTests: XCTestCase {

    private var viewModel: NumbersFactsViewModel!
    private var testScheduler: TestScheduler!
    private var disposeBag: DisposeBag!
    private var numbersServiceMock: NumbersServiceMock!

    override func setUp() {
        testScheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        numbersServiceMock = NumbersServiceMock()
        viewModel = NumbersFactsViewModel(numbersService: numbersServiceMock)
    }

    override func tearDown() {

    }

    func test_correctAlertAppearance_onTriviaButtonTap_withEmptyInput() {
        let emptyNumberInput = testScheduler.createColdObservable([Recorded.next(50, "")])
            .asObservable()

        let triviaButtonTap = testScheduler.createColdObservable([Recorded.next(100, ())])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: emptyNumberInput,
                triviaButtonTap: triviaButtonTap
            )
            return outputs.props
        }
        .events

        let expectedError = CustomError.input(message: "Please, input some number! For example, your favorite one :)")
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)
    }

    func test_correctAlertAppearance_onMathButtonTap_withEmptyInput() {
        let emptyNumberInput = testScheduler.createColdObservable([Recorded.next(50, "")])
            .asObservable()

        let mathButtonTap = testScheduler.createColdObservable([Recorded.next(200, ())])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: emptyNumberInput,
                mathButtonTap: mathButtonTap
            )
            return outputs.props
            }
            .events

        let expectedError = CustomError.input(message: "Please, input some number! For example, your favorite one :)")
        let expectedEvents = [
            Recorded.next(400, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)
    }

    func test_correctAlertAppearance_onMathButtonTap_withInvalidInput() {
        let invalidNumberInput = testScheduler.createColdObservable(
            [Recorded.next(50, "characters input"),
             Recorded.next(150, "123.45")]
            )
            .asObservable()

        let mathButtonTap = testScheduler.createColdObservable([
            Recorded.next(100, ()),
            Recorded.next(200, ())
            ])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: invalidNumberInput,
                mathButtonTap: mathButtonTap
            )
            return outputs.props
            }
            .events

        let expectedError = CustomError.input(message: "Please, input a number! For example, a 5 :)")
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            )),
            Recorded.next(400, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)
    }

    func test_correctAlertAppearance_onTriviaButtonTap_withInvalidInput() {
        let invalidNumberInput = testScheduler.createColdObservable([
            Recorded.next(50, "characters input"),
            Recorded.next(150, "123.45")
            ])
            .asObservable()

        let triviaButtonTap = testScheduler.createColdObservable([
            Recorded.next(100, ()),
            Recorded.next(200, ())
            ])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: invalidNumberInput,
                triviaButtonTap: triviaButtonTap
            )
            return outputs.props
            }
            .events

        let expectedError = CustomError.input(message: "Please, input a number! For example, a 5 :)")
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            )),
            Recorded.next(400, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)
    }

    func test_correctAlertAppearance_onNetworkError_withValidInputAndTap() {
        numbersServiceMock.returnedNumberFact = Observable.error(CustomError.networking(message: "Network error"))

        let invalidNumberInput = testScheduler.createColdObservable([Recorded.next(50, "10")])
            .asObservable()

        let triviaButtonTap = testScheduler.createColdObservable([Recorded.next(100, ())])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: invalidNumberInput,
                triviaButtonTap: triviaButtonTap
            )
            return outputs.props
            }
            .events

        let expectedError = CustomError.input(message: "Network error")
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(true)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(false)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.alert(error: expectedError)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)
    }

    func test_correctFactAppearance_onTriviaButtonTap_withValidInput() {

        // The values `factNumber` and `factText` are created in order to test
        // that was I stub is actually later presented

        let factNumber = 5
        let factText = "Trivia Fact Text"

        let stubbedNumberFact = NumberFact(type: .trivia, text: factText, number: factNumber)
        numbersServiceMock.returnedNumberFact = Observable.just(stubbedNumberFact)

        let validNumberInput = testScheduler.createColdObservable([Recorded.next(50, "\(factNumber)")])
            .asObservable()

        let triviaButtonTap = testScheduler.createColdObservable([Recorded.next(100, ())])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: validNumberInput,
                triviaButtonTap: triviaButtonTap
            )
            return outputs.props
            }
            .events

        let expectedFactViewData = NumberFactViewData(numberFact: stubbedNumberFact)
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(true)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(false)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.showFact(expectedFactViewData)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)

        guard let lastElement = resultEvents.last?.value.element
            else { XCTFail("result events have no events. but should have"); return }

        switch lastElement.state {
        case .showFact(let factViewData):
            XCTAssertEqual(factViewData.title, "Trivia fact about \(factNumber)")
            XCTAssertEqual(factViewData.text, factText)
        default:
            XCTFail("last element is not showFact type. but should be showFact type")
        }
    }

    func test_correctFactAppearance_onMathButtonTap_withValidInput() {

        // The values `factNumber` and `factText` are created in order to test
        // that was I stub is actually later presented

        let factNumber = 5
        let factText = "Math Fact Text"

        let stubbedNumberFact = NumberFact(type: .math, text: factText, number: factNumber)
        numbersServiceMock.returnedNumberFact = Observable.just(stubbedNumberFact)

        let validNumberInput = testScheduler.createColdObservable([Recorded.next(50, "\(factNumber)")])
            .asObservable()

        let triviaButtonTap = testScheduler.createColdObservable([Recorded.next(100, ())])
            .asObservable()

        let resultEvents = testScheduler.start { [unowned self] () -> Observable<NumbersFactsViewController.Props> in
            let outputs = self.bindViewModel(
                viewModel: self.viewModel,
                numberInput: validNumberInput,
                triviaButtonTap: triviaButtonTap
            )
            return outputs.props
            }
            .events

        let expectedFactViewData = NumberFactViewData(numberFact: stubbedNumberFact)
        let expectedEvents = [
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(true)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.isLoading(false)
            )),
            Recorded.next(300, NumbersFactsViewController.Props(
                state: NumbersFactsViewController.Props.State.showFact(expectedFactViewData)
            ))
        ]

        XCTAssertEqual(resultEvents, expectedEvents)

        guard let lastElement = resultEvents.last?.value.element
            else { XCTFail("result events have no events. but should have"); return }

        switch lastElement.state {
        case .showFact(let factViewData):
            XCTAssertEqual(factViewData.title, "Math fact about \(factNumber)")
            XCTAssertEqual(factViewData.text, factText)
        default:
            XCTFail("last element is not showFact type. but should be showFact type")
        }
    }
}

extension NumbersFactsViewModelTests {
    private func bindViewModel(
        viewModel: NumbersFactsViewModel,
        numberInput: Observable<String> = .empty(),
        triviaButtonTap: Observable<Void> = .empty(),
        mathButtonTap: Observable<Void> = .empty()
        ) -> NumbersFactsViewModel.Outputs {

        let inputs = NumbersFactsViewModel.Inputs(
            numberInput: numberInput,
            triviaButtonTap: triviaButtonTap,
            mathButtonTap: mathButtonTap
        )

        return viewModel.makeOutputs(from: inputs)
    }
}
