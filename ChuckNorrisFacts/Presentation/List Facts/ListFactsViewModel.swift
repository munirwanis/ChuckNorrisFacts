//
//  ListFactsViewModel.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
import RxSwift

class ListFactsViewModel {
    let service = FactService()
    
    var presentation: Observable<[FactPresentation]>
    
    init() {
        presentation = service.getFacts(term: "")
            .map { facts in ListFactsViewModel.convert(facts) }
            .observeOn(MainScheduler.instance)        
    }
    
    private static func convert(_ facts: Facts) -> [FactPresentation] {
        return facts.compactMap { FactPresentation(imageURL: $0.iconUrl, factText: $0.value) }
    }
}
