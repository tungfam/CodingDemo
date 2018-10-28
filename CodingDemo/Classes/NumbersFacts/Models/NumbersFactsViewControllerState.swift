//
//  NumbersFactsViewControllerState.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/27/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import Foundation

extension NumbersFactsViewController.Props {
    enum State: Equatable {
        case isLoading(Bool)
        case alert(error: Error)
        case showFact(NumberFactViewData)
    }
}

extension NumbersFactsViewController.Props.State {
    static func == (
        lhs: NumbersFactsViewController.Props.State,
        rhs: NumbersFactsViewController.Props.State
        ) -> Bool {
        switch lhs {
        case .alert(let leftError):
            switch rhs {
            case .alert(let rightError):
                if let leftCustomError = leftError as? CustomError,
                    let rightCustomError = rightError as? CustomError {
                    return leftCustomError.localizedDescription == rightCustomError.localizedDescription
                } else {
                    return leftError.localizedDescription == rightError.localizedDescription
                }
            default: return false
            }
        case .isLoading(let leftIsLoading):
            switch rhs {
            case .isLoading(let rightIsLoading): return leftIsLoading == rightIsLoading
            default: return false
            }
        case .showFact(let leftFaceViewData):
            switch rhs {
            case .showFact(let rightFaceViewData): return leftFaceViewData == rightFaceViewData
            default: return false
            }
        }
    }
}
