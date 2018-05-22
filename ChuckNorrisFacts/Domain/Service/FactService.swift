//
//  FactsService.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Alamofire
import Foundation
import RxSwift

protocol FactServiceProtocol {
    func getFacts(term: String) -> Observable<Facts>
}

struct FactService: FactServiceProtocol {
    let map: FactsMapperProtocol
    
    func getFacts(term: String) -> Observable<Facts> {
        return Alamofire.request("https://api.chucknorris.io/jokes/search?query=\(term)").rx.responseData()
            .retry(1)
            .map { data in try self.map.facts(from: data) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    init(mapper: FactsMapperProtocol = FactsMapper()) {
        self.map = mapper
    }
}
