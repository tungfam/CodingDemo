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

//        let textField = app.textFields["NumberInputTextField"]
//        textField.typeText("")
    }

}
