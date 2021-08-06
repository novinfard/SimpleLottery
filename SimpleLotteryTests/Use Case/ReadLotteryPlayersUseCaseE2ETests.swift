//
//  ReadLotteryPlayersUseCaseE2ETests.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 06/08/2021.
//

import XCTest
import Combine
@testable import SimpleLottery

// User Repository End-to-End Tests
class ReadLotteryPlayersUseCaseE2ETests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsValid_returnsSuccessfully() {
        let urlSession = URLSession.shared
        urlSession.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let session = BaseSessionImplementation(urlSession: urlSession)

        let userRepo = UserRepositoryImplementation(
            session: session,
            endpoint: URL(string: AppConfig.userListEndPoint)
        )
        let lotteryListRepo = LotteryListRepositoryImplementation(
            session: session,
            endpoint: URL(string: AppConfig.lotteryListEndPoint)
        )
        
        let sut = ReadLotteryPlayersUseCaseImplementation(
            userRepository: userRepo,
            lotteryListRepository: lotteryListRepo
        )

        var users = [LotteryPlayer]()

        let expectation = expectation(description: "Expect to get a list of lottery players")

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

        XCTAssertTrue(!users.isEmpty, "The list of returned lottery players should not be empty")
    }

}
