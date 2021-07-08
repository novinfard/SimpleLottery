//
//  LotteryProgressView.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import SwiftUI

struct LotteryProgressView: View {
    let viewModel: LotteryProgressViewModel

    var body: some View {
        VStack {
            Text("🏆 The winner is:")
                .font(.headline)
            Spacer()
                .frame(height: 20)
            Text(viewModel.descriptionText)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(15)
            Text(viewModel.playerName)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(viewModel.textColor)
            Text("@" + viewModel.playerUsername)
                .foregroundColor(viewModel.textColor)
            Image(viewModel.resultImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
    }
}

struct LotteryProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryProgressView(viewModel: LotteryProgressViewModel.mapFrom(player: .mockModel))
    }
}

struct LotteryProgressViewModel {
    var playerName: String
    var playerUsername: String
    var descriptionText: String
    var resultImageName: String
    var textColor: Color
}
