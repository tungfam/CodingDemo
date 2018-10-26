//
//  NumberFactViewData.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import Foundation

struct NumberFactViewData {

    private let numberFact: NumberFact

    init(numberFact: NumberFact) {
        self.numberFact = numberFact
    }

    var title: String {
        switch numberFact.type {
        case .math: return "Math fact about \(numberFact.number)"
        case .trivia: return "Trivia fact about \(numberFact.number)"
        }
    }

    var text: String {
        return numberFact.text
    }

}
