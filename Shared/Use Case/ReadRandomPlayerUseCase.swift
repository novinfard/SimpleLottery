//
//  ReadRandomPlayerUseCase.swift
//  SimpleLottery (iOS)
//
//  Created by Soheil  Novinfard on 03/07/2021.
//

import Foundation
import Combine

/// The `Read Random Player` use-case emits random player
/// `Load` method should be called to trigger the pipeline
///
protocol ReadRandomPlayerUseCase {
    var modelPublisher: AnyPublisher<LotteryPlayer, Never> { get }
    func updatePlayerList(_: [LotteryPlayer])
    func load()
}

/// Random Player Pipeline configuration settings
///
///  - Parameter maximumRounds: Maximum rounds of emitting data
///  - Parameter updateInterval: Time duration for each round  in seconds
///
struct RandomPlayerPipelineConfiguration {
    let maximumRounds: Int
    let updateInterval: TimeInterval
}

/// Create random pipeline of players based on the given player list
///
///  - Parameter playerList: List of players
///  - Parameter configuration: Random pipeline's configuration
///
class ReadRandomPlayerUseCaseImplementation: ReadRandomPlayerUseCase, ObservableObject {
    private var playerList: [LotteryPlayer]
    private let configuration: RandomPlayerPipelineConfiguration

    var modelPublisher: AnyPublisher<LotteryPlayer, Never> {
        return trigger.eraseToAnyPublisher()
    }

    func updatePlayerList(_ playerList: [LotteryPlayer]) {
        self.playerList = playerList
    }

    private let trigger = PassthroughSubject<LotteryPlayer, Never>()

    func load() {
        self.startTimer()
    }

    private var cancellable: Cancellable?
    private var currentRound = 0

    init(playerList: [LotteryPlayer] = [],
         configuration: RandomPlayerPipelineConfiguration = .defaultConfig) {
        self.playerList = playerList
        self.configuration = configuration
    }

    func startTimer() {
        currentRound = 0
        self.cancellable?.cancel()
        self.cancellable = Timer
            .publish(every: configuration.updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, let selectedPlayer = self.selectRandomPlayer() else { return }
                self.currentRound += 1
                self.trigger.send(selectedPlayer)

                if self.currentRound > self.configuration.maximumRounds {
                    self.trigger.send(completion: .finished)
                    self.cancellable?.cancel()
                }
            }
    }

    private func selectRandomPlayer() -> LotteryPlayer? {
        return playerList.randomElement()
    }

}

extension RandomPlayerPipelineConfiguration {
    static let defaultConfig = RandomPlayerPipelineConfiguration(maximumRounds: 10, updateInterval: 0.4)
}
