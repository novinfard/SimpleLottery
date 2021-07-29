//
//  BaseSessionTests.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 29/07/2021.
//

import Foundation

import XCTest
import Combine
@testable import SimpleLottery

/// End-to-End test for BaseSession Implementation
/// Should get disabled in production test environment or CI/CD
class BaseSessionTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsInvalid_returnsError() {
        // given
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let sut = BaseSessionImplementation(urlSession: session)

        let invalidUrl = "http://an-invalid-url"
        let request = URLRequest(url: URL(string: invalidUrl)!)

        let expectation = expectation(description: "BaseSession whenUrlIsInvalid returnsError")

        // when
        var receivedError: Error?
        sut.response(for: request).sink { completion in
            if case .failure(let error) = completion {
                receivedError = error
            }
            expectation.fulfill()
        } receiveValue: { (response: HTTPURLResponse, data: Data) in

        }.store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)

        XCTAssertNotNil(receivedError, "It should get completed with Error")
    }

    func test_whenUrlIsValid_returnsData() {
        // given
        let session = URLSession.shared
        session.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let sut = BaseSessionImplementation(urlSession: session)

        let validUrl = AppConfig.lotteryListEndPoint
        let request = URLRequest(url: URL(string: validUrl)!)

        let expectation = expectation(description: "BaseSession whenUrlIsValid returnsData")

        // when
        var receivedError: Error?
        var receivedResponse: HTTPURLResponse?
        var receivedData: Data?
        sut.response(for: request).sink { completion in
            if case .failure(let error) = completion {
                receivedError = error
            }
            expectation.fulfill()
        } receiveValue: { (response: HTTPURLResponse, data: Data) in
            receivedData = data
            receivedResponse = response
        }.store(in: &subscriptions)

        wait(for: [expectation], timeout: 10)

        XCTAssertNil(receivedError, "It should get completed without Error")
        XCTAssertEqual(receivedResponse?.statusCode, 200)
        XCTAssertNotNil(receivedData)
    }
}
