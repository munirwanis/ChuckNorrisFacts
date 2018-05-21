//
//  Reactive+Extension.swift
//  ChuckNorrisFacts
//
//  Created by Munir Wanis on 21/05/18.
//  Copyright © 2018 Wanis. All rights reserved.
//

import Alamofire
import RxSwift

extension Request: ReactiveCompatible {}

extension Reactive where Base: DataRequest {
    func responseData() -> Observable<Data> {
        return Observable.create { observer in
            let request = self.base.responseData { response in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
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
