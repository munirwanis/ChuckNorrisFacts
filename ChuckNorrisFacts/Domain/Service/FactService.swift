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
    
    private let baseURL: String
    
    func getFacts(term: String) -> Observable<Facts> {
        let encodedTerm = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
        return Alamofire.request("\(baseURL)/jokes/search?query=\(encodedTerm)").rx.responseData()
            .retry(1)
            .map { data in try self.map.facts(from: data) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
    
    init(mapper: FactsMapperProtocol) {
        self.map = mapper
        
        let isTestMode = ProcessInfo.processInfo.arguments.contains("TEST-MODE")
        baseURL = isTestMode ? "http://localhost:8080" : "https://api.chucknorris.io"
    }
}
