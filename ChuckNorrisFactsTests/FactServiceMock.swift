//
//  FactServiceMock.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 22/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
@testable import ChuckNorrisFacts
import RxSwift

struct FactServiceMock: FactServiceProtocol {
    private var errorType: CNError = .networkError
    private var facts: Facts = Facts()
    private var shouldReturnSuccess: Bool
    
    func getFacts(term: String) -> Observable<Facts> {
        if shouldReturnSuccess {
            return Observable.just(self.facts)
        }
        
        let observable: Observable<Facts> = Observable.create { observer in
            observer.onError(self.errorType)
            return Disposables.create { }
        }
        return observable
    }
    
    init(errorType: CNError) {
        self.shouldReturnSuccess = false
        self.errorType = errorType
    }
    
    init(fact: Fact) {
        self.shouldReturnSuccess = true
        self.facts.append(fact)
    }
    
    init() {
        self.shouldReturnSuccess = true
    }
}
