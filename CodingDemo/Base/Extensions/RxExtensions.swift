//
//  RxExtensions.swift
//  CodingDemo
//
//  Created by Tung Fam on 10/26/18.
//  Copyright © 2018 Tung Fam. All rights reserved.
//

import RxSwift

import RxSwift

protocol OptionalType {
    associatedtype Wrapped
    var optional: Wrapped? { get }
}

extension Optional: OptionalType {
    var optional: Wrapped? { return self }
}

extension Observable where Element: OptionalType {
    func ignoreNil() -> Observable<Element.Wrapped> {
        return flatMap { value in
            value.optional.map { Observable<Element.Wrapped>.just($0) } ?? Observable<Element.Wrapped>.empty()
        }
    }
}

extension Observable {
    func voidValues() -> Observable<Void> {
        return map { _ in () }
    }

    func observeForUI() -> Observable<E> {
        return observeOn(MainScheduler.instance)
    }
}
