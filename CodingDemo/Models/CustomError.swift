//
//  CustomError.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import Foundation

enum CustomError: Error, LocalizedError {
    case networking(message: String)
    case input(message: String)

    var localizedDescription: String {
        switch self {
        case .networking(let message): return message
        case .input(let message): return message
        }
    }
}
