//
//  BaseSessionMock.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 30/07/2021.
//

import Foundation
@testable import SimpleLottery
import Combine

class BaseSessionMock: BaseSession {
    private let urlSession: URLSession

    init() {
        let urlSession = URLSession.shared
        urlSession.configuration.requestCachePolicy = .reloadIgnoringCacheData
        self.urlSession = urlSession
    }

    func response(for request: URLRequest) -> AnyPublisher<(response: HTTPURLResponse, data: Data), Error> {
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { (data: Data, response: URLResponse) -> (response: HTTPURLResponse, data: Data) in
                let fakeHttpURLResponse = HTTPURLResponse()
                return (fakeHttpURLResponse, data)
            }
            .eraseToAnyPublisher()
    }
}
