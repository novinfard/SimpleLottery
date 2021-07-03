//
//  LotteryPresenter.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import Combine

final class ObservableLottery: ObservableObject {
    @Published var model: LotteryState = .loadingData

    init(model: LotteryState = .notStarted) {
        self.model = model
    }
}

protocol LotteryPresenter {
    var modelPublisher: AnyPublisher<LotteryState, Never> { get }
    func load()
}

class LotteryPresenterImplementation: LotteryPresenter {
    var modelPublisher: AnyPublisher<LotteryState, Never> {
        return Just<LotteryState>(.loadingData).eraseToAnyPublisher()
    }

    func load() {
        // Do some stuff to load the model
    }
}
