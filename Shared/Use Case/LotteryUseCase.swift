//
//  LotteryUseCase.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 27/07/2021.
//

import Foundation
import Combine

enum LotteryUseCaseError: Error {
    case emptyList
    case connectivityIssue
}

enum LotteryUseCaseState {
    case notStarted
    case loadingData
    case errorHappened(LotteryUseCaseError)
    case lotteryInProgress(LotteryPlayer)
    case finished(LotteryPlayer)
}

protocol LotteryUseCase {
    var modelPublisher: AnyPublisher<LotteryUseCaseState, Never> { get }
    func load()
}

class LotteryUseCaseImplementation: LotteryUseCase {
    private let randomPlayerUseCase: ReadRandomPlayerUseCase
    private var cancellable: AnyCancellable?
    private var currentPlayer: LotteryPlayer?

    init(randomPlayerUseCase: ReadRandomPlayerUseCase) {
        self.randomPlayerUseCase = randomPlayerUseCase
        self.trigger.send(.notStarted)
    }

    var modelPublisher: AnyPublisher<LotteryUseCaseState, Never> {
        return trigger.eraseToAnyPublisher()
    }

    private let trigger = PassthroughSubject<LotteryUseCaseState, Never>()

    func load() {
        randomPlayerUseCase.load()

        cancellable = randomPlayerUseCase
            .modelPublisher
            .sink(receiveCompletion: { [weak self] completion in
                guard let player = self?.currentPlayer else {
                    assertionFailure("There should be a player in the pool")
                    return
                }
                self?.trigger.send(.finished((player)))
            }, receiveValue: { [weak self] player in
                self?.currentPlayer = player
                self?.trigger.send(.lotteryInProgress(player))
            })
    }
}
