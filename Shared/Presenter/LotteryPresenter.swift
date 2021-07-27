//
//  LotteryPresenter.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import Combine
import SwiftUI

final class ObservableLottery: ObservableObject {
    @Published var model: LotteryPresenterState

    init(model: LotteryPresenterState = .notStarted) {
        self.model = model
    }
}

protocol LotteryPresenter {
    var modelPublisher: AnyPublisher<LotteryPresenterState, Never> { get }
    func load()
}

class LotteryPresenterImplementation: LotteryPresenter {
    private let lotteryUseCase: LotteryUseCase

    init(lotteryUseCase: LotteryUseCase) {
        self.lotteryUseCase = lotteryUseCase
    }

    var modelPublisher: AnyPublisher<LotteryPresenterState, Never> {
        return lotteryUseCase
            .modelPublisher
            .map {
                switch $0 {
                case .notStarted:
                    return .notStarted
                case .loadingData:
                    return .loading
                case .lotteryInProgress(let player):
                    return .lotteryInProgress(LotteryProgressViewModel.mapFrom(player: player, lotteryDone: false))
                case .finished(let player):
                    return .lotteryInProgress(LotteryProgressViewModel.mapFrom(player: player, lotteryDone: true))
                }
            }
            .eraseToAnyPublisher()
    }

    func load() {
        lotteryUseCase.load()
    }
}

// MARk: View Model Mappers
extension LotteryProgressViewModel {
    static func mapFrom(player: LotteryPlayer, lotteryDone: Bool = false) -> LotteryProgressViewModel {
        let textColor = lotteryDone ?  player.color : .black
        let resultImageName = lotteryDone ? player.resultImageName : ""
        let descriptionText = lotteryDone ? player.resultText : ""

        return LotteryProgressViewModel(
            playerName: player.name,
            playerUsername: player.username,
            descriptionText: descriptionText,
            resultImageName: resultImageName,
            textColor: textColor
        )
    }
}

fileprivate extension LotteryPlayer {
    var color: Color {
        void == true ? .red : .orange
    }

    var resultText: String {
        if void == true {
            return "😢 It was blank! \r\n The election has no winner!"
        } else {
            return "🎉🤑 Congrats! \r\n You're the winner "
        }
    }

    var resultImageName: String {
        void == true ? "oops" : "happy"
    }
}
