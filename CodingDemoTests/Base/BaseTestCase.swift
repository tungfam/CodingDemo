//
//  BaseTestCase.swift
//  CodingDemoTests
//
//  Created by Tung Fam on 10/30/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import CodingDemo

class BaseTestCase: XCTestCase {

    var testScheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        testScheduler = TestScheduler(initialClock: 0)
    }
}
