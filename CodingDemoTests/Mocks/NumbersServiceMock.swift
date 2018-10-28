//
//  NumbersServiceMock.swift
//  CodingDemoTests
//
//  Created by Tung Fam on 10/27/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

@testable import CodingDemo
import RxSwift

class NumbersServiceMock: NumbersServiceProtocol {

    var returnedNumberFact: Observable<NumberFact> = .empty()

    func getFact(number: Int, type: NumberFactType) -> Observable<NumberFact> {
        return returnedNumberFact
    }

}
