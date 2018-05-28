//
//  FactsPresentation.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 28/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

protocol FactsPresentationMapperProtocol {
    func convert(_ facts: Facts) -> FactsPresentation
}

struct FactsPresentationMapper: FactsPresentationMapperProtocol {
    func convert(_ facts: Facts) -> FactsPresentation {
        return facts.compactMap { FactPresentation(imageURL: $0.iconUrl, factText: $0.value) }
    }
}
