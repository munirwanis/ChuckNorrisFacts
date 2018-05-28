//
//  Reactive+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Alamofire
import AlamofireImage
import RxSwift

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    func responseData() -> Observable<Data> {
        return Observable.create { observer in
            guard NetworkReachabilityManager()?.isReachable == true else {
                observer.onError(CNError.networkError)
                return Disposables.create()
            }
            
            let request = self.base
                .validate(statusCode: 200..<400)
                .responseData { response in
                    
                    switch response.result {
                    case .success(let value):
                        observer.onNext(value)
                        observer.onCompleted()

                    case .failure(let error):                        
                        if let statusCode = (error as? AFError)?.responseCode {
                            switch statusCode {
                            case (400..<500): observer.onError(CNError.badRequestError)
                            default: observer.onError(CNError.internalError)
                            }
                        }
                        observer.onError(error)
                    }
                }

            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func responseImage() -> Observable<Image> {
        return Observable.create { observer in
            let request = self.base.responseImage { response in
                switch response.result {
                case .success(let image):
                    observer.onNext(image)
                    observer.onCompleted()
                    
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
