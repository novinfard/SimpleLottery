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
    let randomPlayerUseCase: ReadRandomPlayerUseCase

    init(randomPlayerUseCase: ReadRandomPlayerUseCase) {
        self.randomPlayerUseCase = randomPlayerUseCase
    }

    var modelPublisher: AnyPublisher<LotteryPresenterState, Never> {
        return randomPlayerUseCase
            .modelPublisher
            .map {
                .lotteryInProgress(LotteryProgressViewModel.mapFrom(player: $0))
            }
            .eraseToAnyPublisher()
    }

    func load() {
        randomPlayerUseCase.load()
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
