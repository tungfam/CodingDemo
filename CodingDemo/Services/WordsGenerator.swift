//
//  WordsGenerator.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import Foundation

protocol WordsGeneratorProtocol {
    func generateNumberFactReactionWord() -> String
}

class WordsGenerator: WordsGeneratorProtocol {
    func generateNumberFactReactionWord() -> String {
        return WordsGenerator.numberFactReactionWords.randomElement() ?? "OKAY!"
    }
}

extension WordsGenerator {
    static let numberFactReactionWords = [
        "Good to know 💡",
        "Oh, wow 😲",
        "Interesting 🤔",
        "Really 🧐",
        "That's mind-blowing 🤯"
    ]
}
