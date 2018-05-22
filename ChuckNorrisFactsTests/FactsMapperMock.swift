//
//  FactsMapperMock.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 23/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

@testable import ChuckNorrisFacts
import Foundation

struct FactsMapperMock: FactsMapperProtocol {
    private var facts = Facts()
    private var shouldThrowError: Bool
    
    func facts(from data: Data) throws -> Facts {
        if shouldThrowError {
            throw CNError.parsePayloadError
        }
        
        return facts
    }
    
    init(fact: Fact) {
        shouldThrowError = false
        facts.append(fact)
    }
    
    init(shouldThrowError: Bool) {
        self.shouldThrowError = shouldThrowError
    }
}
