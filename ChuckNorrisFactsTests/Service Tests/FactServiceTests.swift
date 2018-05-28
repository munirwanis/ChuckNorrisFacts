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
import RxBlocking
import RxSwift

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
                        
                        do {
                            _ = try service.getFacts(term: "some query")
                                .toBlocking()
                                .first()
                            
                            fail()
                        } catch {
                            expect(error as? CNError)
                                .toEventually(equal(CNError.networkError), timeout: 2)
                        }
                    }
                }
                
                context("when there is an error") {
                    beforeEach {
                        service = FactServiceMock(errorType: .internalError)
                    }
                    it("should throw internal error") {
                        do {
                            _ = try service.getFacts(term: "some query")
                                .toBlocking()
                                .first()
                            
                            fail()
                        } catch {
                            expect(error as? CNError)
                                .toEventually(equal(CNError.internalError), timeout: 2)
                        }
                    }
                }
                
                context("when there is something wrong with the request") {
                    beforeEach {
                        service = FactServiceMock(errorType: .badRequestError)
                    }
                    it("should throw bad request error") {
                        do {
                            _ = try service.getFacts(term: "some query")
                                .toBlocking()
                                .first()
                            
                            fail()
                        } catch {
                            expect(error as? CNError)
                                .toEventually(equal(CNError.badRequestError), timeout: 2)
                        }
                    }
                }
                context("when json is not parsed correctly") {
                    beforeEach {
                        service = FactServiceMock(errorType: .parsePayloadError)
                    }
                    it("should throw parse error") {
                        do {
                            _ = try service.getFacts(term: "some query")
                                .toBlocking()
                                .first()
                            
                            fail()
                        } catch {
                            expect(error as? CNError)
                                .toEventually(equal(CNError.parsePayloadError), timeout: 2)
                        }
                    }
                }
                
                context("when the request is successful") {
                    let fact = Fact(iconUrl: "someString", id: "someString", url: "someString", value: "value")
                    
                    beforeEach {
                        service = FactServiceMock(fact: fact)
                    }
                    it("should return facts") {
                        do {
                            let facts = try service.getFacts(term: "some query")
                                .toBlocking()
                                .first()!
                            
                            expect(facts.count).toEventually(equal(1), timeout: 2)
                            expect(facts.first?.value).toEventually(equal(fact.value), timeout: 2)
                        } catch {
                            print(error)
                            fail()
                        }
                    }
                }
            }
        }
    }
}
