//
//  Network.swift
//  RxSonosLib
//
//  Created by Stefan Renne on 12/03/2018.
//  Copyright © 2018 Uberweb. All rights reserved.
//

import Foundation
import RxSwift

protocol Network {
    func perform(request: URLRequest) -> Single<Data>
}

extension Network {
    func perform(request: URLRequest) -> Single<Data> {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        return session
            .rx
            .dataTask(with: request)
            .do(onDispose: {
                session.invalidateAndCancel()
            })
    }
}

public struct HTTPError: Error {
    let code: Int
    let data: Data

    var localizedDescription: String {
        return "HTTPError \(code): \(data)"
    }
}
func createHTTPError(int: Int, data: Data) -> HTTPError {
    return HTTPError(code: int, data: data)
}

extension Reactive where Base == URLSession {
    func dataTask(with request: URLRequest) -> Single<Data> {
        return Single.create { (event) -> Disposable in
            let task = self.base.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    event(.error(error))
                    return
                }
                
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    event(.error(SonosError.invalidResponse))
                    return
                }

                guard let data = data, data.count > 0 else {
                    event(.error(SonosError.invalidData))
                    return
                }

                guard statusCode == 200 || statusCode == 204 else {
                    event(.error(createHTTPError(int: statusCode, data:data)))
                    return
                }
                event(.success(data))
            }
            task.resume()
            return Disposables.create()
        }
    }
}
