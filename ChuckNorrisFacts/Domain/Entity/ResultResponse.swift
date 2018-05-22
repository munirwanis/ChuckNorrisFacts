//
//  ResultResponse.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 24/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

struct ResultResponse: Decodable {
    let total: Int
    let result: Facts
}
