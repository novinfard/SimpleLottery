//
//  BaseSession.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 29/07/2021.
//

import Foundation
import Combine

protocol BaseSession {
    func response(for request: URLRequest) -> AnyPublisher<(response: HTTPURLResponse, data: Data), Error>
}

class BaseSessionImplementation: BaseSession {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func response(for request: URLRequest) -> AnyPublisher<(response: HTTPURLResponse, data: Data), Error> {
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) -> (response: HTTPURLResponse, data: Data) in
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    throw URLError(.cannotParseResponse)
                }

                return (httpURLResponse, data)
            }
            .eraseToAnyPublisher()
    }
}
