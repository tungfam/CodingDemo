//
//  NumbersService.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import RxSwift

protocol NumbersServiceProtocol {
    func getFact(number: Int, type: NumberFactType) -> Observable<NumberFact>
}

class NumbersService: NumbersServiceProtocol {

    static let baseUrlString = "http://numbersapi.com"

    func getFact(number: Int, type: NumberFactType) -> Observable<NumberFact> {
        guard let url = makeFactURL(number: number, type: type)
            else { return .empty() }

        return Observable.create({ observer -> Disposable in

            URLSession.shared.dataTask(with: url) { (data, _, error) in
                if let error = error {
                    observer.onError(error)
                } else if let data = data {
                    if let factText = String(data: data, encoding: String.Encoding.utf8) {
                        observer.onNext(NumberFact(type: type, text: factText, number: number))
                    } else {
                        observer.onError(CustomError.networking(message: "Server error. Can't parse the response."))
                    }
                }
            }
            .resume()

            return Disposables.create()
        })
    }
}

private func makeFactURL(number: Int, type: NumberFactType) -> URL? {
    var requestUrlString = NumbersService.baseUrlString
    switch type {
    case .math: requestUrlString.append("/\(number)/math")
    case .trivia: requestUrlString.append("/\(number)/math")
    }

    guard let url = URL(string: requestUrlString)
        else {
            assertionFailure("Not valid URL")
            return nil
    }
    return url
}
