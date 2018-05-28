//
//  ListFactViewModel.swift
//  ChuckNorrisFactsTests
//
//  Created by Munir Wanis on 23/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

@testable import ChuckNorrisFacts
import Nimble
import Quick
import RxBlocking
import RxCocoa
import RxSwift

class ListFactsViewModelTests: QuickSpec {
    
    override func spec() {
        describe("listFactsViewModel") {
            var viewModel: ListFactsViewModel!
            
            context("when state is error") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show bad request eror state") {
                    do {
                        viewModel.getFacts(term: "some query")
                        
                        let state = try viewModel.currentState
                            .toBlocking()
                            .first()!
                        
                        switch state {
                        case .error(let cnError): expect(cnError).toEventually(equal(.badRequestError), timeout: 2)
                        default: fail()
                        }
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
            
            context("when state is waiting for input") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show waiting for input state") {
                    do {
                        
                        Perform.wait(seconds: 0.5) {
                            viewModel.getFacts(term: "some query")
                        }
                        
                        let states = try viewModel.currentState
                            .toBlocking(timeout: 3)
                            .first()
                        
                        expect(states != nil).toEventually(beTruthy(), timeout: 2)
                        
                        var isWaitingForInputState = false
                        switch states! {
                        case .waitingForInput: isWaitingForInputState = true
                        default: isWaitingForInputState = false
                        }
                        
                        expect(isWaitingForInputState).toEventually(beTrue(), timeout: 2)
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
            
            context("when state is loading") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show loading state") {
                    do {
                        Perform.wait(seconds: 0.5) {
                            viewModel.getFacts(term: "some query")
                        }
                        
                        let state = try viewModel.currentState
                            .skip(1)
                            .take(1)
                            .toBlocking(timeout: 3)
                            .first()!
                        
                        var isLoadingState = false
                        
                        switch state {
                        case .loading: isLoadingState = true
                        default: isLoadingState = false
                        }
                        
                        expect(isLoadingState).toEventually(beTrue(), timeout: 2)
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
            
            context("when state is success") {
                beforeEach {
                    let fact = Fact(
                        iconUrl: "someUrl",
                        id: "someId",
                        url: "someURL",
                        value: "someValue"
                    )
                    let service = FactServiceMock(fact: fact)
                    viewModel = ListFactsViewModel(service: service)
                }
                
                it("should return success with facts") {
                    var factsPresentation: FactsPresentation?
                    
                    do {
                        Perform.wait(seconds: 0.5) {
                            viewModel.getFacts(term: "some query")
                        }
                        
                        let state = try viewModel.currentState
                            .asObservable()
                            .skip(2)
                            .take(1)
                            .toBlocking(timeout: 3)
                            .first()!
                        
                        switch state {
                        case .success(let facts): factsPresentation = facts
                        default: fail()
                        }
                        
                        expect(factsPresentation != nil)
                            .toEventually(beTruthy(), timeout: 2)
                        expect(factsPresentation!.count > 0)
                            .toEventually(beTruthy(), timeout: 2)
                        expect(factsPresentation?.first?.isTextLong)
                            .toEventually(beFalsy(), timeout: 2)
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
            
            context("when state is success") {
                beforeEach {
                    let fact = Fact(
                        iconUrl: "someUrl",
                        id: "someId",
                        url: "someURL",
                        value: "some characters with length bigger than fifty, is that possible?"
                    )
                    let service = FactServiceMock(fact: fact)
                    viewModel = ListFactsViewModel(service: service)
                }
                
                it("should return success with long text fact") {
                    var factsPresentation: FactsPresentation?
                    
                    do {
                        Perform.wait(seconds: 0.5) {
                            viewModel.getFacts(term: "some query")
                        }
                        
                        let state = try viewModel.currentState
                            .asObservable()
                            .skip(2)
                            .take(1)
                            .toBlocking(timeout: 3)
                            .first()!
                        
                        switch state {
                        case .success(let facts): factsPresentation = facts
                        default: fail()
                        }
                        
                        expect(factsPresentation != nil)
                            .toEventually(beTruthy(), timeout: 2)
                        expect(factsPresentation!.count > 0)
                            .toEventually(beTruthy(), timeout: 2)
                        expect(factsPresentation?.first?.isTextLong)
                            .toEventually(beTruthy(), timeout: 2)
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
            
            context("when state is empty") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock())
                }
                
                it("should return empty state") {
                    do {
                        Perform.wait(seconds: 0.5) {
                            viewModel.getFacts(term: "some query")
                        }
                        
                        let state = try viewModel.currentState
                            .asObservable()
                            .skip(2)
                            .take(1)
                            .toBlocking(timeout: 3)
                            .first()!
                        
                        var isEmpty = false
                        switch state {
                        case .empty: isEmpty = true
                        default: isEmpty = false
                        }
                        
                        expect(isEmpty).toEventually(beTruthy(), timeout: 2)
                    } catch {
                        print(error)
                        fail()
                    }
                }
            }
        }
    }
}
