//
//  ReadLotteryPlayersUseCase.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 06/08/2021.
//

import Foundation
import Combine

///
/// The `Read Lottery Player List` use-case emits list of all lottery players
///
/// `Load` method should be called to trigger the pipeline
///
protocol ReadLotteryPlayersUseCase {
    var modelPublisher: AnyPublisher<[LotteryPlayer], ReadLotteryPlayersUseCaseError> { get }
    func load()
}

enum ReadLotteryPlayersUseCaseError: Error {
    case userRepo(Error)
    case lotteryListRepo(Error)
}


struct ReadLotteryPlayersUseCaseImplementation {
    private let userRepository: UserRepository
    private let lotteryListRepository: LotteryListRepository

    private let trigger = PassthroughSubject<[LotteryPlayer], Never>()

    init(userRepository: UserRepository,
         lotteryListRepository: LotteryListRepository) {
        self.userRepository = userRepository
        self.lotteryListRepository = lotteryListRepository
    }

    var modelPublisher: AnyPublisher<[LotteryPlayer], ReadLotteryPlayersUseCaseError> {
        return Publishers.Zip(
            userRepository
                .modelPublisher
                .mapError { ReadLotteryPlayersUseCaseError.userRepo($0) }
            ,
            lotteryListRepository
                .modelPublisher
                .mapError { ReadLotteryPlayersUseCaseError.lotteryListRepo($0) }
        )
        .map { users, lotteryList in
            LotteryPlayer.mapListFrom(users: users, lotteryList: lotteryList)
        }
        .eraseToAnyPublisher()
    }

    func load() {
        userRepository.load()
        lotteryListRepository.load()
    }
}

extension LotteryPlayer {
    static func mapListFrom(users: [User], lotteryList: [LotteryUser]) -> [LotteryPlayer] {
        return []
    }
}
