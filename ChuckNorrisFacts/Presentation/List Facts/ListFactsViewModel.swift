//
//  ListFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
import RxSwift

final class ListFactsViewModel {
    private let service: FactServiceProtocol
    private let bag = DisposeBag()
    var currentState = Variable<ListFactsState>(.waitingForInput)
    
    init(service: FactServiceProtocol = FactService()) {
        self.service = service
    }
}


// MARK: - Public methods

extension ListFactsViewModel {
    func getFacts(term: String) {
        currentState.value = .loading
        service.getFacts(term: term)
            .subscribe(onNext: { facts in
                self.currentState.value = .success(self.convert(facts))
            }, onError: { error in
                let cnError: CNError = (error as? CNError) ?? CNError.internalError
                self.currentState.value = .error(cnError)
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
