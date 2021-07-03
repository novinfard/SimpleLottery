//
//  LotteryProgressView.swift
//  SimpleLottery
//
//  Created by Soheil  Novinfard on 23/06/2021.
//

import SwiftUI

struct LotteryProgressView: View {
    @ObservedObject var electionPublisher = LotteryRandomPublisher(playerList: [])

    var body: some View {
        VStack {
            Text("🏆 The winner is:")
                .font(.headline)
            Spacer()
                .frame(height: 20)
            Text(descriptionText)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding(15)
            Text(electionPublisher.winner.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(textColor)
            Text("@" + electionPublisher.winner.username)
                .foregroundColor(textColor)
            Image(resultImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
        }
    }

    var textColor: Color {
        guard self.electionPublisher.lotteryDone else { return .black }
        return self.electionPublisher.winner.color
    }

    var resultImageName: String {
        guard self.electionPublisher.lotteryDone else { return "" }
        return self.electionPublisher.winner.resultImageName
    }

    var descriptionText: String {
        guard electionPublisher.lotteryDone else { return "" }
        return electionPublisher.winner.resultText
    }
}

struct LotteryProgressView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryProgressView()
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
