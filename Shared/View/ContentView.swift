//
//  ContentView.swift
//  Shared
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import SwiftUI
import Combine

enum LotteryPresenterState {
    case beginning
    case loading
    case errorHappened(String)
    case lotteryInProgress(LotteryProgressViewModel)
    case finished(LotteryResultViewModel)
}

struct ContentView: View {
    @ObservedObject var viewModel: ObservableLottery
    var presenter: LotteryPresenter?

    var body: some View {
        switch $viewModel.model.wrappedValue {
        case .beginning:
            LotteryLandingView() {
                presenter?.load()
            }

        case .errorHappened(let error):
            LotteryLandingView(errorMessage: error) {
                presenter?.load()
            }

        case .loading:
            LotteryLoadingView()

        case .lotteryInProgress(let viewModel):
            LotteryProgressView(viewModel: viewModel)

        case .finished(let viewModel):
            LotteryResultView(viewModel: viewModel) {
                presenter?.startAgain()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ObservableLottery(model: .loading))
    }
}
