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
    @State var loadingRequested: Bool = false

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
            ContentView(viewModel: viewModel, loadingRequested: $loadingRequested)
                .onAppear() {
                    cancellable = presenter.modelPublisher.sink { model in
                        $viewModel.model.wrappedValue = model
                    }
                }
                .onChange(of: loadingRequested) { requested in
                    if requested {
                        presenter.load()
                    }
                }
        }
    }
}
