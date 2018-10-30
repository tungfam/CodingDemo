//
//  NumbersFactsScreenUITests.swift
//  NumbersFactsScreenUITests
//
//  Created by Tung Fam on 10/30/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import XCTest

class NumbersFactsScreenUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    // One function will contain all the tests for NumbersFacts scree to save time
    func test_numbers_facts_showing_for_number_input() {

        let numbersFactsView = app.otherElements["NumbersFactsView"]

        // Test if view exists
        XCTAssertTrue(numbersFactsView.exists)

        // Test if keyboard is opened initially
        XCTAssertTrue(app.keyboards.count == 1)

        // Test if keyboard closes after taping anywhere
        app.tap()

        XCTAssertTrue(app.keyboards.count == 0)

        // Test appearing alert for an empty input and taping math/trivia button
        let mathButton = app.buttons["MathButton"]
        mathButton.tap()

        let emptyInputAlert = app.alerts["Oops!"]
        XCTAssertTrue(emptyInputAlert.exists)

        let emptyAlertText = emptyInputAlert.staticTexts["Please, input some number! For example, your favorite one :)"]
        XCTAssertTrue(emptyAlertText.exists)

        app.tap()

        let noAlertsShown = app.alerts.firstMatch
        XCTAssertTrue(noAlertsShown.alerts.count == 0)

        // Test appearing alert for wrong input and taping math/trivia button
        let textField = app.textFields["NumberInputTextField"]
        textField.tap()
        textField.typeText("qwerty")

        mathButton.tap()

        let wrongInputAlert = app.alerts["Oops!"]
        XCTAssertTrue(emptyInputAlert.exists)

        let wrongAlertText = wrongInputAlert.staticTexts["Please, input a number! For example, a 5 :)"]
        XCTAssertTrue(wrongAlertText.exists)

        app.tap()

        XCTAssertTrue(noAlertsShown.alerts.count == 0)

        // Test appearing the fact about a valid number

        let inputNumber = "10"

        textField.tap()
        textField.clearAndEnterText(text: inputNumber)

        mathButton.tap()

        // Sometimes it fails sometimes not. Sounds like Xcode issue
//        XCTAssertTrue(app.activityIndicators.count == 1)

        let mathFactAlert = app.alerts["Math fact about \(inputNumber)"]
        XCTAssertTrue(mathFactAlert.waitForExistence(timeout: 5))

        XCTAssertTrue(app.activityIndicators.count == 0)

        app.tap()

        let triviaButton = app.buttons["TriviaButton"]
        triviaButton.tap()

        // Sometimes it fails sometimes not. Sounds like Xcode issue
//        XCTAssertTrue(app.activityIndicators.count == 1)

        let triviaFactAlert = app.alerts["Trivia fact about \(inputNumber)"]
        XCTAssertTrue(triviaFactAlert.waitForExistence(timeout: 5))

        XCTAssertTrue(app.activityIndicators.count == 0)

        app.tap()
    }

}
