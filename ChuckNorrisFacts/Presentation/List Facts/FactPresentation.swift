//
//  ListFactsPresentation.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Alamofire
import AlamofireImage
import RxSwift
import UIKit

struct FactPresentation {
    let imageURL: String
    let factText: String
    let imageObservable: Observable<UIImage>
    
    var textSize: CGFloat {
        return factText.count > 50 ? 14.0 : 16.0
    }

    init(imageURL: String, factText: String) {
        self.imageURL = imageURL
        self.factText = factText

        self.imageObservable = Alamofire.request(self.imageURL).rx.responseImage()
            .retry(1)
            .map { $0 }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
    }
}

typealias FactsPresentation = [FactPresentation]
