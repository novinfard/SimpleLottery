//
//  UserRepositoryE2ETests.swift
//  Tests iOS
//
//  Created by Soheil  Novinfard on 27/07/2021.
//

import XCTest
import Combine
@testable import SimpleLottery

// User Repository End-to-End Tests
class UserRepositoryE2ETests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsValid_returnsSuccessfully() {
        let urlSession = URLSession.shared
        urlSession.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let session = BaseSessionImplementation(urlSession: urlSession)
        let sut = UserRepositoryImplementation(
            session: session,
            endpoint: URL(string: AppConfig.userListEndPoint)
        )
        var users = [User]()

        let expectation = expectation(description: "Expect to get a list of users")

        sut.modelPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to return with error \(error)")
                }
                expectation.fulfill()
            }, receiveValue: { receivedUserList in
                users = receivedUserList
            })
            .store(in: &subscriptions)

        sut.load()

        wait(for: [expectation], timeout: 10)

        XCTAssertTrue(!users.isEmpty, "The list of returned users should not be empty")
    }

}
