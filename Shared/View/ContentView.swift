//
//  ContentView.swift
//  Shared
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import SwiftUI
import Combine

enum LotteryPresenterState {
    case notStarted
    case loading
    case lotteryInProgress(LotteryProgressViewModel)
    case finished(LotteryResultViewModel)
}

struct ContentView: View {
    @ObservedObject var viewModel: ObservableLottery
    @Binding var loadingRequested: Bool

    var body: some View {
        switch $viewModel.model.wrappedValue {
        case .notStarted:
            LotteryLandingView() {
                $loadingRequested.wrappedValue = true
            }

        case .loading:
            LotteryLoadingView()

        case .lotteryInProgress(let viewModel):
            LotteryProgressView(viewModel: viewModel)

        case .finished(let viewModel):
            LotteryResultView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ObservableLottery(model: .loading), loadingRequested: .constant(false))
    }
}
