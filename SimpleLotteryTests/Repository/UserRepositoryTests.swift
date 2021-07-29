//
//  UserRepositoryTests.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 28/07/2021.
//

import XCTest
import Combine
@testable import SimpleLottery

class UserRepositoryTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsValid_returnsSuccessfully() {
        let sut = createSUT()
        var receivedUsers = [User]()

        let expectation = expectation(description: "Expect to get a list of users")

        sut.modelPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Failed to return with error \(error)")
                }
                expectation.fulfill()
            }, receiveValue: {
                receivedUsers = $0
            })
            .store(in: &subscriptions)

        sut.load()

        wait(for: [expectation], timeout: 10)

        XCTAssertTrue(!receivedUsers.isEmpty, "The list of returned users should not be empty")
    }

    func test_whenUrlIsValid_parsesUserCorrectly() {
        let sut = createSUT()
        var receivedUsers = [User]()

        let expectation = expectation(description: "Expect to get a list of users parsed correctly")

        sut.modelPublisher
            .sink(receiveCompletion: { completion in
                expectation.fulfill()
            }, receiveValue: {
                receivedUsers = $0
            })
            .store(in: &subscriptions)

        sut.load()

        wait(for: [expectation], timeout: 10)

        let user = try? XCTUnwrap(receivedUsers.first(where: {$0.userId == 10 }))

        XCTAssertEqual(user?.name, "Jack Alexy")
        XCTAssertEqual(user?.username, "JAlex")

        let formatter = DateFormatter.iso8601DateOnly
        XCTAssertEqual(user?.regDate, formatter.date(from: "2020-10-19"))
    }

    private func createSUT() -> UserRepository {
        let urlSession = URLSession.shared
        urlSession.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let session = BaseSessionMock(urlSession: urlSession)
        return UserRepositoryImplementation(
            session: session,
            endpoint: UserRepositoryImplementation.mockUrl()
        )
    }
}

extension UserRepositoryImplementation {
    static func mockUrl() -> URL? {
        return Bundle(for: UserRepositoryTests.self).url(forResource: "users", withExtension: "json")
    }
}


class BaseSessionMock: BaseSession {
    private let urlSession: URLSession

    init(urlSession: URLSession) {
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
