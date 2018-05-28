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
import RxSwift
import RxTest

class ListFactsViewModelTests: QuickSpec {
    var bag: DisposeBag!
    
    override func spec() {
        describe("listFactsViewModel") {
            var viewModel: ListFactsViewModel!
            
            beforeEach {
                self.bag = DisposeBag()
            }
            
            context("when state is error") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show bad request eror state") {
                    var currentState: ListFactsState!
                    
                    viewModel.currentState
                        .asObservable()
                        .do(onNext: { state in currentState = state; print(state) })
                        .subscribe()
                        .disposed(by: self.bag)
                    
                    viewModel.getFacts(term: "some query")
                    
                    expect(currentState)
                        .toEventually(equal(ListFactsState.error(.badRequestError)), timeout: 2)
                }
            }
            
            context("when state is waiting for input") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show waiting for input state") {
                    var currentState: ListFactsState!
                    
                    viewModel.currentState
                        .asObservable()
                        .distinctUntilChanged({ (lhs, _) -> Bool in
                            lhs == .waitingForInput
                        })
                        .do(onNext: { state in currentState = state; print(state) })
                        .subscribe()
                        .disposed(by: self.bag)
                    
                    viewModel.getFacts(term: "some query")
                    
                    expect(currentState)
                        .toEventually(equal(ListFactsState.waitingForInput), timeout: 2)
                }
            }
            
            context("when state is loading") {
                beforeEach {
                    viewModel = ListFactsViewModel(service: FactServiceMock(errorType: .badRequestError))
                }
                
                it("should show loading state") {
                    var currentState: ListFactsState!
                    
                    viewModel.currentState
                        .asObservable()
                        .distinctUntilChanged({ (lhs, _) -> Bool in
                            lhs == .loading
                        })
                        .do(onNext: { state in currentState = state; print(state) })
                        .subscribe()
                        .disposed(by: self.bag)
                    
                    viewModel.getFacts(term: "some query")
                    
                    expect(currentState)
                        .toEventually(equal(ListFactsState.loading), timeout: 2)
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
                    
                    viewModel.currentState
                        .asObservable()
                        .distinctUntilChanged({ (lhs, _) -> Bool in
                            switch lhs {
                            case .success(_): return true
                            default: return false
                            }
                        })
                        .do(onNext: { state in
                            switch state {
                            case .success(let facts): factsPresentation = facts
                            default: break
                            }
                        })
                        .subscribe()
                        .disposed(by: self.bag)
                    
                    viewModel.getFacts(term: "some query")
                    
                    expect(factsPresentation != nil)
                        .toEventually(beTruthy(), timeout: 2)
                    expect(factsPresentation!.count > 0)
                        .toEventually(beTruthy(), timeout: 2)
                    expect(factsPresentation?.first?.isTextLong)
                        .toEventually(beFalsy(), timeout: 2)
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
                    
                    viewModel.currentState
                        .asObservable()
                        .distinctUntilChanged({ (lhs, _) -> Bool in
                            switch lhs {
                            case .success(_): return true
                            default: return false
                            }
                        })
                        .do(onNext: { state in
                            switch state {
                            case .success(let facts): factsPresentation = facts
                            default: break
                            }
                        })
                        .subscribe()
                        .disposed(by: self.bag)
                    
                    viewModel.getFacts(term: "some query")
                    
                    expect(factsPresentation != nil)
                        .toEventually(beTruthy(), timeout: 2)
                    expect(factsPresentation!.count > 0)
                        .toEventually(beTruthy(), timeout: 2)
                    expect(factsPresentation?.first?.isTextLong)
                        .toEventually(beTruthy(), timeout: 2)
                }
            }
        }
    }
}
