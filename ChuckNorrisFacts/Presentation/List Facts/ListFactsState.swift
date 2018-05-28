//
//  ListFactsState.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 22/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

enum ListFactsState {
    case waitingForInput, loading, empty
    case success(FactsPresentation)
    case error(CNError)
}
