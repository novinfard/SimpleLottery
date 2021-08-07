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
        let urlSession = URLSession.shared
        urlSession.configuration.requestCachePolicy = .reloadIgnoringCacheData
        let session = BaseSessionImplementation(urlSession: urlSession)

        let useCase = LotteryUseCaseImplementation(
            randomPlayerUseCase: ReadRandomPlayerUseCaseImplementation(
                playerList: [],
                configuration: .defaultConfig
            ), lotteryPlayerUseCase: ReadLotteryPlayersUseCaseImplementation(
                userRepository: UserRepositoryImplementation(
                    session: session,
                    endpoint: URL(string: AppConfig.userListEndPoint)
                ), lotteryListRepository: LotteryListRepositoryImplementation(
                    session: session,
                    endpoint: URL(string: AppConfig.lotteryListEndPoint)
                )
            )
        )

        presenter = LotteryPresenterImplementation(lotteryUseCase: useCase)
        viewModel = ObservableLottery()
    }

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel, presenter: presenter)
                .onAppear() {
                    cancellable = presenter.modelPublisher.sink { model in
                        $viewModel.model.wrappedValue = model
                    }
                }
        }
    }
}
