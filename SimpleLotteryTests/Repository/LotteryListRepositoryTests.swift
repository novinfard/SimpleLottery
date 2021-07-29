//
//  LotteryListRepositoryTests.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 28/07/2021.
//

import XCTest
import Combine
@testable import SimpleLottery

class LotteryListRepositoryTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsValid_returnsSuccessfully() {
        let sut = createSUT()
        var receivedUsers = [LotteryUser]()

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
        var receivedUsers = [LotteryUser]()

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

        let user = try? XCTUnwrap(
            receivedUsers.first(where: {$0.userId == 182 }),
            "The user with id `182` should be found in the list"
        )

        XCTAssertEqual(user?.void, true)
    }

    private func createSUT() -> LotteryListRepository {
        let session = BaseSessionMock()
        return LotteryListRepositoryImplementation(
            session: session,
            endpoint: LotteryListRepositoryImplementation.mockUrl()
        )
    }
}

extension LotteryListRepositoryImplementation {
    static func mockUrl() -> URL? {
        return Bundle(for: LotteryListRepositoryTests.self).url(forResource: "usersInLottery", withExtension: "json")
    }
}
