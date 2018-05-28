//
//  FactServiceMock.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 22/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

<<<<<<< HEAD
@testable import ChuckNorrisFacts
import RxSwift

struct FactServiceMock: FactServiceProtocol {
    private var errorType: CNError = .networkError
    private var facts: Facts = Facts()
    private var shouldReturnSuccess: Bool
    
    func getFacts(term: String) -> Observable<Facts> {
        if shouldReturnSuccess {
=======
import Foundation
@testable import ChuckNorrisFacts
import RxSwift


enum RequestErrorTypes: Error {
    case none, networkError, internalError, badRequestError
}

struct FactServiceMock: FactServiceProtocol {
    var errorType: RequestErrorTypes = .networkError
    let facts: Facts = {
        return [Fact(iconUrl: "someString", id: "someString", url: "someString", value: "value")]
    }()
    
    func getFacts(term: String) -> Observable<Facts> {
        if errorType == .none {
>>>>>>> 4b82a2d... # This is a combination of 5 commits.
            return Observable.just(self.facts)
        }
        
        let observable: Observable<Facts> = Observable.create { observer in
            observer.onError(self.errorType)
            return Disposables.create { }
        }
        return observable
    }
    
<<<<<<< HEAD
    init(errorType: CNError) {
        self.shouldReturnSuccess = false
        self.errorType = errorType
    }
    
    init(fact: Fact) {
        self.shouldReturnSuccess = true
        self.facts.append(fact)
    }
=======
    init(errorType: RequestErrorTypes) {
        self.errorType = errorType
    }
>>>>>>> 4b82a2d... # This is a combination of 5 commits.
}
