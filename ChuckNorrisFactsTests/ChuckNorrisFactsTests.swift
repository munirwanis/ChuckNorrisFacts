//
//  ChuckNorrisFactsTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

@testable import ChuckNorrisFacts
import RxSwift
import RxTest
import XCTest
import Quick
import Nimble

class ChuckNorrisFactsTests: XCTestCase {
    
    let bag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let expect = expectation(description: "Pass")
        
        let service = FactServiceMock(errorType: .networkError)
        
        service.getFacts(term: "alguma coisa")
            .do(onError: { error in
                print(error)
                XCTAssert(true)
                expect.fulfill()
            })
            .subscribe()
            .disposed(by: self.bag)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
