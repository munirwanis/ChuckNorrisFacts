//
//  FactsService.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 18/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

struct FactService {
    func get() {
        Alamofire.request("https://api.chucknorris.io/jokes/random").responseData { response in
            
        }
    }
}
