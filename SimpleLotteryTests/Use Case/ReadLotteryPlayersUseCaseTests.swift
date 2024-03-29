//
//  ReadLotteryPlayersUseCaseTests.swift
//  SimpleLotteryTests
//
//  Created by Soheil  Novinfard on 06/08/2021.
//

import XCTest
import Combine
@testable import SimpleLottery

class ReadLotteryPlayersUseCaseTests: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    override func tearDown() {
        subscriptions = []
    }

    func test_whenUrlIsValid_parsesUserCorrectly() {
        let session = BaseSessionMock()
        let userRepo = UserRepositoryImplementation(
            session: session,
            endpoint: UserRepositoryImplementation.mockUrl()
        )
        let lotteryListRepo = LotteryListRepositoryImplementation(
            session: session,
            endpoint: LotteryListRepositoryImplementation.mockUrl()
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
        XCTAssertEqual(users.count, 4)

        let lotteryUser = try? XCTUnwrap(users.first { $0.userId == 10 })
        XCTAssertEqual(lotteryUser?.name, "Jack Alexy")
        XCTAssertEqual(lotteryUser?.username, "JAlex")

        let formatter = DateFormatter.iso8601DateOnly
        XCTAssertEqual(lotteryUser?.regDate, formatter.date(from: "2020-10-19"))
        XCTAssertEqual(lotteryUser?.void, false)
    }

    func test_whenUserRepoReturnsEmpty_returnsEmpty() {
        let sut = createSUT(users: [])

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

        XCTAssertTrue(users.isEmpty, "The list of returned lottery players should be empty")
    }

    func test_whenUserRepoReturnsOneValue_returnsOneValue() {
        let sut = createSUT(users: [.dummyUserId10])

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

        XCTAssertEqual(users.count, 1, "The list of returned lottery players should contain 1 item")
    }

    func test_whenUserRepoReturnsDuplicateValues_returnsSingleValue() {
        let sut = createSUT(users: [.dummyUserId10, .dummyUserId10])

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

        XCTAssertEqual(users.count, 1, "The list of returned lottery players should contain 1 item")
    }

    private func createSUT(users: [User]) -> ReadLotteryPlayersUseCase {
        let session = BaseSessionMock()
        let userRepo = StubUserRepository(users: users)
        let lotteryListRepo = LotteryListRepositoryImplementation(
            session: session,
            endpoint: LotteryListRepositoryImplementation.mockUrl()
        )

        return ReadLotteryPlayersUseCaseImplementation(
            userRepository: userRepo,
            lotteryListRepository: lotteryListRepo
        )
    }

}

struct StubUserRepository: UserRepository {
    private let users: [User]
    init(users: [User] = []) {
        self.users = users
    }

    var modelPublisher: AnyPublisher<[User], UserRepositoryError> {
        return Just<[User]>(users)
            .setFailureType(to: UserRepositoryError.self)
            .eraseToAnyPublisher()
    }

    func load() { }
}

extension User {
    static let dummyUserId10 = User(
        userId: 10,
        name: "Dummy Name 10",
        username: "Dummy User Name 10",
        regDate: Date()
    )
}
