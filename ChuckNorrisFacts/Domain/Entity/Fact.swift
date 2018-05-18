//
//  Fact.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

struct Fact: Decodable {
    let iconUrl: String
    let id: String
    let url: String
    let value: String
}
