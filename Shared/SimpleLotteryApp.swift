//
//  SimpleLotteryApp.swift
//  Shared
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import SwiftUI
import Combine

@main
struct SimpleLotteryApp: App {
    private let presenter: LotteryPresenter
    @ObservedObject private var viewModel: ObservableLottery
    @State private var cancellable: AnyCancellable?

    init() {
        let useCase = LotteryUseCaseImplementation(
            randomPlayerUseCase: ReadRandomPlayerUseCaseImplementation(
                playerList: LotteryPlayer.mockModelList,
                configuration: .defaultConfig
            )
        )
        presenter = LotteryPresenterImplementation(lotteryUseCase: useCase)
        viewModel = ObservableLottery()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
                .onAppear() {
                    presenter.load()
                    cancellable = presenter.modelPublisher.sink { model in
                        $viewModel.model.wrappedValue = model
                    }
                }
        }
    }
}
