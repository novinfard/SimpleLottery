//
//  ContentView.swift
//  Shared
//
//  Created by Soheil  Novinfard on 23/02/2021.
//

import SwiftUI
import Combine

enum LotteryState {
    case notStarted
    case loadingData
    case lotteryInProgress(LotteryProgressViewModel)
    case finished(LotteryResultViewModel)
}

struct ContentView: View {
    @ObservedObject var viewModel: ObservableLottery

    var body: some View {
        switch $viewModel.model.wrappedValue {
        case .notStarted:
            LotteryLandingView() {
                $viewModel.model.wrappedValue = .loadingData
            }

        case .loadingData:
            LotteryLoadingView()

        case .lotteryInProgress(let viewModel):
            LotteryProgressView(viewModel: viewModel)

        case .finished(let model):
            LotteryResultView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ObservableLottery())
    }
}
