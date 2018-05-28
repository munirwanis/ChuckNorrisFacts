//
//  ListFactsState.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 22/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation

enum ListFactsState {
    case waitingForInput, loading
    case success(FactsPresentation)
    case error(CNError)
}


extension ListFactsState: Equatable {
    static func == (lhs: ListFactsState, rhs: ListFactsState) -> Bool {
        switch (lhs, rhs) {
        case (.error(let lhe), .error(let rhe)): return lhe == rhe
        case (.waitingForInput, .waitingForInput), (.loading, .loading): return true
        default:
            return false
        }
    }
}
