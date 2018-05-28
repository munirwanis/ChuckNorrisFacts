//
//  FactServiceTests.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 22/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

@testable import ChuckNorrisFacts
import Nimble
import Quick
import RxSwift
import RxTest

class FactServiceTests: QuickSpec {
    var bag: DisposeBag!
    
    override func spec() {
        describe("Fact Service") {
            var service: FactServiceProtocol!
            
            beforeEach {
                self.bag = DisposeBag()
            }
            
            describe("api call") {
                context("when there is no connection to internet") {
                    beforeEach {
                        service = FactServiceMock(errorType: .networkError)
                    }
                    
                    it("should throw network error") {
                        var apiError: Error?
                        
                        service.getFacts(term: "some query")
                            .do(onError: { error in
                                apiError = error
                            })
                            .subscribe()
                            .disposed(by: self.bag)
                        
                        expect(apiError as? CNError)
                            .toEventually(equal(CNError.networkError), timeout: 2)
                    }
                }
                
                context("when there is an error") {
                    beforeEach {
                        service = FactServiceMock(errorType: .internalError)
                    }
                    it("should throw internal error") {
                        var apiError: Error?
                        
                        service.getFacts(term: "some query")
                            .do(onError: { error in
                                apiError = error
                            })
                            .subscribe()
                            .disposed(by: self.bag)
                        
                        expect(apiError as? CNError)
                            .toEventually(equal(CNError.internalError), timeout: 2)
                    }
                }
                
                context("when there is something wrong with the request") {
                    beforeEach {
                        service = FactServiceMock(errorType: .badRequestError)
                    }
                    it("should throw bad request error") {
                        var apiError: Error?
                        
                        service.getFacts(term: "some query")
                            .do(onError: { error in
                                apiError = error
                            })
                            .subscribe()
                            .disposed(by: self.bag)
                        

                        expect(apiError as? CNError)
                            .toEventually(equal(CNError.badRequestError), timeout: 2)
                    }
                }
                context("when json is not parsed correctly") {
                    beforeEach {
                        service = FactServiceMock(errorType: .parsePayloadError)
                    }
                    it("should throw parse error") {
                        var apiError: Error?
                        
                        service.getFacts(term: "some query")
                            .do(onError: { error in
                                apiError = error
                            })
                            .subscribe()
                            .disposed(by: self.bag)
                        
                        expect(apiError as? CNError)
                            .toEventually(equal(CNError.parsePayloadError), timeout: 2)
                    }
                }
                
                context("when the request is successful") {
                    let fact = Fact(iconUrl: "someString", id: "someString", url: "someString", value: "value")
                    
                    beforeEach {
                        service = FactServiceMock(fact: fact)
                    }
                    it("should return facts") {
                        var apiFacts = Facts()
                        
                        service.getFacts(term: "some query")
                            .do(onNext: { facts in
                                apiFacts = facts
                            })
                            .subscribe()
                            .disposed(by: self.bag)
                        
                        expect(apiFacts.count).toEventually(equal(1), timeout: 2)
                        expect(apiFacts.first?.value).toEventually(equal(fact.value), timeout: 2)
                    }
                }
            }
        }
    }
}
