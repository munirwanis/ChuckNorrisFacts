//
//  Fact.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

struct Fact: Decodable, Equatable {
    let iconUrl: String
    let id: String
    let url: String
    let value: String

    static func ==(lhs: Fact, rhs: Fact) -> Bool {
        return lhs.iconUrl == rhs.iconUrl &&
            lhs.id == rhs.id &&
            lhs.url == rhs.url &&
            lhs.value == rhs.value
    }
}

typealias Facts = [Fact]
