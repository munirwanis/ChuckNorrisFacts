//
//  ListFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ListFactsViewModel {
    private let service: FactServiceProtocol
    private let bag = DisposeBag()
    var currentState = BehaviorRelay<ListFactsState>(value: .waitingForInput)
    
    init(service: FactServiceProtocol = FactService()) {
        self.service = service
    }
}


// MARK: - Public methods

extension ListFactsViewModel {
    func getFacts(term: String) {
        currentState.accept(.loading)
        service.getFacts(term: term)
            .subscribe(onNext: { facts in
                self.currentState.accept(.success(self.convert(facts)))
            }, onError: { error in
                let cnError: CNError = (error as? CNError) ?? CNError.internalError
                self.currentState.accept(.error(cnError))
            })
            .disposed(by: self.bag)
    }
}


// MARK: - Private methods

private extension ListFactsViewModel {
    private func convert(_ facts: Facts) -> FactsPresentation {
        return facts.compactMap { FactPresentation(imageURL: $0.iconUrl, factText: $0.value) }
    }
}
