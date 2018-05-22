//
//  FactMapper.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 23/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

protocol FactsMapperProtocol {
    func facts(from data: Data) throws -> Facts
}

struct FactsMapper: FactsMapperProtocol {
    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    func facts(from data: Data) throws -> Facts {
        do {
            let response = try decoder.decode(ResultResponse.self, from: data)
            return response.result
        } catch {
            throw CNError.parsePayloadError
        }
    }
}
