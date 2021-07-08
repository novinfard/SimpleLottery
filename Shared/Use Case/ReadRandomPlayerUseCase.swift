//
//  ReadRandomPlayerUseCase.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 03/07/2021.
//

import Foundation
import Combine

protocol ReadRandomPlayerUseCase {
    var modelPublisher: AnyPublisher<LotteryPlayer, Never> { get }
    func load()
}

class ReadRandomPlayerUseCaseImplementation: ReadRandomPlayerUseCase, ObservableObject {
    var modelPublisher: AnyPublisher<LotteryPlayer, Never> {
        return Just<LotteryPlayer>(selectedPlayer).eraseToAnyPublisher()
    }

    func load() {
        self.startTimer()
    }

    @Published var selectedPlayer: LotteryPlayer
    @Published var lotteryDone: Bool = false
    private let playerList: [LotteryPlayer]

    private let maximumRounds = 10
    private let updateInterval: TimeInterval = 0.4
    private var cancellable: Cancellable?
    private var currentRound = 0

    init(playerList: [LotteryPlayer]) {
        precondition(!playerList.isEmpty)

        self.playerList = playerList
        self.selectedPlayer = playerList.randomElement()!
    }

    func startTimer() {
        self.cancellable?.cancel()
        self.cancellable = Timer
            .publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let winner = self.selectRandomPlayer() else { return }
                self.selectedPlayer = winner
                self.currentRound += 1

                if self.currentRound > self.maximumRounds {
                    self.lotteryDone = true
                    self.cancellable?.cancel()
                }
            }
    }

    private func selectRandomPlayer() -> LotteryPlayer? {
        let newCandidate = playerList.randomElement()
        guard newCandidate != selectedPlayer else { return selectRandomPlayer() }
        return newCandidate
    }

}
