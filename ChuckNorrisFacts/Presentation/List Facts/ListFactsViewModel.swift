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
    private let mapper: FactsPresentationMapperProtocol
    private let bag = DisposeBag()
    var currentState = BehaviorRelay<ListFactsState>(value: .waitingForInput)
    
    init(service: FactServiceProtocol = FactService(),
         mapper: FactsPresentationMapperProtocol = FactsPresentationMapper()) {
        self.service = service
        self.mapper = mapper
    }
}


// MARK: - Public methods

extension ListFactsViewModel {
    func getFacts(term: String) {
        currentState.accept(.loading)
        service.getFacts(term: term)
            .subscribe(onNext: { facts in
                let state = facts.isEmpty ? ListFactsState.empty : ListFactsState.success(self.mapper.convert(facts))
                self.currentState.accept(state)
            }, onError: { error in
                let cnError: CNError = (error as? CNError) ?? CNError.internalError
                self.currentState.accept(.error(cnError))
            })
            .disposed(by: self.bag)
    }
}
