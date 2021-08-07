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
    case beginning
    case loadingData
    case errorHappened(LotteryUseCaseError)
    case lotteryInProgress(LotteryPlayer)
    case finished(LotteryPlayer)
}

protocol LotteryUseCase {
    var modelPublisher: AnyPublisher<LotteryUseCaseState, Never> { get }
    func load()
    func startAgain()
}

class LotteryUseCaseImplementation: LotteryUseCase {
    private let randomPlayerUseCase: ReadRandomPlayerUseCase
    private let lotteryPlayerUseCase: ReadLotteryPlayersUseCase
    private var cancellable: AnyCancellable?
    private var currentPlayer: LotteryPlayer?

    init(randomPlayerUseCase: ReadRandomPlayerUseCase,
         lotteryPlayerUseCase: ReadLotteryPlayersUseCase) {
        self.randomPlayerUseCase = randomPlayerUseCase
        self.lotteryPlayerUseCase = lotteryPlayerUseCase
        self.trigger.send(.beginning)
    }

    var modelPublisher: AnyPublisher<LotteryUseCaseState, Never> {
        return trigger.eraseToAnyPublisher()
    }

    private let trigger = PassthroughSubject<LotteryUseCaseState, Never>()

    func load() {
        self.trigger.send(.loadingData)
        cancellable = lotteryPlayerUseCase
            .modelPublisher
            .flatMap { lotteryPlayers -> AnyPublisher<LotteryPlayer, Never> in
                self.randomPlayerUseCase.updatePlayerList(lotteryPlayers)
                return self.randomPlayerUseCase.modelPublisher
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion {
                    self?.trigger.send(.errorHappened(.connectivityIssue))
                } else if let player = self?.currentPlayer {
                    self?.trigger.send(.finished((player)))
                } else {
                    self?.trigger.send(.errorHappened(.emptyList))
                }
            }, receiveValue: { [weak self] player in
                self?.currentPlayer = player
                self?.trigger.send(.lotteryInProgress(player))
            })

        lotteryPlayerUseCase.load()
        randomPlayerUseCase.load()
    }

    func startAgain() {
        trigger.send(.beginning)
        currentPlayer = nil
    }
}
